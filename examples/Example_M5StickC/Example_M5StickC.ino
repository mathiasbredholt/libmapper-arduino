#include <M5StickC.h>
#include <WiFi.h>
#include <mapper.h>

// For disabling power saving
#include "esp_wifi.h"

const char* ssid = "WIFI_SSID";
const char* password = "WIFI_PASSWORD";

mpr_dev dev = 0;
mpr_sig inputSignal = 0;
mpr_sig outputSignal = 0;
float seqNumber = 0;
float receivedValue = 0;

void setup() {
  // Initialize the M5StickC object
  M5.begin();

  WiFi.begin(ssid, password);

  // Disable WiFi power save (huge latency improvements)
  esp_wifi_set_ps(WIFI_PS_NONE);

  while (WiFi.status() != WL_CONNECTED) {
    M5.Lcd.fillScreen(ORANGE);
    delay(250);
    M5.Lcd.fillScreen(RED);
    delay(250);
    M5.Lcd.println("Connecting");
  }

  M5.Lcd.fillScreen(GREEN);

  float signalMin = 0.0f;
  float signalMax = 5.0f;

  dev = mpr_dev_new("ESP32", 0);
  outputSignal = mpr_sig_new(dev, MPR_DIR_OUT, "valueToSend", 1, MPR_FLT, "V",
                             &signalMin, &signalMax, 0, 0, 0);
  inputSignal = mpr_sig_new(dev, MPR_DIR_OUT, "valueReceived", 1, MPR_FLT, "V",
                            &signalMin, &signalMax, 0, inputSignalHandler,
                            MPR_SIG_UPDATE);

  // LCD display
  // M5.Lcd.print("Hello World");

  pinMode(M5_LED, OUTPUT);
  digitalWrite(M5_LED, HIGH);
}

void loop() {
  // Update libmapper device
  mpr_dev_poll(dev, 0);

  // Increment number and send
  seqNumber += 0.01f;
  mpr_sig_set_value(outputSignal, 0, 1, MPR_FLT, &seqNumber);

  // Print receivedValue to LCD screen
  M5.Lcd.fillScreen(BLUE);
  M5.Lcd.setCursor(0, 10);
  M5.Lcd.print(receivedValue);

  // Wait 100 ms
  delay(100);
}

void inputSignalHandler(mpr_sig sig, mpr_sig_evt evt, mpr_id inst, int length,
                        mpr_type type, const void* value, mpr_time time) {
  receivedValue = *((float*)value);
}
