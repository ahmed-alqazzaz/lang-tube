mod readability;
use readability::{lix_index,rix_index,flesch_reading_ease,automated_readability_index,coleman_liau_index,syllable_counter};

pub fn calculate_subtitle_complexity(text: String) -> ReadbilityScore {
    let lix_index = lix_index(&text);
    let rix_index = rix_index(&text);
    let flesch_reading_ease = flesch_reading_ease(&text);
    let automated_readability_index = automated_readability_index(&text);
    let coleman_liau_index = coleman_liau_index(&text);
    
    ReadbilityScore {
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

pub struct ReadbilityScore {
    pub lix_index: f64,
    pub rix_index: f64,
    pub flesch_reading_ease: f64,
    pub automated_readability_index: f64,
    pub coleman_liau_index: f64,
}


impl ReadbilityScore {
    pub fn indices_list(&self) -> Vec<f64> {
        vec![
            self.lix_index,
            self.rix_index,
            self.flesch_reading_ease,
            self.automated_readability_index,
            self.coleman_liau_index,
        ]
    }
    // return true if the the current object has 
    // a higher number of  lower complexity indices
    pub fn compare_to(&self, other: ReadbilityScore) -> bool{
        let self_indices = self.indices_list();
        let other_indices = other.indices_list();

         // Count the number of lower indices
         let mut count: f32 = 0.0;
         for i in 0..self_indices.len() {
             if self_indices[i] < other_indices[i] {
                 count += 1.0;
             }
         }
         count  >= (self_indices.len() as f32 /2.0)
    }
}


