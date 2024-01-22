pub use unicode_segmentation::UnicodeSegmentation;
pub use rayon::prelude::*;

pub use crate::api::simple::lazy_static::{SPLITTER, SYLLABLE_COUNTER, ALPHABETIC_REGEX};

pub struct TextMetrics {
    pub words_count: u64,
    pub sentences_count: u64,
    pub long_words_count: u64,
    pub long_words_percentage: f64,
    pub chars_count: u64,
    pub avg_syl_count: f64,
    pub sentence_avg_wordcount: f64,
    pub polysyllable_count: u64,
}

impl TextMetrics {
    pub fn new(text: &str) -> Self {
        let (words, (sentences, chars_count)) = rayon::join(
            || Self::word_tokenizer(text),
            || rayon::join(|| Self::sentence_tokenizer(text), || Self::count_chars(text))
        );
        let (long_words_count, (avg_syl_count, polysyllable_count)) = rayon::join(
            || Self::count_long_words(&words),
            || rayon::join(|| Self::avg_syl_count(&words), || Self::count_polysyllables(&words))
        );
        
        let words_count = words.len() as u64;
        let sentences_count = sentences.len() as u64;
        let long_words_percentage = if words_count > 0 {
            (long_words_count as f64 / words_count as f64) * 100.0
        } else {
            0.0
        };
        let sentence_avg_wordcount = if sentences_count > 0 {
            words_count as f64 / sentences_count as f64
        } else {
            0.0
        };
        
        Self {
            words_count,
            sentences_count,
            long_words_count,
            long_words_percentage,
            chars_count,
            avg_syl_count,
            sentence_avg_wordcount,
            polysyllable_count,
        }
    }

    fn word_tokenizer(text: &str) -> Vec<String> {
        let words = text.unicode_words();
        words.map(|w| w.to_string()).collect()
    }

    fn sentence_tokenizer(text: &str) -> Vec<String> {
        match SPLITTER.as_ref() {
            Ok(splitter) => {
                let splits = splitter.split(&[text]);
                splits[0]
                    .iter()
                    .map(|sentence| sentence.text().to_string())
                    .collect()
            }
            Err(e) => {
                println!("Error in sentence_tokenizer: {}", e);
                vec![text.to_string()]
            }
        }
    }

    fn count_long_words(word_list: &Vec<String>) -> u64 {
        word_list
            .par_iter()
            .filter(|word| word.chars().count() >= 6)
            .count() as u64
    }

    fn count_chars(text: &str) -> u64 {
        let stripped_text = ALPHABETIC_REGEX.replace_all(text, "");
        stripped_text.chars().count() as u64
    }

    fn avg_syl_count(word_list: &[String]) -> f64 {
        let sylcount_list: Vec<_> = word_list
            .par_iter()
            .map(|word| SYLLABLE_COUNTER.count(word).try_into().unwrap())
            .collect();

        let sum: i32 = sylcount_list.par_iter().sum();
        sum as f64 / sylcount_list.len() as f64
    }

    fn count_polysyllables(word_list: &[String]) -> u64 {
        word_list
            .par_iter()
            .filter(|word| SYLLABLE_COUNTER.count(word) >= 3)
            .count() as u64
    }
}