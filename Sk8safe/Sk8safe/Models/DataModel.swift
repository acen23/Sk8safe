//
//  DataModel.swift
//  Sk8safe
//
//  Created by Andrew Cen on 11/28/23.
//
//  This is the super model that composes the LocationModel
//

import Foundation
import SwiftUI
import CoreLocation
import MapKit
import CoreBluetooth

struct Bump: Identifiable {
    let id = UUID()
    var coordinate: CLLocationCoordinate2D
    // let freq: Bool // true if heavy frequency, false if not often
}

class DataModel: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate{
    // CB objects
    var centralManager: CBCentralManager!
    var peripheral: CBPeripheral?
    
    // backend color components TODO: CHANGE THIS
    var c: CGFloat = 0
    
    // UUID and characteristic organization
    let SERVICE_UUID: CBUUID = CBUUID(string: "d692a318-2485-4317-9cef-794a22ee7a3f")
    
    var characteristics: [String: CBCharacteristic] = [:]
    
    let characteristic_key: [CBUUID: String] = [
        CBUUID(string: "57393a70-64a7-4d66-9892-9280a6b68bfd"): "SENSE"
    ]
    
    // UI interface variables
    @Published var connected: Bool = false
    var loaded: Bool = false
    
    // Composes LocationModel
    private let lm = LocationModel()
    
    @Published var currRegion = MKCoordinateRegion()
    @Published var annotations: [Bump]
    @Published var recordBoo = false
    
    override init(){
        annotations = []
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
        currRegion = lm.currRegion // ensures that current region tracked on the map is initialized once
        recordBoo = false
    }
    
    func printLocation(){
        print("Latitude: \(lm.currCoord.latitude), Longitude: \(lm.currCoord.longitude)")
    }
    
    func addBump(){
        if(recordBoo){
            print("Added bump!")
            annotations.append(Bump(coordinate: lm.currCoord))
        }
    }
    
    func clear(){
        annotations.removeAll()
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
        
        connected = true
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Disconnected.")
        
        self.peripheral = nil
        
        connected = false
        loaded = false
        
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
            // Enabling receiving feature
            if characteristic.uuid == CBUUID(string: "57393a70-64a7-4d66-9892-9280a6b68bfd") { // BUTTON UUID
                self.peripheral?.setNotifyValue(true, for: characteristic)
            }
        }
        
        
        if characteristics.count == characteristic_key.count { // discovered all expected characteristics
            // inform UI
            loaded = true
            
            // TODO: CHECK IF WE NEED UPDATE PERIODIC
            // spawn daemon updater thread
            /*DispatchQueue.global().async {
                self.addBump()
            }*/
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard let data = characteristic.value else { return }
        print(data)
        if(characteristic_key[characteristic.uuid] == "SENSE"){
            // TODO: Change handling of receiving data
            c = loadVal(data: data)
            if(c == 0){
                print("Sent false")
            }
            else{
                addBump()
                print("Sent true")
            }
        }
        else{
            print("Updated value for invalid characteristic.")
        }
            
        // inform UI to update to reflect computed property (color) change
        objectWillChange.send()
    }
    
    // TODO: Change handling of receiving data
    private func loadVal(data: Data) -> CGFloat {
        return CGFloat(
            data.withUnsafeBytes({ (rawPtr: UnsafeRawBufferPointer) in
                return rawPtr.load(as: UInt8.self)
            })
        )
    }
}
