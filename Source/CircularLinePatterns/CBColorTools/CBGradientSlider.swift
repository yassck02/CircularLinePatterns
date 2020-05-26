//
//  GradientSlider.swift
//  ColorTools-Demo
//
//  Created by Connor yass on 4/14/20.
//  Copyright © 2020 Chinaberry Tech, LLC. All rights reserved.
//

import SwiftUI

/// A simple slider that displays a gradient as its track rather than a solid color
struct CBGradientSlider: View {
    
    @ObservedObject var gradient: CBGradient
    
    @State var trackThickness: CGFloat = 10
    
    @State var thumbSize: CGFloat = 10
    
    var body: some View {
        LinearGradient(gradient: gradient.swiftUIGradient, startPoint: .leading, endPoint: .trailing)
            .frame(minHeight: trackThickness, maxHeight: trackThickness, alignment: .center)
            .cornerRadius(trackThickness/2.0)
    }
}

#if DEBUG
struct CBGradientSlider_Previews: PreviewProvider {
    
    @State static var gradient = CBGradient(keys: [
        CBGradient.Key(color: .pink, location: 0.0),
        CBGradient.Key(color: .green, location: 1.0)
    ])
    
    static var previews: some View {
        CBGradientSlider(gradient: gradient)
    }
}
#endif
