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
import Combine

struct Bump: Identifiable {
    let id = UUID()
    var coordinate: CLLocationCoordinate2D
    // let freq: Bool // true if heavy frequency, false if not often
}

class DataModel: ObservableObject{
    // Composes LocationModel
    private let lm = LocationModel()
    
    private var cancellables: Set<AnyCancellable> = [] // for publisher-subscriber
    
    @Published var currRegion = MKCoordinateRegion()
    @Published var annotations: [Bump]
    @Published var recordBoo = false
    @Published var connected = false
    
    init(bt: BTModel){
        currRegion = lm.currRegion // ensures that current region tracked on the map is initialized once
        annotations = []
        recordBoo = false
        bt.$boo
            .sink { [weak self] newValue in
                // React to changes in Model B
                print("DataModel detected change in BTModel's boo!")
                if(bt.boo){
                    self?.addBump()
                }
            }
            .store(in: &cancellables)
        bt.$connected
            .sink { [weak self] newValue in
                // React to changes in Model B
                print("DataModel detected change in BTModel's connected!")
                self?.connected = bt.connected
            }
            .store(in: &cancellables)
    }
    
    func printLocation(){
        print("Latitude: \(lm.currCoord.latitude), Longitude: \(lm.currCoord.longitude)")
    }
    
    func addBump(){
        if(self.recordBoo){
            print("Added bump!")
            self.annotations.append(Bump(coordinate: self.lm.currCoord))
        }
    }
}
