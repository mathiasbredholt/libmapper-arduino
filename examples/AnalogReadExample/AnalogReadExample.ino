// Arduino libmapper library example

#include "WiFi.h"
#include "mapper.h"

// WiFi ssid and password
const char ssid[] = "ssid";
const char password[] = "password";

// Mapper device name
const char deviceName[] = "Arduino"; 

// Signal name
const char signalName[] = "TestSignal";

const int signalMin = 0;
const int signalMax = 1023;

const int readPin = 0;

mapper_device dev;
mapper_signal sig;

void setup() {
    pinMode(readPin, INPUT);

    // Begin WiFi before creating mapper device
    WiFi.begin(ssid, password);
    
    // Initialize mapper device
    dev = mapper_device_new(deviceName, 0, 0);

    // Add output signal
    sig = mapper_device_add_output_signal(dev, signalName, 1, 'i', 0, &signalMin, &signalMax);
}

void loop() {
    // Poll device
    mapper_device_poll(dev, 0);

    // Update signal with analog value
    mapper_signal_update_int(sig, analogRead(readPin));
}