
use rayon::prelude::*;
use regex::Regex; 

use ::regex::NoExpand;
use scraper::Html;
use crate::api::{logger, ParsedSubtitle, RustDuration};


pub struct Srv1Parser {
    line_start_regex: Regex,
    line_duration_regex: Regex,
    line_cleanup_regex: Regex,
    apostrophe_regex: Regex,
    quote_regex: Regex,
    long_space_regex: Regex,
    file_cleanup_regex: Regex,
}



impl Srv1Parser {
    pub fn new() -> Self {
        Self {
            line_start_regex: Regex::new(r#"start="([\d.]+)""#).unwrap(),
            line_duration_regex: Regex::new(r#"dur="([\d.]+)""#).unwrap(),
            line_cleanup_regex: Regex::new(r#"<text[^>]*>|&|<[^>]*>"#).unwrap(),
            apostrophe_regex: Regex::new(r#"amp;#39;"#).unwrap(),
            quote_regex: Regex::new(r#"amp;quot;"#).unwrap(),
            long_space_regex: Regex::new(r#" {2,}|\n"#).unwrap(),
            file_cleanup_regex: Regex::new(r#"(?:<\?xml version="1\.0" encoding="utf-8" ?>)?<transcript>|</transcript>"#).unwrap(),
        }
    }
    pub fn parse_subtitles(&self,raw_subtitles: String) -> Vec<ParsedSubtitle> {
        let cleaned_subtitles = self.clean_subtitles(&raw_subtitles);
        cleaned_subtitles.split("</text>")
            .filter(|line| !line.trim().is_empty())
            .collect::<Vec<_>>()
            .par_iter()
            .filter_map(|line| {
                match self.convert_raw_line_to_subtitle(line) {
                    Some(subtitle) => Some(subtitle),
                    None => {
                        logger::log(&format!("Failed to convert line to subtitle: {}", line));
                        logger::log(&raw_subtitles);
                        None
                    }
                }
            })
            .collect()
    }

    fn clean_subtitles(&self, raw_subtitles: &str) -> String {
        let mut cleaned_subtitles = self.file_cleanup_regex.replace_all(raw_subtitles, "").to_string();
        cleaned_subtitles = self.apostrophe_regex.replace_all(&cleaned_subtitles, "'").to_string();
        cleaned_subtitles = self.long_space_regex.replace_all(&cleaned_subtitles, " ").to_string();
        cleaned_subtitles = self.quote_regex.replace_all(&cleaned_subtitles, NoExpand("\"")).to_string();
        cleaned_subtitles
    }

    fn convert_raw_line_to_subtitle(&self, line: &str) -> Option<ParsedSubtitle> {
        let start_string = self.line_start_regex.captures(line)?.get(1)?.as_str();
        let duration_string = match self.line_duration_regex.captures(line) {
            Some(captures) => captures.get(1).unwrap().as_str(),
            None => "0",
        };
        let html_text = self.line_cleanup_regex.replace_all(line, "").to_string();
        
        let start = Self::parse_duration(start_string)?;
        let duration = Self::parse_duration(duration_string)?;
        let text = Self::strip_html_tags(&html_text);

        Some(ParsedSubtitle {
            start,
            end: start + duration,
            text,
        })
    }

    fn parse_duration(raw_duration: &str) -> Option<RustDuration> {
        let parts: Vec<&str> = raw_duration.split('.').collect();
        let seconds = parts.get(0)?.parse::<u64>().ok()?;
        let milliseconds = if parts.len() < 2 { 0 } else { parts.get(1)?.parse::<u64>().ok()? };

        Some(RustDuration{
            secs: seconds,
            millis: milliseconds,
        })
    }
    fn strip_html_tags(html: &str) -> String {
        let fragment = Html::parse_document(html);
        fragment.root_element().text().collect::<String>()
    }
}