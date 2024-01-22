pub use lazy_static::lazy_static;
pub use regex::Regex;
pub use nnsplit::{NNSplit, NNSplitOptions};
pub use super::syllable_counter::SyllableCounter;

lazy_static! {
    pub static ref ALPHABETIC_REGEX: Regex = Regex::new(r"\P{Alphabetic}").unwrap();
    pub static ref SYLLABLE_COUNTER: SyllableCounter = SyllableCounter::new();
    pub static ref SPLITTER: Result<NNSplit, String> =
        NNSplit::load("en", NNSplitOptions::default()).map_err(|e| e.to_string());
}