// Basic demo for accelerometer readings from Adafruit MPU6050

// ESP32 Guide: https://RandomNerdTutorials.com/esp32-mpu-6050-accelerometer-gyroscope-arduino/
// ESP8266 Guide: https://RandomNerdTutorials.com/esp8266-nodemcu-mpu-6050-accelerometer-gyroscope-arduino/
// Arduino Guide: https://RandomNerdTutorials.com/arduino-mpu-6050-accelerometer-gyroscope/

#include <Adafruit_MPU6050.h>
#include <Adafruit_Sensor.h>
#include <Wire.h>
#include <BLEDevice.h>
#include <BLEUtils.h>
#include <BLEServer.h>

#define SERVICE_UUID "d692a318-2485-4317-9cef-794a22ee7a3f"
#define ON_UUID       "57393a70-64a7-4d66-9892-9280a6b68bfd"
#define DATA_UUID "f06d2d2e-2b74-4d37-a4e3-9baf01407d0a" 

const int LED = 14;
const int VIB = 8;
uint8_t ON = 0;
Adafruit_MPU6050 mpu;
BLECharacteristic *dataCharacteristic;
unsigned long previousMillis = 0;  // Variable to store the last time the timer was updated
unsigned long interval = 2000;    // Interval for the timer in milliseconds (1 second in this case)


class ServerCallbacks: public BLEServerCallbacks {
    void onConnect(BLEServer* pServer) {
      Serial.println("Client connected.");
    }

    void onDisconnect(BLEServer* pServer) {
      Serial.println("Client disconnected.");
      BLEDevice::startAdvertising();
    }
};

class ON_Charic_Callback: public BLECharacteristicCallbacks {
    void onWrite(BLECharacteristic *pCharacteristic) {
      ON = *(pCharacteristic->getData());
      digitalWrite(LED, ON);
      USBSerial.println("IT WORKS");
    }
};



void setup(void) {
  USBSerial.begin(115200);
  pinMode(VIB,INPUT);
  pinMode(LED, OUTPUT);

  BLEDevice::init("ESP32 LED Lamp");
  BLEServer *pServer = BLEDevice::createServer();
  pServer->setCallbacks(new ServerCallbacks());

  BLEService *pService = pServer->createService(SERVICE_UUID);
  BLECharacteristic *ON_charic = pService->createCharacteristic(ON_UUID,BLECharacteristic::PROPERTY_READ | BLECharacteristic::PROPERTY_WRITE);
  ON_charic->setCallbacks(new ON_Charic_Callback());
  ON_charic->setValue(&ON, 1);

  dataCharacteristic = pService->createCharacteristic(DATA_UUID, BLECharacteristic::PROPERTY_READ | BLECharacteristic::PROPERTY_WRITE);


  pService->start();
  BLEAdvertising *pAdvertising = BLEDevice::getAdvertising();
  pAdvertising->addServiceUUID(SERVICE_UUID);
  pAdvertising->setScanResponse(true);
  pAdvertising->setMinPreferred(0x06);  // functions that help with iPhone connections issue
  pAdvertising->setMinPreferred(0x12);
  BLEDevice::startAdvertising();



  Wire.setPins(21,  26);
 // Try to initialize!
  if (!mpu.begin()) {
    USBSerial.println("Failed to find MPU6050 chip");
    while (1) {
      delay(10);
    }
  }
  USBSerial.println("MPU6050 Found!");

  mpu.setAccelerometerRange(MPU6050_RANGE_8_G);
  mpu.setGyroRange(MPU6050_RANGE_500_DEG);
  mpu.setFilterBandwidth(MPU6050_BAND_5_HZ);
}

void loop() {
  float data[4];
  /* Get new sensor events with the readings */
  sensors_event_t a, g, temp;
  mpu.getEvent(&a, &g, &temp);

  /* Print out the values */
  float x_acc = a.acceleration.x;
  float y_acc = a.acceleration.y;
  float z_acc = a.acceleration.z;
  // USBSerial.print("Acceleration X: ");
  USBSerial.print(x_acc);
  data[0] = x_acc;
  USBSerial.print(" ");
  // USBSerial.print(", Y: ");
  USBSerial.print(y_acc);
  data[1] = y_acc;
  USBSerial.print(" ");
  // USBSerial.print(", Z: ");
  USBSerial.print(z_acc);
  data[2] = z_acc;
  USBSerial.print(" ");
  int vibration = analogRead(VIB);
  USBSerial.print(vibration);
  USBSerial.print(" ");
  if(vibration>200){
    if(z_acc < 7 || z_acc > 12){
      USBSerial.print(100);
      USBSerial.print(" ");
      data[3] = vibration;
      uint8_t byteArray[sizeof(data) * sizeof(float)]; // Create byte array to hold the converted data

      // Convert float array to byte array
      for (size_t i = 0; i < sizeof(data); i++) {
        memcpy(&byteArray[i * sizeof(float)], &data[i], sizeof(float));
      }
      dataCharacteristic->setValue(byteArray, sizeof(byteArray));
    }
  } else {
    USBSerial.println(0);
  }
  USBSerial.println("");
  delay(100);

}