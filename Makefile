# Makefile CLT vs PJ

install:
	flutter pub get

clean:
	flutter clean && flutter pub cache clean

build-extension-dev:
	flutter build web --no-web-resources-cdn --csp --pwa-strategy=none --no-wasm-dry-run