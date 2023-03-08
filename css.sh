#!/bin/bash
set -e

# This script downloads the appropriate Dart Sass binary, fetches SCSS assets,
# and compiles them into CSS.

# 1. Setup temporary directory
echo "Creating temporary build directory..."
rm -rf _build_styles && mkdir _build_styles
cd _build_styles

# 2. Detect OS and architecture to download the correct Dart Sass binary
SASS_VERSION="1.54.3"
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)
SASS_ARCH=""

if [ "$OS" = "darwin" ]; then
  OS="macos"
  if [ "$ARCH" = "x86_64" ]; then
    SASS_ARCH="x64"
  elif [ "$ARCH" = "arm64" ]; then
    SASS_ARCH="arm64"
  fi
elif [ "$OS" = "linux" ] && [ "$ARCH" = "x86_64" ]; then
  SASS_ARCH="x64"
fi

if [ -z "$SASS_ARCH" ]; then
  echo "Error: Unsupported OS '$OS' or architecture '$ARCH'."
  exit 1
fi

SASS_FILENAME="dart-sass-${SASS_VERSION}-${OS}-${SASS_ARCH}.tar.gz"
SASS_URL="https://github.com/sass/dart-sass/releases/download/${SASS_VERSION}/${SASS_FILENAME}"

echo "Downloading Dart Sass from $SASS_URL"
wget "$SASS_URL"
tar -xf "$SASS_FILENAME"
chmod +x dart-sass/sass

# 3. Download SCSS source files from the correct raw URLs
echo "Downloading SCSS source files..."
STYLES_SRC_ROOT="https://raw.githubusercontent.com/Neoteroi/mkdocs-plugins/v1.2.0/styles"
SCSS_FILES=(
  "all.scss"
  "timeline.scss"
  "colors.scss"
  "cards.scss"
  "gantt.scss"
  "spantable.scss"
  "groups.scss"
  "contribs.scss"
  "oad.scss"
)

for f in "${SCSS_FILES[@]}"; do
  wget "${STYLES_SRC_ROOT}/${f}"
done

# 4. Compile SCSS to CSS in the target directory
DEST_DIR="../docs/stylesheets"
echo "Compiling CSS to $DEST_DIR..."
./dart-sass/sass --no-source-map all.scss "${DEST_DIR}/neoteroi-mkdocs.css"
./dart-sass/sass --no-source-map timeline.scss "${DEST_DIR}/neoteroi-timeline.css"

# 5. Cleanup
echo "Cleaning up temporary directory..."
cd ..
rm -rf _build_styles

echo "CSS build complete."
