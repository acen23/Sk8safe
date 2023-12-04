//
//  DataModel.swift
//  Sk8safe
//
//  Created by Andrew Cen on 11/28/23.
//
//  This is the super model that composes both smaller models
//

import Foundation
import SwiftUI

class DataModel: ObservableObject{
    // Composes both models
    private var bt = BTModel() {
        didSet {
            // React to changes in the composed model itself
            print("Composed model changed")
            self.connected = bt.connected
        }
    }
    
    private let lm = LocationModel()
    
    // Composed variables from BTModel
    @Published var connected: Bool = false
    
    init() { // Add "override" if inheriting
        self.connected = bt.connected
    }
    
    func updateComposedModelProperty(newValue: Bool) {
        bt.connected = newValue
    }
}
