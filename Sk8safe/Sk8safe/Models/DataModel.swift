//
//  DataModel.swift
//  Sk8safe
//
//  Created by Andrew Cen on 11/28/23.
//
//  This is the super model that composes the LocationModel
//

import Foundation
import SwiftUI
import CoreLocation
import MapKit

class DataModel: ObservableObject{
    // Composes both models
    // private let bt = BTModel() // MAY NOT NEED TO COMPOSE BTModel
    private let lm = LocationModel()
    @Published var currRegion = MKCoordinateRegion()
    
    init(){
        currRegion = lm.currRegion // ensures that current region tracked on the map is initialized once
    }
    
    func printLocation(){
        print("Latitude: \(lm.currCoord.latitude), Longitude: \(lm.currCoord.longitude)")
    }
    
    struct Bump: Identifiable {
        let id = UUID()
        let name: String
        let coordinate: CLLocationCoordinate2D
    }
}
