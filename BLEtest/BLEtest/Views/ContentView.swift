//
//  ContentView.swift
//  BLEtest
//
//  Created by Andrew Cen on 10/26/23.
//
// THIS IS ONE OF THE VIEWS
//

import SwiftUI

struct ContentView: View {
    @StateObject var ble = BLEtestModel()
    var body: some View {
        if ble.loaded {
            PanelView()
                .environmentObject(ble)
        } else {
            VStack {
                Spacer()

                HStack {
                    Spacer()

                    VStack {
                        ProgressView()
                            .padding()
                        
                        Text(ble.connected ? "Connected. Loading..." : "Looking for device...")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }

                    Spacer()
                }

                Spacer()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
