pub use readability_implementation::ReadabilityScore;
pub use readability_implementation::syllable_counter::SyllableCounter;

pub fn calculate_text_complexity(text: String, language: String, cache_dir: Option<String>) -> Result<String, String> {
    let scores = ReadabilityScore::new(&text, &language, cache_dir.as_deref())?.to_map();
    let json = serde_json::to_string(&scores).map_err(|e| e.to_string())?;
    Ok(json)
}

pub fn count_syllables(text: String) -> u32 {
    SyllableCounter::get_instance().as_ref().count(&text)
}
