//
//  DebugView.swift
//  Lamp (iOS)
//
//  Created by Adin Ackerman on 9/8/22.
//

import SwiftUI

struct DebugView: View {
    @EnvironmentObject var ble: BLEtestModel
    
    @State var isPresented = false
    
    var body: some View {
        List {
            Section("BLE") {
                InfoRowView(name: "Device name", value: ble.peripheral?.name ?? "UNKNOWN")
                InfoRowView(name: "Service UUID", value: "\(ble.SERVICE_UUID.uuidString)", doTextField: true)
            }
            
            Section("Characteristics") {
                InfoRowView(name: "Characteristics", value: "\(ble.characteristics.count)")
                
                ForEach(ble.characteristics.keys.sorted(), id: \.self) { key in
                    let characteristic = ble.characteristics[key]!
                    
                    VStack {
                        InfoRowView(name: "Key", value: key)
                        InfoRowView(name: "UUID", value: "\(characteristic.uuid.uuidString)", doTextField: true)
                    }
                }
            }
        }
        .navigationTitle("Debug Info")
    }
}

struct DebugView_Previews: PreviewProvider {
    static var previews: some View {
        DebugView()
            .environmentObject(BLEtestModel())
    }
}
