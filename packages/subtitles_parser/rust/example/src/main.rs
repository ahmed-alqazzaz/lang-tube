use std::fs::read_to_string;
use std::io::Result;
use std::time::Instant;
use subtitles_parser::api::parse_subtitles;

fn load_xml_as_string(file_path: &str) -> Result<String> {
    let content = read_to_string(file_path)?;
    Ok(content)
}

fn main() -> Result<()> {
   let subtitles =  load_xml_as_string(
        "../../../../test/assets/raw_subtitles/Nicos_Weg_A2.xml",
    )?;
    let start_time = Instant::now();
    let subs = parse_subtitles(subtitles.to_string());
    for subtitle in subs {
        // print!(
        //     "Start: {}, End: {}, Text: {}\n",
        //     subtitle.start.secs, subtitle.end.secs, subtitle.text
        // );
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
