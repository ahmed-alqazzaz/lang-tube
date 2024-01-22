pub use std::collections::HashMap;

pub use self::readability_score::ReadabilityScore;
pub use self::readability_score::text_metrics::TextMetrics;
use self::readability_score::lazy_static::SYLLABLE_COUNTER;

use serde_json::json;
pub mod readability_score;

pub fn calculate_text_complexity(text: String) -> u32 {
    let map = ReadabilityScore::new(&text).to_map();
    json!(map).to_string();
    8
}

pub fn count_syllables(text: String) -> String{
    let map = ReadabilityScore::new(&text).to_map();
    json!(map).to_string()
}



