#!/bin/bash

PROTO_ROOT="./src/proto"
OUT_DIR="./src/interfaces/proto"
GOOGLE_PROTO_PATH="C:/Users/alber/AppData/Local/Microsoft/WinGet/Packages/Google.Protobuf_Microsoft.Winget.Source_8wekyb3d8bbwe/include"

# Create output directory
mkdir -p "$OUT_DIR"

PLUGIN_PATH=$(cd node_modules/.bin && pwd -W)/protoc-gen-ts_proto.cmd

# Auto-scan and generate for all subdirectories in proto root
for dir in "$PROTO_ROOT"/*/; do
  if [ -d "$dir" ]; then
    subdir=$(basename "$dir")
    PROTO_OUT="$OUT_DIR/$subdir"
    mkdir -p "$PROTO_OUT"

    if ls "$dir"*.proto 2>/dev/null | grep -q .; then
      protoc \
        --plugin="protoc-gen-ts_proto=$PLUGIN_PATH" \
        --ts_proto_out="$OUT_DIR" \
        --ts_proto_opt=nestJs=true \
        --ts_proto_opt=addGrpcMetadata=true \
        --ts_proto_opt=snakeToCamel=false \
        --ts_proto_opt=useDate=true \
        --ts_proto_opt=stringEnums=true \
        --ts_proto_opt=unrecognizedEnum=false \
        --ts_proto_opt=outputEncodeMethods=false \
        --ts_proto_opt=addNestjsRestParameter=true \
        --proto_path="$GOOGLE_PROTO_PATH"\
        --proto_path="$PROTO_ROOT" \
        "$dir"*.proto
    fi
  fi
done