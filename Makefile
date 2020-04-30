install:
	cp -f libsrng.so /usr/local/lib/libsrng.so
	ln -sf /usr/local/lib/libsrng.so /usr/lib/libsrng.so

uninstall:
	rm -f /usr/local/lib/libsrng.so
	rm /usr/lib/libsrng.so

build:
	cd libsrng && cargo build --release
	cp libsrng/target/release/libsrng.so ./
	gpg --sign libsrng.so
