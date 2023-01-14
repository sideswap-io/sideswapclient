1. Use WSL2
2. Build gdk as in README - use docker solution
3. sudo apt install g++-mingw-w64-x86-64-posix gcc-mingw-w64-x86-64-posix gcc-mingw-w64-x86-64-posix-runtime
4. export GDK_DIR=gdk/build-windows-mingw-w64/src
RUSTFLAGS="-Clink-arg=-Wl,--allow-multiple-definition" cargo build --release --target x86_64-pc-windows-gnu
6. copy required dll files:
/usr/lib/gcc/x86_64-w64-mingw32/8.3-posix/libgcc_s_seh-1.dll
/usr/lib/gcc/x86_64-w64-mingw32/8.3-posix/libstdc++-6.dll
/usr/lib/gcc/x86_64-w64-mingw32/8.3-posix/libssp-0.dll
/usr/x86_64-w64-mingw32/lib/libwinpthread-1.dll
