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

protocol Report {
    func report(boo: Bool)
}

class DataModel: ObservableObject{
    // Composes LocationModel
    private let lm = LocationModel()
    private let rep: Report
    
    @Published var currRegion = MKCoordinateRegion()
    @Published var annotations: [Bump]
    
    init(rep: Report){
        self.rep = rep
        currRegion = lm.currRegion // ensures that current region tracked on the map is initialized once
        annotations = []
    }
    
    func report_in_BTModel(boo: Bool){
        // use boo to check if bump detected or not
        // report will be called everytime a bump is detected to update boo
        rep.report(boo: boo)
        if(boo){
            addBump()
        }
    }
    
    func printLocation(){
        print("Latitude: \(lm.currCoord.latitude), Longitude: \(lm.currCoord.longitude)")
    }
    
    func addBump(){
        annotations.append(Bump(coordinate: lm.currCoord))
    }
}
