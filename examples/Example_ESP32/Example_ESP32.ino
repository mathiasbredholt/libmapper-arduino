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
  WiFi.begin(ssid, password);

  // Disable WiFi power save (huge latency improvements)
  esp_wifi_set_ps(WIFI_PS_NONE);

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
  }

  float signalMin = 0.0f;
  float signalMax = 5.0f;

  dev = mpr_dev_new("ESP32", 0);
  outputSignal = mpr_sig_new(dev, MPR_DIR_OUT, "valueToSend", 1, MPR_FLT, "V",
                             &signalMin, &signalMax, 0, 0, 0);
  inputSignal = mpr_sig_new(dev, MPR_DIR_OUT, "valueReceived", 1, MPR_FLT, "V",
                            &signalMin, &signalMax, 0, inputSignalHandler,
                            MPR_SIG_UPDATE);
}

void loop() {
  // Update libmapper device
  mpr_dev_poll(dev, 0);

  // Increment number and send
  seqNumber += 0.01f;
  mpr_sig_set_value(outputSignal, 0, 1, MPR_FLT, &seqNumber);

  // Print received value
  Serial.print("received: ");
  Serial.println(receivedValue);

  // Wait 100 ms
  delay(100);
}

void inputSignalHandler(mpr_sig sig, mpr_sig_evt evt, mpr_id inst, int length,
                        mpr_type type, const void* value, mpr_time time) {
  receivedValue = *((float*)value);
}
