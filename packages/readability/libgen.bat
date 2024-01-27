cd rust
cargo build --release
cargo ndk -t arm64-v8a -t x86_64 -t x86  -o ../android/app/src/main/jniLibs2 build --release