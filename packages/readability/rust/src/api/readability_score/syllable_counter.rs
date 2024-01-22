pub struct SyllableCounter {
    debug: bool,
    vowels: &'static str,
    specials: Vec<&'static str>,
    specials_except_end: Vec<&'static str>,
}

impl SyllableCounter {
    pub fn new() -> Self {
        Self {
            debug: false,
            vowels: "aeiouy",
            specials: vec!["ia", "ea"],
            specials_except_end: vec!["ie", "ya", "es", "ed"],
        }
    }

    pub fn count(&self, word: &str) -> u32 {
        let mut count = 0;
        let mut last_letter: char = ' ';
        let mut last_was_vowel = false;
        let normalised = word.to_lowercase();

        for letter in normalised.chars() {
            if self.vowels.chars().any(|c| c == letter) {
                let mut combo = String::new();
                combo.push(last_letter);
                combo.push(letter);

                let is_not_in_special = !&self.specials.iter().any(|x| x == &combo);
                let is_not_in_specials_except_end =
                    !&self.specials_except_end.iter().any(|x| x == &combo);
                if last_was_vowel && is_not_in_special && is_not_in_specials_except_end {
                    last_was_vowel = true;
                } else {
                    count += 1;
                    if self.debug {
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
            let second_last_char_index =
                word.char_indices().nth(word.chars().count() - 2).unwrap().0;

            let testcase_1 = &word[second_last_char_index..];
            let testcase_2 =
                &word[second_last_char_index + testcase_1.chars().next().unwrap().len_utf8()..];

            if self.debug {
                println!("test1 {} test2 {}", testcase_1, testcase_2);
            }
            if self.specials_except_end.iter().any(|x| x == &testcase_1) {
                if self.debug {
                    println!("!!{} match test1 in specials_except_end", word);
                }
                count -= 1;
            } else if testcase_1 != "ee" && testcase_2 == "e" && normalised != "the" {
                if self.debug {
                    println!("!!{} test1 and test2", word);
                }
                count -= 1;
            }
        }
        count
    }
}
