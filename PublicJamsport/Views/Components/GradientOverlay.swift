//
//  GradientOverlay.swift
//  PublicJamsport
//
//  Created by Quang Minh Nguyen on 18/9/2024.
//

import SwiftUI

struct GradientOverlay: View {
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.5), Color.clear]), startPoint: .top, endPoint: .bottom)
            .frame(height: 100)
            .background(BlurEffect(style: .systemMaterial))
    }
}

// Helper blur effect view
struct BlurEffect: UIViewRepresentable {
    var style: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: style))
        return view
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}
