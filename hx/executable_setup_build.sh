#!/bin/bash

# Configuration
SOURCE_DIR="source"
BUILDS_BASE="builds"
SYMLINK_NAME="current"

# Constructing paths based on SOURCE_DIR
RUNTIME_DIR="$SOURCE_DIR/runtime"
BINARY_PATH="$SOURCE_DIR/target/release/hx"

# 1. Determine the next build number
if [ ! -d "$BUILDS_BASE" ]; then
    mkdir -p "$BUILDS_BASE"
    NEXT_BUILD=1
else
    # Find the highest numeric folder name
    LAST_BUILD=$(ls "$BUILDS_BASE" | grep -E '^[0-9]+$' | sort -n | tail -1)
    # Default to 0 if no numeric folders exist yet
    LAST_BUILD=${LAST_BUILD:-0}
    NEXT_BUILD=$((LAST_BUILD + 1))
fi

BUILD_FOLDER="$BUILDS_BASE/$NEXT_BUILD"

echo "--- Starting build setup for: $BUILD_FOLDER ---"

# 2. Create directory structure
mkdir -p "$BUILD_FOLDER/bin"

# 3. Copy binary
if [ -f "$BINARY_PATH" ]; then
    echo "Copying binary from $BINARY_PATH..."
    cp "$BINARY_PATH" "$BUILD_FOLDER/bin/"
else
    echo "Error: Binary not found at $BINARY_PATH."
    echo "Make sure you ran 'cargo build --release' inside the $SOURCE_DIR directory."
    exit 1
fi

# 4. Copy runtime folder
if [ -d "$RUNTIME_DIR" ]; then
    echo "Copying runtime from $RUNTIME_DIR..."
    cp -r "$RUNTIME_DIR" "$BUILD_FOLDER/"
else
    echo "Warning: Runtime directory not found at $RUNTIME_DIR."
fi

# 5. Reset symlink (current -> <buildfolder>)
echo "Updating symlink..."
# Using absolute path for the symlink target to avoid 'cd' side effects
ln -sfn "$NEXT_BUILD" "$BUILDS_BASE/$SYMLINK_NAME"

echo "--- Setup Complete ---"
echo "Active build: $NEXT_BUILD (linked at $BUILDS_BASE/$SYMLINK_NAME)"
