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
                Image("logo")
                    .resizable()
                    .frame(width: 100, height: 100)
                HStack {
                    Circle()
                        .foregroundColor(dm.connected ? .green : .red)
                    .frame(width: 20, height: 20)
                    Text("Connected")
                }
                Button(action:{
                    dm.recordBoo = true
                    print("Recording...")
                }){
                  Text("Record")
                }
                .buttonStyle(.borderedProminent)
                .disabled(!dm.connected || dm.recordBoo)
                Button(action:{
                    dm.recordBoo = false
                    print("Stopped recording")
                }){
                  Text("Stop")
                }
                .buttonStyle(.borderedProminent)
                .disabled(!dm.recordBoo)
                NavigationLink(destination: DataView().environmentObject(dm)) {
                    Text("View Data")
                }/*
                Button(action:{ // GET RID OF THIS BUTTON AFTER TESTING
                    print(dm.connected)
                } ) {
                    Text("TEST CONNECT")
                }*/
                /*Button(action:{ // GET RID OF THIS BUTTON AFTER TESTING
                    bt.connected = !bt.connected
                }){
                    Text("CHANGE CONNECT")
                }*/
            }
            .navigationBarTitle(Text("Sk8safe"))
            
        }
        .navigationViewStyle(.stack)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
