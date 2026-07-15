# MKS Robin WiFi (Custom Edition v1.0.4-CS)

This is a custom, optimized version of the **MKS Robin WiFi** firmware (built for the ESP8266 / ESP-12S modules). It introduces critical network features, performance optimizations, and translation fixes to work seamlessly with modern web browsers and local dashboard applications.

---

## ⚡ Key Improvements (v1.0.4-CS)

Compared to the factory Makerbase firmware, this edition includes:

### 1. mDNS Local Domain Resolution
* **What it does**: Starts an mDNS responder on the ESP8266.
* **Benefit**: Access your printer's web interface at **`http://mkswifi.local`** or **`http://mkswifi`** instead of hunting for its dynamic IP address on your router.

### 2. Bidirectional WebSockets (Port 81)
* **What it does**: Spawns a dedicated WebSocket server on port `81`.
* **Benefit**: Allows modern web dashboards (like our Web GUI) to establish direct, low-overhead connections right from the browser to read serial logs and send G-code wirelessly.

### 3. TCP Socket Buffer Tuning (`HSPI` & `RepRapWebServer`)
* **What it does**: Optimizes the serial-to-TCP bridge on port `8080` (used by Cura plugins and command line Netcat) and tuning socket queues.
* **Benefit**: Dramatically reduces buffer drops, latency, and packet corruption during high-speed, intensive wireless G-code execution.

### 4. Full English Translation & Cleanup
* **What it does**: Replaces leftover Chinese characters in web portal pages, console responses, and connection logs with clean, standard English.
* **Benefit**: Easy to audit and understand serial outputs in the console.

---

## 🔌 Supported Connection Protocols

1. **WebSocket (Port 81) [NEW]**: Standard WebSocket stream for browser-based client dashboard applications.
2. **TCP Socket (Port 8080)**: Raw socket bridge. Connect wirelessly via command-line:
   ```bash
   nc mkswifi 8080
   ```
   *(Ensure only one client is connected to port 8080 at a time to prevent data corruption).*

---

## 🛠️ How to Compile

### Method A: Automatic Script (Recommended)
You can compile automatically using the provided `compile.sh` bash script (requires `arduino-cli`):
```bash
chmod +x compile.sh
./compile.sh
```
*Note: The script outputs the compiled binary directly to **`firmware_release/MksWifi.bin`** and cleans up temporary build files.*
### Method B: Manual Arduino IDE
1. Install **Arduino IDE** (v1.8.x recommended).
2. Download and install the custom **MKS ESP8266 Core** (using the standard core might cause build issues):
   [Esp8266 Core on MKS Github](https://github.com/makerbase-mks/Esp8266-Core-For-Arduino)
   Extract it to your Arduino hardware package directory:
   `C:\Users\<username>\AppData\Local\Arduino15\packages\esp8266\hardware\esp8266` (Windows) or `~/Library/Arduino15/packages/esp8266/hardware/esp8266` (macOS).
3. Open `firmware_source/MksWifi/MksWifi.ino` in Arduino IDE.
4. Set compiler configurations in **Tools**:
   * **Board**: "Generic ESP8266 Module"
   * **Flash Mode**: "DOUT"
   * **Flash Size**: "4M (3M SPIFFS)"
5. Click **Sketch > Export compiled Binary**.

---

## 💾 How to Flash

### Method A: Web Interface Upgrade (Wireless OTA - Recommended)
1. Ensure your printer is powered on and connected to your local network.
2. Open your web browser and navigate to **`http://mkswifi`** (or the printer's local IP address).
3. Navigate to the **Update** page from the web portal menu.
4. Upload the compiled **`MksWifi.bin`** file. The module will flash wirelessly and automatically restart.

### Method B: SD Card Upgrade (Mainboard Bootstrap)
1. Copy the compiled `.bin` file to your printer's SD card.
2. Rename the file to **`MksWifi.bin`** (case-sensitive).
3. Insert the SD card into your printer's mainboard (e.g. MKS Robin Nano) and power cycle the printer.
4. The mainboard will automatically flash the firmware onto the WiFi module on startup.
