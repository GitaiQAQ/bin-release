# Bin release

## Deno

### How to build?
```shell
$ ./build-deno.sh 1.9.0
./build-deno.sh 1.9.0 deno-aarch64-apple-darwin darwin arm64?...y   # cd workbench && npm publish --public
./build-deno.sh 1.9.0 deno-x86_64-apple-darwin darwin x64?...y      # cd workbench && npm publish --public
./build-deno.sh 1.9.0 deno-x86_64-pc-windows-msvc win32 x64?...y    # cd workbench && npm publish --public
./build-deno.sh 1.9.0 deno-x86_64-unknown-linux-gnu linux x64?...y  # cd workbench && npm publish --public
build manifest (y/n)? y                                             # cd workbench && npm publish --public
```