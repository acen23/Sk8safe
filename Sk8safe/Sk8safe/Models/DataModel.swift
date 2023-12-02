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
}
