// Arduino libmapper library example

#include <WiFi.h>
#include <mapper.h>

// For disabling power saving
#include "esp_wifi.h"

const char* ssid     = "WIFI_SSID";
const char* password = "WIFI_PASSWORD";

mpr_dev dev = 0;
mpr_sig outputSignal = 0;

void setup() {
  Serial.begin(115200);

  // Begin WiFi before creating mapper device
  WiFi.begin(ssid, password);

  // Disable WiFi power save (huge latency improvements)
  esp_wifi_set_ps(WIFI_PS_NONE);

  // Wait for connection
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  Serial.println("");
  Serial.println("WiFi connected");
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP());

  // Initialize mapper device
  dev = mpr_dev_new("ESP32", 0);

  float signalMin = 0.0f;
  float signalMax = 3.3f;

  // Add output signal with type integer and unit "V" (for voltage)
  outputSignal = mpr_sig_new(dev, MPR_DIR_OUT, "sensorValue", 1, MPR_FLT, "V",
                             &signalMin, &signalMax, 0, 0, 0);
}

void loop() {
  // Poll device
  mpr_dev_poll(dev, 0);

  // Update signal with analog value
  float value = analogRead(A0) / 1023.0f * 3.3f;
  mpr_sig_set_value(outputSignal, 0, 1, MPR_FLT, &value);
}
