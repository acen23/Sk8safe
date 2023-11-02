#include <BLEDevice.h>
#include <BLEUtils.h>
#include <BLEServer.h>


// ble constants
#define SERVICE_UUID "d692a318-2485-4317-9cef-794a22ee7a3f"
#define ON_UUID       "57393a70-64a7-4d66-9892-9280a6b68bfd"
const int LED = 14;
const int S_OK  = 0xaa;
const int S_ERR = 0xff;
uint8_t ON = 0;

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

/*
void on_receive(void* event_handler_arg, esp_event_base_t event_base, int32_t event_id, void* event_data) { 
  // read one byte
  int state = USBSerial.read();
  // guard byte is valid LED state
  if (!(state == LOW || state == HIGH)) {
    // invalid byte received
    // what else should we do?
    // update LED with valid state
    USBSerial.write(S_ERR);
    return;
  }
  digitalWrite(LED, state);
  USBSerial.write(S_OK);
}
*/

void setup() {
  USBSerial.begin(9600);

  pinMode(LED, OUTPUT);

  BLEDevice::init("ESP32 LED Lamp");
  BLEServer *pServer = BLEDevice::createServer();
  pServer->setCallbacks(new ServerCallbacks());

  BLEService *pService = pServer->createService(SERVICE_UUID);
  BLECharacteristic *ON_charic = pService->createCharacteristic(ON_UUID,BLECharacteristic::PROPERTY_READ | BLECharacteristic::PROPERTY_WRITE);

  ON_charic->setCallbacks(new ON_Charic_Callback());

  ON_charic->setValue(&ON, 1);

  pService->start();
  BLEAdvertising *pAdvertising = BLEDevice::getAdvertising();
  pAdvertising->addServiceUUID(SERVICE_UUID);
  pAdvertising->setScanResponse(true);
  pAdvertising->setMinPreferred(0x06);  // functions that help with iPhone connections issue
  pAdvertising->setMinPreferred(0x12);
  BLEDevice::startAdvertising();
}

void loop() {

}