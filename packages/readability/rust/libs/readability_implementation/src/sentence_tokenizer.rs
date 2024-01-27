use nnsplit::{NNSplit, NNSplitOptions};
use once_cell::sync::Lazy;
use std::collections::HashMap;
use std::sync::{Arc, Mutex};

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
        let tokens = self.nn_split.split(&[text]);
        tokens[0]
            .iter()
            .map(|sentence| sentence.text().to_string())
            .collect()
    }
}
