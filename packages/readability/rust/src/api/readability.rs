use regex::Regex;
use unicode_segmentation::UnicodeSegmentation;

// For the time being, chunking the subtitle into sentences
// is not possible, due to the lack of periods,semicolons, etc in subtitles.
static SENT_COUNT : f64 = 1.0;
static AVG_SENT_LENGTH : f64 = 1.0;
static SENT_AVG_WORDCOUNT : f64 = 1.0;

pub fn lix_index(string_to_analyze: &str) -> f64 {
    //total_words
    let all_words = word_tokenizer(string_to_analyze);
    //num long words
    let num_long_words = percent_long_words(all_words);
    let lix_index = num_long_words + SENT_AVG_WORDCOUNT;
    lix_index
}

pub fn rix_index(string_to_analyze: &str) -> f64 {
    //total_words
    let all_words = word_tokenizer(string_to_analyze);
    //num long words
    let num_long_words = long_words(all_words);
    // let sentences
    let rix_index = num_long_words / SENT_COUNT;
    rix_index
}

pub fn flesch_reading_ease(string_to_analyze: &str) -> f64 {
    //syls
    let all_words = word_tokenizer(string_to_analyze);
    let all_syls = syllable_count_list(all_words);
    let avg_syls = avg_syl_count(all_syls);
    let flesch_index = 206.835 - (1.015 * AVG_SENT_LENGTH) - (84.6 * avg_syls);
    flesch_index
}

pub fn coleman_liau_index(string_to_analyze: &str) -> f64 {
    //total_words
    let all_words = word_tokenizer(string_to_analyze).len() as f64;
    // characters
    let chars = character_count(string_to_analyze);
    
    let coleman_liau_index =
        0.0588 * ((chars / all_words) * 100.0) - 0.296 * ((SENT_COUNT / chars) * 100.0) - 15.8;
    coleman_liau_index
}

pub fn automated_readability_index(string_to_analyze: &str) -> f64 {
    //total_words
    let all_words = word_tokenizer(string_to_analyze).len() as f64;
    // characters
    let chars = character_count(string_to_analyze);
    
    let automated_readability_index =
        (4.71 * (chars / all_words)) + (0.5 * (all_words / SENT_COUNT)) - 21.43;
    automated_readability_index
}

pub fn word_tokenizer(string_to_analyze: &str) -> Vec<String> {
    let mut word_list: Vec<String> = Vec::new();
    let words = string_to_analyze.unicode_words();
    for w in words {
        word_list.push(w.to_string());
    }
    word_list
}

pub fn long_words(word_list: Vec<String>) -> f64 {
    let mut sum = 0;
    for word in word_list {
        if word.len() >= 6 {
            sum += 1;
        }
    }
    let long_words_count: f64;
    long_words_count = sum as f64;
    long_words_count
}

pub fn percent_long_words(word_list: Vec<String>) -> f64 {
    let list_count = word_list.len() as i32;
    let long_words_count = long_words(word_list);
    let percent_longwords = long_words_count as f64 / list_count as f64;
    percent_longwords
}

pub fn character_count(string_to_analyze: &str) -> f64 {
    let re = Regex::new(r"[^\w]").unwrap();
    let result = re.replace_all(string_to_analyze, "");

    let character_count: f64;
    character_count = result.graphemes(true).count() as f64;

    character_count
}

pub fn syllable_count_list(word_list: Vec<String>) -> Vec<i32> {
    let mut sylcount_list: Vec<i32> = Vec::new();
    for word in &word_list {
        sylcount_list.push(syllable_counter(&word).try_into().unwrap());
    }
    sylcount_list
}

pub fn avg_syl_count(sylcount_list: Vec<i32>) -> f64 {
    let mut sum = 0;
    for w in &sylcount_list {
        sum += w;
    }
    let avg_syls: f64;
    avg_syls = sum as f64 / sylcount_list.len() as f64;
    avg_syls
}

/// Returns the syllable count for a word
pub fn syllable_counter(word: &str) -> u32 {
    const DEBUG: bool = false; // must be a better way to do this

    let vowels = "aeiouy";
    let specials = vec!["ia", "ea"]; // single syllables in words like bread and lead, but split in names like Breanne and Adreann TODO: handle names, where we only use "ia"
    let specials_except_end = vec!["ie", "ya", "es", "ed"]; // seperate syllables unless ending the word

    let mut count = 0;
    let mut last_letter: char = ' ';
    let mut last_was_vowel = false;
    let normalised = word.to_lowercase();

    for letter in normalised.chars() {
        if vowels.chars().any(|c| c == letter) {

            // don't count diphthongs unless special cases
            let mut combo = String::new();
            combo.push(last_letter);
            combo.push(letter);

            let is_not_in_special = !&specials.iter().any(|x| x == &combo);
            let is_not_in_specials_except_end = !&specials_except_end.iter().any(|x| x == &combo);
            if last_was_vowel && is_not_in_special && is_not_in_specials_except_end {
                last_was_vowel = true;
            } else {
                count += 1;
                if DEBUG {
                    println!("count: {} => {}", count, letter);
                }
                last_was_vowel = true;
            }
        } else {
            last_was_vowel = false;
        }
        last_letter = letter;
    }

    if word.len() > 2 {
        let second_last_char_index = word.char_indices().nth(word.chars().count() - 2).unwrap().0;

        let testcase_1 = &word[second_last_char_index..];
        let testcase_2 = &word[second_last_char_index + testcase_1.chars().next().unwrap().len_utf8()..];


        if DEBUG {
            println!("test1 {} test2 {}", testcase_1, testcase_2);
        }
        if specials_except_end.iter().any(|x| x == &testcase_1) {
            if DEBUG {
                println!("!!{} match test1 in specials_except_end", word);
            }
            count -= 1;
        } else if testcase_1 != "ee" && testcase_2 == "e" && normalised != "the" {
            if DEBUG {
                println!("!!{} test1 and test2", word);
            }
            count -= 1;
        }
    }
    count
}
