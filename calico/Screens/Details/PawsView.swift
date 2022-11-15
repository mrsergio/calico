//
//  PawsView.swift
//  calico
//
//  Created by Sergii Simakhin on 11/14/22.
//

import SwiftUI

struct PawsView: View {
    
    private var opacity: Double {
        [0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8].randomElement() ?? 0.5
    }
    
    private var angle: Angle {
        let range: [Double] = [-45.0, -30.0, -15.0, 0.0, 15.0, 30.0, 45.0]
        let value = range.randomElement() ?? 0
        return Angle(degrees: value)
    }
    
    var body: some View {
        Text("🐾")
            .opacity(opacity)
            .rotationEffect(angle)
    }
}

struct PawsView_Previews: PreviewProvider {
    static var previews: some View {
        PawsView()
    }
}
