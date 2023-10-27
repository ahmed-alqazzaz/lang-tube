
use lazy_static::lazy_static;
use regex::Regex; 

lazy_static! {
    pub static ref LINE_START_REGEX: Regex = Regex::new(r#"start="([\d.]+)""#).unwrap();
    pub static ref LINE_DURATION_REGEX: Regex = Regex::new(r#"dur="([\d.]+)""#).unwrap();
    pub static ref LINE_CLEANUP_REGEX: Regex = Regex::new(r#"<text[^>]*>|&|<[^>]*>|\n"#).unwrap();
    pub static ref APOSTROPHE_REGEX: Regex = Regex::new(r#"amp;#39;"#).unwrap();
    pub static ref QUOTE_REGEX: Regex = Regex::new(r#"amp;quot;"#).unwrap();
    pub static ref LONG_SPACE_REGEX : Regex =  Regex::new(r#" {2,}"#).unwrap();
    pub static ref FILE_CLEANUP_REGEX: Regex = Regex::new(r#"(?:<\?xml version="1\.0" encoding="utf-8" ?>)?<transcript>|</transcript>"#).unwrap();
}