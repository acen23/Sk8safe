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
    @StateObject var dm = DataModel()
    @StateObject var lm = LocationModel()
    var body: some View {
        Map(coordinateRegion: $lm.currRegion, showsUserLocation: true, userTrackingMode: .constant(.follow))
                    .frame(width: 400, height: 300)
    }
}

struct DataView_Previews: PreviewProvider {
    static var previews: some View {
        DataView()
    }
}
