mod data;

use regex::Regex;
use scraper::Html;
use lazy_static::lazy_static; 
use rayon::prelude::*;

pub use self::data::*;

lazy_static! {
    static ref LINE_START_REGEX: Regex = Regex::new(r#"start="([\d.]+)""#).unwrap();
    static ref LINE_DURATION_REGEX: Regex = Regex::new(r#"dur="([\d.]+)""#).unwrap();
    static ref LINE_CLEANUP_REGEX: Regex = Regex::new(r#"<text[^>]*>|&|<[^>]*>"#).unwrap();
    static ref FILE_CLEANUP_REGEX: Regex = Regex::new(r#"(?:<\?xml version="1\.0" encoding="utf-8" ?>)?<transcript>|</transcript>"#).unwrap();
}

pub fn parse_subtitles(raw_subtitles: String) -> Vec<ParsedSubtitle> {
    let cleaned_subtitles = FILE_CLEANUP_REGEX.replace_all(&raw_subtitles, "");
    cleaned_subtitles.split("</text>")
        .filter(|line| !line.trim().is_empty())
        .collect::<Vec<_>>()
        .par_iter()
        .map(|line| convert_raw_line_to_subtitle(line))
        .collect()
}

fn convert_raw_line_to_subtitle(line: &str) -> ParsedSubtitle {
    let start_string = LINE_START_REGEX.captures(line).unwrap().get(1).unwrap().as_str();
    let duration_string = LINE_DURATION_REGEX.captures(line).unwrap().get(1).unwrap().as_str();
    let html_text = LINE_CLEANUP_REGEX.replace_all(line, "");
    
    let start = parse_duration(start_string);
    let duration = parse_duration(duration_string);
    let text = strip_html_tags(&html_text);

    ParsedSubtitle {
        start,
        end: start + duration,
        text,
    }
}

fn parse_duration(raw_duration: &str) -> RustDuration {
    let parts: Vec<&str> = raw_duration.split('.').collect();
    let seconds = parts[0].parse::<u64>().unwrap();
    let milliseconds = if parts.len() < 2 { 0 } else { parts[1].parse::<u64>().unwrap() };

    RustDuration{
        secs: seconds,
        millis: milliseconds,
    }
}

fn strip_html_tags(html: &str) -> String {
    let fragment = Html::parse_document(html);
    fragment.root_element().text().collect::<String>()
}


