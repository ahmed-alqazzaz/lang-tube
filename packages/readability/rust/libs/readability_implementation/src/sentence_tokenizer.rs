use nnsplit::{NNSplit, NNSplitOptions};
use once_cell::sync::Lazy;
use std::collections::HashMap;
use std::sync::{Arc, Mutex};
use rayon::prelude::*;


static INSTANCES: Lazy<Mutex<HashMap<String, Arc<SentenceTokenizer>>>> =
    Lazy::new(|| Mutex::new(HashMap::new()));
pub struct SentenceTokenizer {
    nn_split: NNSplit,
}

pub trait Multiton {
    fn get_instance(
        language: &str,
        cache_dir: Option<&str>,
    ) -> Result<Arc<SentenceTokenizer>, String>;
    fn is_instance_present(language: &str) -> bool;
    fn new(language: &str, cache_dir: Option<&str>) -> Result<Self, String>
    where
        Self: Sized;
}

impl Multiton for SentenceTokenizer {
    fn get_instance(
        language: &str,
        cache_dir: Option<&str>,
    ) -> Result<Arc<SentenceTokenizer>, String> {
        let mut instances = INSTANCES.lock().unwrap();
        if instances.contains_key(language) {
            Ok(Arc::clone(instances.get(language).unwrap()))
        } else {
            let sentence_tokenizer = Arc::new(SentenceTokenizer::new(language, cache_dir)?);
            instances.insert(language.to_string(), Arc::clone(&sentence_tokenizer));
            Ok(sentence_tokenizer)
        }
    }
    fn is_instance_present(language: &str) -> bool {
        let instances = INSTANCES.lock().unwrap();
        instances.contains_key(language)
    }
    fn new(language: &str, cache_dir: Option<&str>) -> Result<Self, String> {
        let nn_split = NNSplit::load(
            &language,
            NNSplitOptions::default().copy_with(None, None, None, None, None, None, cache_dir),
        )
        .map_err(|e| e.to_string())?;
        Ok(Self { nn_split })
    }
}

impl SentenceTokenizer {
    pub fn evaluate(&self, text: &str) -> Vec<String> {
        // split text using punctuation initially
        let mut major_segments: Vec<String> = text.split(".").map(|s| s.to_string()).collect();
        // ensure each segment is at least 8000 chars
        // splitter works best with texts between 7000 and 10000 chars
        major_segments.ensure_min_length(8000, Some('.'));
        
        println!("{}", major_segments.len());
        // split using punctuation agnsotic splitter concurrently
        let sentences: Vec<String> = major_segments
            .par_iter()
            .flat_map(|sentence| {
                let tokens: Vec<String> =self.nn_split.split(&[sentence])[0] 
                    .iter()
                    .map(|sentence| sentence.text().to_string())
                    .collect();
                tokens
            })
            .collect();
        sentences
    }
    // pub fn evaluate(&self, text: &str) -> Vec<String> {
    //     println!("{}" ,text.len());
    //     let tokens = self.nn_split.split(&[text]);
    //     tokens[0]
    //         .iter()
    //         .map(|sentence| sentence.text().to_string())
    //         .collect()
    // }
}

trait MergeShortStrings {
    fn ensure_min_length(&mut self, min_len: usize, insert_char: Option<char>);
}

impl MergeShortStrings for Vec<String> {
    fn ensure_min_length(&mut self, min_len: usize, concat_char: Option<char>) {
        let mut i = 0;
        while i < self.len() {
            while i < self.len() - 1 && self[i].len() < min_len {
                let next = self.remove(i + 1);
                match concat_char {
                    Some(ch) => self[i] = format!("{}{}{}", self[i], ch, next),
                    None => self[i].push_str(&next),
                }
            }
            if i == self.len() - 1 && self[i].len() < min_len && i > 0 {
                let last = self.remove(i);
                match concat_char {
                    Some(ch) => self[i - 1] = format!("{}{}{}", self[i - 1], ch, last),
                    None => self[i - 1].push_str(&last),
                }
            } else {
                i += 1;
            }
        }
    }
}