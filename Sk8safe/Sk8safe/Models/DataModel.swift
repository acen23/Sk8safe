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

class DataModel: ObservableObject{
    // Composes both models
    // private let bt = BTModel() // MAY NOT NEED TO COMPOSE BTModel
    private let lm = LocationModel()
    
    func requestLocation(){
        lm.requestOnTimeLocation()
    }
}
