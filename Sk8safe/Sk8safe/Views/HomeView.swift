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
        Circle()
            .foregroundColor(bt.connected ? .green : .red)
        // TODO: add text label to the circle indicator
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
