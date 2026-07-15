#!/bin/bash
set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}=== MKS WiFi Compiler Script ===${NC}"

# 1. Check/Install arduino-cli
if ! command -v arduino-cli &> /dev/null; then
    echo -e "${YELLOW}arduino-cli not found. Installing via Homebrew...${NC}"
    brew install arduino-cli
else
    echo -e "${GREEN}✓ arduino-cli found: $(arduino-cli version | awk '{print $1" "$2" "$3}')${NC}"
fi

ESP_URL="http://arduino.esp8266.com/stable/package_esp8266com_index.json"

# 2. Update core index
echo -e "${BLUE}Updating board manager index...${NC}"
arduino-cli core update-index --additional-urls "$ESP_URL"

# 3. Check/Install esp8266 core
if ! arduino-cli core list | grep -q "esp8266:esp8266"; then
    echo -e "${YELLOW}Installing ESP8266 core...${NC}"
    arduino-cli core install esp8266:esp8266 --additional-urls "$ESP_URL"
else
    echo -e "${GREEN}✓ ESP8266 core found.${NC}"
fi

# 4. Check/Install WebSockets library
if ! arduino-cli lib list | grep -q "WebSockets"; then
    echo -e "${YELLOW}Installing WebSockets library...${NC}"
    arduino-cli lib install WebSockets
else
    echo -e "${GREEN}✓ WebSockets library found.${NC}"
fi

# 5. Compile Sketch
SKETCH_DIR="firmware_source/MksWifi"
OUTPUT_DIR="build_wifi"

echo -e "${BLUE}Compiling sketch...${NC}"
mkdir -p "$OUTPUT_DIR"

arduino-cli compile \
    --fqbn esp8266:esp8266:generic \
    --additional-urls "$ESP_URL" \
    --output-dir "$OUTPUT_DIR" \
    "$SKETCH_DIR"

mv "$OUTPUT_DIR/MksWifi.ino.bin" "firmware_release/MksWifi.bin"
rm -rf "$OUTPUT_DIR"

echo -e "${GREEN}=== Build Successful! ===${NC}"
echo -e "${GREEN}Compiled binary path: $(pwd)/firmware_release/MksWifi.bin${NC}"
echo -e "${YELLOW}You can now flash this bin file via the WebUI (http://mkswifi.local) Update page.${NC}"
