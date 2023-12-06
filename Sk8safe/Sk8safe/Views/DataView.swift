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
                    MapPin(coordinate: annotation.coordinate, tint: .blue)
        }
        .frame(width: 400, height: 300)
        Button(action:{
            dm.printLocation()
        }){
            Text("Check location")
        }
        Button(action:{ // DELETE AFTER TESTING
            dm.addBump()
        }){
            Text("Add bump")
        }
    }
}

struct DataView_Previews: PreviewProvider {
    static var previews: some View {
        DataView()
    }
}
