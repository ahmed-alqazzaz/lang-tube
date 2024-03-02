cd rust

@REM -C codegen-units=1 -C link-arg=-s increased performance by more than 2x
$env:RUSTFLAGS="-C codegen-units=1 -C link-arg=-s"
cargo build --release
cargo ndk -t arm64-v8a -t armeabi-v7a -t x86_64 -t x86  -o ../android/app/src/main/jniLibs build --release
$env:RUSTFLAGS = $null
