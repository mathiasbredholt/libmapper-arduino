#include <WiFi.h>
#include <M5StickC.h>
#include "mapper.h"

// For disabling power saving
#include "esp_wifi.h"

const char* ssid     = "WIFI_SSID";
const char* password = "WIFI_PASSWORD";

mapper_device dev = 0;
mapper_signal input_signal = 0;
mapper_signal output_signal = 0;
float seq_number = 0;
float received_value = 0;

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

  float min = 0.0f;
  float max = 5.0f;

  dev = mapper_device_new("M5StickC", 0, 0);
  output_signal = mapper_device_add_output_signal(dev, "value_to_send", 1, 'f', "V", &min, &max);
  input_signal = mapper_device_add_input_signal(dev, "value_received", 1, 'f', 0, &min, &max, input_signal_handler, 0);

  // LCD display
  // M5.Lcd.print("Hello World");

  pinMode(M5_LED, OUTPUT);
  digitalWrite(M5_LED, HIGH);
}

void loop() {
  mapper_device_poll(dev, 0);
  M5.Lcd.fillScreen(BLUE);
  seq_number = seq_number + 0.01f;
  mapper_signal_update_float(output_signal, seq_number);
  M5.Lcd.setCursor(0, 10);
  M5.Lcd.print(received_value);
  delay(100);
}

void input_signal_handler(mapper_signal sig, mapper_id instance, const void *value, int count, mapper_timetag_t *timetag) {
  if (value) {
    float *v = (float*)value;
    for (int i = 0; i < mapper_signal_length(sig); i++) {
      received_value = v[i];
    }
  }
}
