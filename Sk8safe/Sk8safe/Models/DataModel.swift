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

struct Bump: Identifiable {
    let id = UUID()
    var coordinate: CLLocationCoordinate2D
    // let freq: Bool // true if heavy frequency, false if not often
}

class DataModel: ObservableObject{
    // Composes both models
    private let bt = BTModel() // MAY NOT NEED TO COMPOSE BTModel
    private let lm = LocationModel()
    @Published var currRegion = MKCoordinateRegion()
    @Published var annotations: [Bump]
    
    init(){
        currRegion = lm.currRegion // ensures that current region tracked on the map is initialized once
        annotations = []
    }
    
    func printLocation(){
        print("Latitude: \(lm.currCoord.latitude), Longitude: \(lm.currCoord.longitude)")
    }
    
    func addBump(){
        annotations.append(Bump(coordinate: lm.currCoord))
    }
}
