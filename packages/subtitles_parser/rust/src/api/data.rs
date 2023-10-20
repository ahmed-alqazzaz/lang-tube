
#[derive(Debug)]
pub struct ParsedSubtitle {
    pub start: RustDuration,
    pub end: RustDuration,
    pub text: String,
}

#[derive(Copy, Clone)]
#[derive(Debug)]
pub struct RustDuration {
    pub secs: u64,
    pub millis: u64, // Always 0 <= millis < MILLIS_PER_SEC
}

pub const MILLIS_PER_SEC: u64 = 1_000; 

impl std::ops::Add for RustDuration {
    type Output = Self;

    fn add(self, other: Self) -> Self {
        let mut secs = self.secs + other.secs;
        let mut millis = self.millis + other.millis;
        if millis >= MILLIS_PER_SEC {
            secs += 1;
            millis -= MILLIS_PER_SEC;
        }
        Self { secs, millis }
    }
}

impl std::ops::Sub for RustDuration {
    type Output = Self;

    fn sub(self, other: Self) -> Self {
        let mut secs = self.secs - other.secs;
        let millis = if self.millis >= other.millis {
            self.millis - other.millis
        } else {
            secs -= 1;
            self.millis + MILLIS_PER_SEC - other.millis
        };
        Self { secs, millis }
    }
}