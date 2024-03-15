cd rust

$env:RUSTFLAGS="-C codegen-units=1 -C link-arg=-s"
cargo build --release
cargo ndk -t arm64-v8a -t x86_64 -t x86  -o ../android/app/src/main/jniLibs build --release
$env:RUSTFLAGS=""