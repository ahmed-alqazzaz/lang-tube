
use serde_json::Value;
use rayon::prelude::*;

use crate::api::{ParsedSubtitle, RustDuration};

pub struct YouTubeTimedTextParser;

impl YouTubeTimedTextParser {
    pub fn new() -> Self {
        Self {}
    }

    pub fn parse_subtitles(&self, raw_subtitles: String) -> Vec<ParsedSubtitle> {
        let json: Result<Value, _> = serde_json::from_str(&raw_subtitles);
        let events = match json {
            Ok(j) => j["events"].as_array().unwrap_or(&Vec::new()).clone(),
            Err(_) => Vec::new(),
        };
        events
            .par_iter()
            .filter_map(|event| {
                let text = event["segs"]
                    .as_array()
                    .unwrap_or(&Vec::new())
                    .iter()
                    .filter_map(|seg| seg["utf8"].as_str())
                    .collect::<Vec<_>>()
                    .join("");
                if text.trim().is_empty() || text == "\n" {
                    return None;
                }
                let start = RustDuration::from_milliseconds(event["tStartMs"].as_u64().unwrap_or(0));
                let duration = RustDuration::from_milliseconds(event["dDurationMs"].as_u64().unwrap_or(0));
                let end = start + duration;
                Some(ParsedSubtitle { start, end, text })
            })
            .collect()
    }
}
