#[cfg(target_os = "android")]
extern crate android_logger;
#[cfg(target_os = "android")]
use android_logger::{Config, FilterBuilder};
#[cfg(target_os = "android")]
use log::LevelFilter;

#[cfg(target_os = "ios")]
extern crate oslog;
#[cfg(target_os = "ios")]
use oslog::os_log;

pub fn log(text: &str) {
   #[cfg(target_os = "android")]
   {
        android_logger::init_once(
            Config::default()
                .with_max_level(LevelFilter::Warn) // Set max log level to Warn
                .with_tag("MyApp") // Set tag
                .with_filter(FilterBuilder::new().parse("debug,MyApp:trace").build()), // Use filter
        );
        log::warn!(text);
    }

    #[cfg(target_os = "ios")]
    {
        let logger = os_log!("com.mycompany.myapp");
        os_log_info!(logger, text);
    }
}
