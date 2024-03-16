pub mod data;
mod parsers;
mod logger;

use crate::api::parsers::*;

pub use self::data::*;

use lazy_static::lazy_static;

lazy_static! {
    static ref SRV1_PARSER: Srv1Parser = Srv1Parser::new();
    static ref YOUTUBE_TIMED_TEXT_PARSER: YouTubeTimedTextParser = YouTubeTimedTextParser::new();
}

pub struct SubtitlesParser;

impl SubtitlesParser {
    pub fn parse_srv1(raw_subtitles: String) -> Vec<ParsedSubtitle> {
        SRV1_PARSER.parse_subtitles(raw_subtitles)
    }

    pub fn parse_youtube_timed_text(raw_subtitles: String) -> Vec<ParsedSubtitle> {
       YOUTUBE_TIMED_TEXT_PARSER.parse_subtitles(raw_subtitles)
    }
}


