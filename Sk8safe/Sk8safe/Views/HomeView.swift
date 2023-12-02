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
    @StateObject var dm = DataModel()
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Circle()
                    //.foregroundColor(dm.connected ? .green : .red)
                    .foregroundColor(.green) // DELETE LATER
                    .frame(width: 20, height: 20)
                    Text("Connected")
                }
                
                Button {
                } label: {
                  Text("Record")
                }
                .buttonStyle(.borderedProminent)
                //.disabled(dm.connected)
                NavigationLink(destination: DataView().environmentObject(dm)) {
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
