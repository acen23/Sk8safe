//
//  HomeView.swift
//  Sk8safe
//
//  Created by Andrew Cen on 11/28/23.
//
//  This is the home screen of the app
//

import SwiftUI

struct HomeView: View {
    @StateObject var bt = BTModel()
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Circle()
                    //.foregroundColor(bt.connected ? .green : .red)
                    .foregroundColor(.green) // DELETE LATER
                    .frame(width: 20, height: 20)
                    Text("Connected")
                }
                
                Button {
                } label: {
                  Text("Record")
                }
                .buttonStyle(.borderedProminent)
                //.disabled(bt.connected)
                NavigationLink(destination: DataView().environmentObject(bt)) {
                    Text("View Data")
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
