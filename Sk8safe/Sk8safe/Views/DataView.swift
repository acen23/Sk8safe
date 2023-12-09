//
//  DataView.swift
//  Sk8safe
//
//  Created by Andrew Cen on 11/28/23.
//

import Foundation
import SwiftUI
import MapKit

struct DataView: View {
    @EnvironmentObject var dm: DataModel
    var body: some View {
        Map(coordinateRegion: $dm.currRegion, showsUserLocation: true,
            userTrackingMode: .constant(.follow), annotationItems: dm.annotations) { annotation in
            MapAnnotation(coordinate: annotation.coordinate){
                Circle()
                    .foregroundColor(.red)
                    .scaledToFit()
                    .opacity(0.5)
                    .frame(width: 30, height: 30)
            }
        }
        .frame(width: 400, height: 300)
        Button(action:{
            dm.printLocation()
        }){
            Text("Check location")
        }/*
        Button(action:{ // DELETE AFTER TESTING
            dm.addBump()
        }){
            Text("Add bump")
        }*/
        Button(action:{
            dm.clear()
        }){
            Text("Clear data")
        }
    }
}

struct DataView_Previews: PreviewProvider {
    static var previews: some View {
        DataView()
    }
}
