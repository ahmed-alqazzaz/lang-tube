mod data;
mod regex;
mod logger;

use ::regex::NoExpand;
use scraper::Html;
use rayon::prelude::*;

use self::regex::*;
pub use self::data::*;



pub fn parse_subtitles(raw_subtitles: String) -> Vec<ParsedSubtitle> {
    let mut cleaned_subtitles = FILE_CLEANUP_REGEX.replace_all(&raw_subtitles, "").to_string();
    cleaned_subtitles =  APOSTROPHE_REGEX.replace_all(&cleaned_subtitles, "'").to_string();
    cleaned_subtitles =  LONG_SPACE_REGEX.replace_all(&cleaned_subtitles, " ").to_string();
    cleaned_subtitles = QUOTE_REGEX.replace_all(&cleaned_subtitles, NoExpand("\"")).to_string();
    cleaned_subtitles.split("</text>")
        .filter(|line| !line.trim().is_empty())
        .collect::<Vec<_>>()
        .par_iter()
        .filter_map(|line| {
            match convert_raw_line_to_subtitle(line) {
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


fn convert_raw_line_to_subtitle(line: &str) -> Option<ParsedSubtitle> {
    let start_string = LINE_START_REGEX.captures(line)?.get(1)?.as_str();
    let duration_string = match LINE_DURATION_REGEX.captures(line) {
        Some(captures) => captures.get(1).unwrap().as_str(),
        None => "0",
    };
    let  html_text = LINE_CLEANUP_REGEX.replace_all(line, "").to_string();
    
    
    let start = parse_duration(start_string)?;
    let duration = parse_duration(duration_string)?;
    let text = strip_html_tags(&html_text);

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