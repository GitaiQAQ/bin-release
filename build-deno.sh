#!/bin/bash

download() {
    denoVersion=$1
    filename=$2
    os=$3
    arch=$4

    echo $1 $2 $3 $4

    rm -rf workbench && mkdir -p workbench/bin && cd workbench

    echo https://github.com/denoland/deno/releases/download/v${denoVersion/-*}/${filename}.zip
    curl -fsSL https://github.com/denoland/deno/releases/download/v${denoVersion/-*}/${filename}.zip \
        --output deno.zip \
      && unzip deno.zip \
      && rm deno.zip \
      && mv deno* bin

    cat > package.json <<EOF 
{
    "name": "@bin-release/$filename",
    "version": "$denoVersion",
    "author": "Gitai<i@gitai.me>",
    "license": "MIT",
    "os": [
        "$os"
    ],
    "cpu": [
        "$arch"
    ]
}
EOF

}

if (( $# > 1 ));
then
    download $1 $2 $3 $4
    exit
fi;

DENO_VERSION=$1
# DENO_VERSION=1.9.0-alpha.1

cat << EOF | jq -r 'to_entries | .[] | [.key + " " + .value.os + " " + .value.cpu] | .[]' | xargs -n 3 -P 1 -p ./build-deno.sh $DENO_VERSION
{
    "deno-aarch64-apple-darwin": {
        "os": "darwin",
        "cpu": "arm64"
    },
    "deno-x86_64-apple-darwin": {
        "os": "darwin",
        "cpu": "x64"
    },
    "deno-x86_64-pc-windows-msvc": {
        "os": "win32",
        "cpu": "x64"
    },
    "deno-x86_64-unknown-linux-gnu": {
        "os": "linux",
        "cpu": "x64"
    }
}
EOF

read -p "build manifest (y/n)? " answer
case ${answer:0:1} in
    y|Y )
        :;
    ;;
    * )
        exit;
    ;;
esac

rm -rf workbench && mkdir -p workbench/bin && cd workbench

cat > bin/deno <<EOF
#!/bin/sh

set -e

echo "Error: Staging postinstall will overwrite this script." 1>&2
exit 1
EOF

cat > package.json <<EOF 
{
  "name": "@bin-release/deno",
  "version": "$DENO_VERSION",
  "description": "CLI wrapper for Deno, a secure runtime for JavaScript and TypeScript",  
  "files": [
    "package.json"
  ],
  "keywords": [
    "deno"
  ],
  "bin": {
    "deno": "./bin/deno"
  },
  "scripts": {
    "postinstall": "mv node_modules/@bin-release/deno-*/bin/deno ./bin || mv ../deno-*/bin/deno ./bin || echo 'no available product'"
  },
  "author": "Gitai<i@gitai.me>",
  "license": "MIT",
  "dependencies": {
  },
  "optionalDependencies": {
    "@bin-release/deno-aarch64-apple-darwin": "$DENO_VERSION",
    "@bin-release/deno-x86_64-apple-darwin": "$DENO_VERSION",
    "@bin-release/deno-x86_64-pc-windows-msvc": "$DENO_VERSION",
    "@bin-release/deno-x86_64-unknown-linux-gnu": "$DENO_VERSION"
  }
}
EOF