use std::collections::HashMap;

#[derive(Debug)]
struct BadMatchTable {
    mapping: HashMap<u8, usize>,
    size: usize,
}

struct Pattern {
    match_table: BadMatchTable,
    pattern_chars: Vec<u8>,
    size: usize,
}

impl BadMatchTable {
    fn new(pattern: &str) -> Self {
        let pattern_length = pattern.len();
        let mut skip_mappings = HashMap::new();

        for (i, c) in pattern.bytes().enumerate() {
            let skip = pattern_length - i - 1;
            if i == pattern_length - 1 && !skip_mappings.contains_key(&c) {
                skip_mappings.insert(c, pattern_length);
            } else if skip <= 0 {
                skip_mappings.insert(c, pattern_length);
            } else {
                skip_mappings.insert(c, skip);
            }
        }

        BadMatchTable {
            mapping: skip_mappings,
            size: pattern_length,
        }
    }

    fn get(&self, c: u8) -> usize {
        match self.mapping.get(&c) {
            Some(value) => value.to_owned(),
            None => self.size,
        }
    }
}

impl<'a> Pattern {
    fn compile(pattern: &'a str) -> Self {
        Pattern {
            match_table: BadMatchTable::new(pattern),
            size: pattern.len(),
            pattern_chars: pattern.bytes().collect::<Vec<_>>(),
        }
    }

    fn at(&'a self, i: usize) -> u8 {
        *self.pattern_chars.get(i).unwrap()
    }

    fn skip_for(&'a self, c: u8) -> usize {
        self.match_table.get(c)
    }
}

#[rustler::nif]
fn contains(haystack: &str, needle: &str) -> bool {
    let pattern = Pattern::compile(needle);
    let starting_index = pattern.size - 1;
    let haystack_chars = haystack.bytes().collect::<Vec<_>>();
    contains_pattern(&haystack_chars, &pattern, starting_index)
}

fn contains_pattern(haystack: &Vec<u8>, pattern: &Pattern, starting_index: usize) -> bool {
    match detect_pattern(haystack, pattern, starting_index, pattern.size - 1) {
        Ok(_) => true,
        Err(skip) => {
            let new_start = skip + starting_index;
            if new_start >= haystack.len() {
                false
            } else {
                contains_pattern(haystack, pattern, skip + starting_index)
            }
        }
    }
}

fn detect_pattern<'a>(
    haystack: &Vec<u8>,
    pattern: &Pattern,
    corpus_index: usize,
    pattern_index: usize,
) -> Result<bool, usize> {
    let haystack_char = *haystack.get(corpus_index).unwrap();
    let pattern_char = pattern.at(pattern_index);

    if haystack_char == pattern_char {
        if pattern_index == 0 {
            Ok(true)
        } else {
            detect_pattern(haystack, pattern, corpus_index - 1, pattern_index - 1)
        }
    } else {
        let skip = pattern.skip_for(haystack_char);
        Err(skip)
    }
}

rustler::init!("Elixir.BoyerMoore.Implementations.Nif", [contains]);
