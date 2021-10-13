//
//  GradientBackground.swift
//  GradientBackground
//
//  Created by Luke Drushell on 7/25/21.
//

import SwiftUI

struct GradientBackground: View {
    let color1: Color
    let color2: Color
    
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [color1, color2], startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
//                .overlay(alignment: .bottom, content: {
//                    LinearGradient(colors: [.black.opacity(0.6), .black.opacity(0)], startPoint: .bottom, endPoint: .center)
//                })
        }
    }
}
