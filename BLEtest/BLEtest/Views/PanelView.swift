//
//  PanelView.swift
//  BLEtest
//
//  Created by Andrew Cen on 10/31/23.
//
// THIS IS THE MAIN VIEW THAT YOU WILL SEE TO NAVIGATE FROM
//

import SwiftUI

struct PanelView: View {
    @EnvironmentObject var ble: BLEtestModel

    var body: some View {
        Text("Hello, World!") // change later
        NavigationView {
            List {
                Section("Status") {
                    HStack {
                        Image(systemName: "lightbulb")
                        Text("LED")
                        Spacer()
                        Text("Connected")
                            .foregroundColor(.blue)
                    }
                }
                
                Section("LED Control") {
                    Toggle(isOn: $ble.boo) {
                        Text("LED on")
                    }
                    .onChange(of: ble.boo) { newValue in
                        print("hi")
                        ble.peripheral?.writeValue(Data([ble.boo ? 1 : 0]), for: ble.characteristics["ON"]!, type: .withResponse)
                    }
                }
                
                Section("Advanced") {
                    NavigationLink(destination: DebugView().environmentObject(ble)) {
                        Text("Debug info")
                    }
                }
            }
            .navigationTitle("Controls")
        }
        .navigationViewStyle(.stack)
    }
}

struct PanelView_Previews: PreviewProvider {
    static var previews: some View {
        PanelView()
            .environmentObject(BLEtestModel())
    }
}
