mod readability;
use readability::{lix_index,rix_index,flesch_reading_ease,automated_readability_index,coleman_liau_index,syllable_counter};

pub fn calculate_subtitle_complexity(text: String) -> ReadabilityScore {
    let lix_index = lix_index(&text);
    let rix_index = rix_index(&text);
    let flesch_reading_ease = flesch_reading_ease(&text);
    let automated_readability_index = automated_readability_index(&text);
    let coleman_liau_index = coleman_liau_index(&text);
    
    ReadabilityScore {
        lix_index,
        rix_index,
        flesch_reading_ease,
        automated_readability_index,
        coleman_liau_index,
    }
}

pub fn count_syllables(text: String) -> i64{
    syllable_counter(&text) as i64
}

pub struct ReadabilityScore {
    pub lix_index: f64,
    pub rix_index: f64,
    pub flesch_reading_ease: f64,
    pub automated_readability_index: f64,
    pub coleman_liau_index: f64,
}

