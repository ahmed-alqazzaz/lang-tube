use std::fs::read_to_string;
use std::io::Result;
use std::time::Instant;
use subtitles_parser::api::{self, SubtitlesParser};

fn load_xml_as_string(file_path: &str) -> Result<String> {
    let content = read_to_string(file_path)?;
    Ok(content)
}

fn main() -> Result<()> {
    
    let start_time = Instant::now();
    let json_subs = read_to_string("../../../../raw_subtitles/youtube_timed_text/Fireship - How I deploy serverless containers for free.txt")?;

    let subtitles = api::SubtitlesParser::parse_youtube_timed_text(json_subs);
    
    for subtitle in subtitles {
        println!("{} - {} : {}", subtitle.start.secs , subtitle.end.secs, subtitle.text);
    }
    
    let end_time = Instant::now();
    let elapsed_time = end_time.duration_since(start_time);

    // Print the elapsed time in seconds and milliseconds
    println!(
        "Function took {} seconds and {} milliseconds",
        elapsed_time.as_secs(),
        elapsed_time.subsec_millis()
    );
    Ok(())
}
