use std::collections::HashMap;

use self::text_metrics::TextMetrics;

mod sentence_tokenizer;
pub mod syllable_counter;
pub mod text_metrics;

pub struct ReadabilityScore {
    pub raw_metrics: TextMetrics,
    pub lix_index: f64,
    pub rix_index: f64,
    pub flesch_kincaid_grade: f64,
    pub automated_readability_index: f64,
    pub coleman_liau_index: f64,
    pub gunning_fox_index: f64,
    pub smog_index: f64,
}

impl ReadabilityScore {
    pub fn to_map(&self) -> HashMap<String, f64> {
        let mut map = HashMap::new();

        map.insert("lix_index".to_string(), self.lix_index);
        map.insert("rix_index".to_string(), self.rix_index);
        map.insert(
            "flesch_kincaid_grade".to_string(),
            self.flesch_kincaid_grade,
        );
        map.insert(
            "automated_readability_index".to_string(),
            self.automated_readability_index,
        );
        map.insert("coleman_liau_index".to_string(), self.coleman_liau_index);
        map.insert("gunning_fox_index".to_string(), self.gunning_fox_index);
        map.insert("smog_index".to_string(), self.smog_index);

        // Include metrics map from TextMetrics
        map.extend(self.raw_metrics.to_map());

        map
    }
}

impl ReadabilityScore {
    pub fn new(text: &str, language: &str, cache_dir: Option<&str>) -> Result<Self, String> {
        let raw_metrics = TextMetrics::new(text, language, cache_dir)?;
        let lix_index = Self::calculate_lix_index(&raw_metrics);
        let rix_index = Self::calculate_rix_index(&raw_metrics);
        let coleman_liau_index = Self::calculate_coleman_liau_index(&raw_metrics);
        let automated_readability_index = Self::calculate_ari(&raw_metrics);
        let flesch_kincaid_grade = Self::calculate_flesch_kincaid_grade(&raw_metrics);
        let gunning_fox_index = Self::calculate_gunning_fog_index(&raw_metrics);
        let smog_index = Self::calculate_smog_index(&raw_metrics);
        let score = Self {
            raw_metrics,
            lix_index,
            rix_index,
            flesch_kincaid_grade,
            automated_readability_index,
            coleman_liau_index,
            gunning_fox_index,
            smog_index,
        };
        Ok(score)
    }

    fn calculate_lix_index(metrics: &TextMetrics) -> f64 {
        let words_count = metrics.words_count as f64;
        let sentences_count = metrics.sentences_count as f64;
        let long_words_count = metrics.long_words_count as f64;

        if sentences_count > 0.0 {
            (words_count / sentences_count) + (long_words_count * 100.0 / words_count)
        } else {
            0.0
        }
    }

    fn calculate_rix_index(metrics: &TextMetrics) -> f64 {
        // new function
        let long_words_count = metrics.long_words_count as f64;
        let sentences_count = metrics.sentences_count as f64;

        if sentences_count > 0.0 {
            long_words_count / sentences_count
        } else {
            0.0
        }
    }

    fn calculate_coleman_liau_index(metrics: &TextMetrics) -> f64 {
        // new function
        let chars_count = metrics.chars_count as f64;
        let words_count = metrics.words_count as f64;
        let sentences_count = metrics.sentences_count as f64;

        if words_count > 0.0 {
            let l = (chars_count / words_count) * 100.0;
            let s = (sentences_count / words_count) * 100.0;
            0.0588 * l - 0.296 * s - 15.8
        } else {
            0.0
        }
    }

    fn calculate_ari(metrics: &TextMetrics) -> f64 {
        // new function
        let chars_count = metrics.chars_count as f64;
        let words_count = metrics.words_count as f64;
        let sentences_count = metrics.sentences_count as f64;

        if words_count > 0.0 && sentences_count > 0.0 {
            4.71 * (chars_count / words_count) + 0.5 * (words_count / sentences_count) - 21.43
        } else {
            0.0
        }
    }

    fn calculate_flesch_kincaid_grade(metrics: &TextMetrics) -> f64 {
        // new function
        let words_count = metrics.words_count as f64;
        let sentences_count = metrics.sentences_count as f64;
        let avg_syl_count = metrics.avg_syl_count;

        if words_count > 0.0 && sentences_count > 0.0 {
            0.39 * (words_count / sentences_count) + 11.8 * avg_syl_count - 15.59
        } else {
            0.0
        }
    }

    fn calculate_gunning_fog_index(metrics: &TextMetrics) -> f64 {
        // new function
        let words_count = metrics.words_count as f64;
        let sentences_count = metrics.sentences_count as f64;
        let long_words_count = metrics.long_words_count as f64;

        if words_count > 0.0 && sentences_count > 0.0 {
            0.4 * ((words_count / sentences_count) + 100.0 * (long_words_count / words_count))
        } else {
            0.0
        }
    }

    fn calculate_smog_index(metrics: &TextMetrics) -> f64 {
        let polysyllable_count = metrics.polysyllable_count as f64;
        let sentences_count = metrics.sentences_count as f64;

        if sentences_count > 0.0 {
            1.043 * (30.0 * (polysyllable_count / sentences_count)).sqrt() + 3.1291
        } else {
            0.0
        }
    }
}
