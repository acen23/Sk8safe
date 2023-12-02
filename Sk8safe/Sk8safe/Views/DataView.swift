//
//  DataView.swift
//  Sk8safe
//
//  Created by Andrew Cen on 11/28/23.
//

import Foundation
import SwiftUI

struct DataView: View {
    
    @StateObject var dm = DataModel()
    var body: some View {
        Text("Hello, World!")
    }
}

struct DataView_Previews: PreviewProvider {
    static var previews: some View {
        DataView()
    }
}
