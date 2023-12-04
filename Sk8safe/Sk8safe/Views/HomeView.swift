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
                        .foregroundColor(dm.bt.connected ? .green : .red)
                    .frame(width: 20, height: 20)
                    Text("Connected")
                }
                
                Button {
                } label: {
                  Text("Record")
                }
                .buttonStyle(.borderedProminent)
                .disabled(!dm.bt.connected)
                NavigationLink(destination: DataView().environmentObject(dm)) {
                    Text("View Data")
                }
                Button(action:{
                    print(dm.bt.connected)
                } ) {
                    Text("TEST CONNECT")
                }
                Button(action:{
                    dm.updateComposedModelProperty(newValue: !dm.bt.connected)
                }){
                    Text("CHANGE CONNECT")
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
