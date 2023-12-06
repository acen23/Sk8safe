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
    @StateObject var dm: DataModel
    @StateObject var bt: BTModel
    
    init(){
        let bt = BTModel()
        _bt = StateObject(wrappedValue: bt)
        _dm = StateObject(wrappedValue: DataModel(rep: bt as Report))
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Image("logo")
                    .resizable()
                    .frame(width: 100, height: 100)
                HStack {
                    Circle()
                        .foregroundColor(bt.connected ? .green : .red)
                    .frame(width: 20, height: 20)
                    Text("Connected")
                }
                
                Button {
                } label: {
                  Text("Record")
                }
                .buttonStyle(.borderedProminent)
                .disabled(!bt.connected)
                NavigationLink(destination: DataView().environmentObject(dm)) {
                    Text("View Data")
                }
                Button(action:{ // GET RID OF THIS BUTTON AFTER TESTING
                    print(bt.connected)
                } ) {
                    Text("TEST CONNECT")
                }
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
