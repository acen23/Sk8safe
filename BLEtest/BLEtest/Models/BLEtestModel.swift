//
//  BLEtestModel.swift
//  BLEtest
//
//  Created by Andrew Cen on 10/26/23.
//
// THIS IS THE MODEL THAT HOLDS THE DATA WE WANT TO ACCESS AND MUTATE
//

import Foundation
import SwiftUI
import CoreBluetooth

class BLEtestModel: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    // CB objects
    var centralManager: CBCentralManager!
    var peripheral: CBPeripheral?
    
    // backend color components
    @Published var boo: Bool = true
    var c: CGFloat = 0

    // UUID and characteristic organization
    let SERVICE_UUID: CBUUID = CBUUID(string: "d692a318-2485-4317-9cef-794a22ee7a3f")

    var characteristics: [String: CBCharacteristic] = [:]

    let characteristic_key: [CBUUID: String] = [
        CBUUID(string: "57393a70-64a7-4d66-9892-9280a6b68bfd"): "ON"
    ]

    // UI interface variables
    @Published var connected: Bool = false
    @Published var loaded: Bool = false
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOff:
            print("Is Powered Off.")
        case .poweredOn:
            print("Is Powered On.")
            startScanning()
        case .unsupported:
            print("Is Unsupported.")
        case .unauthorized:
            print("Is Unauthorized.")
        case .unknown:
            print("Unknown")
        case .resetting:
            print("Resetting")
        @unknown default:
            print("Error")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        print("Discovered peripheral: \(peripheral)")
        
        self.peripheral = peripheral
        
        centralManager.connect(self.peripheral!)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected!")
        
        self.peripheral!.delegate = self
        self.peripheral!.discoverServices([SERVICE_UUID])
        
        stopScanning()
        
        // inform UI
        withAnimation {
            connected = true
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Disconnected.")
        
        self.peripheral = nil
        
        // inform UI
        withAnimation {
            connected = false
            loaded = false
        }
        
        startScanning()
    }
    
    func startScanning() {
        print("Scanning")
        centralManager.scanForPeripherals(withServices: [SERVICE_UUID])
    }

    func stopScanning() {
        centralManager.stopScan()
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        
        print("Discovering services...")
        
        for service in services {
            print("Service: \(service)")
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        
        print("Discovering characteristics for service: \(service)")
        
        for characteristic in characteristics {
            print("Characteristic: \(characteristic)")
            print("\t- R/W: \(characteristic.properties.contains(.read))/\(characteristic.properties.contains(.write))")
            
            if let name = characteristic_key[characteristic.uuid] {
                print("\t- Characteristic key: \(name)")
                self.characteristics[name] = characteristic

                self.peripheral?.readValue(for: characteristic)
            }
        }
        
        if characteristics.count == characteristic_key.count { // discovered all expected characteristics
            // inform UI
            withAnimation {
                loaded = true
            }
            
            /*// spawn daemon updater thread
            DispatchQueue.global().async {
                self.updatePeriodic()
            }*/
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard let data = characteristic.value else { return }
        print(data)
        if(characteristic_key[characteristic.uuid] == "ON"){
            c = loadVal(data: data)
            if(c == 0){
                boo = false
            }
            else{
                boo = true
            }
        }
        else{
            print("Updated value for invalid characteristic.")
        }
            
        // inform UI to update to reflect computed property (color) change
        objectWillChange.send()
        }
    
    private func loadVal(data: Data) -> CGFloat {
        return CGFloat(
            data.withUnsafeBytes({ (rawPtr: UnsafeRawBufferPointer) in
                return rawPtr.load(as: UInt8.self)
            })
        )
    }
}
