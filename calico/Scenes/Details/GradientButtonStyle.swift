//
//  GradientButtonStyle.swift
//  calico
//
//  Created by Sergii Simakhin on 11/14/22.
//

import SwiftUI

struct GradientButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(Color.white)
            .padding()
            .background(
                LinearGradient(
                    gradient: Gradient(
                        colors: [Color.purple, Color.red]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(16.0)
            .shadow(radius: 4, x: 0, y: 2)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.4, dampingFraction: 0.6), value: configuration.isPressed)
    }
}
