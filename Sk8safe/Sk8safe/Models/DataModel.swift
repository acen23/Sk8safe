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
    private let bt = BTModel()
    private let lm = LocationModel()
    
    // Composed variables from BTModel
    @Published var connected: Bool = false
    @Published var loaded: Bool = false
    
    init() { // Add "override" if inheriting
        self.connected = bt.connected
        self.loaded = bt.loaded
    }
}
