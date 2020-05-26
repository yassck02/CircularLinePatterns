//
//  CBColorPicker.swift
//  ColorTools-Demo
//
//  Created by Connor yass on 4/3/20.
//  Copyright © 2020 Chinaberry Tech, LLC. All rights reserved.
//

import SwiftUI

struct CBColorPickerConfig {
    var showColorPreview: Bool = true
}

/// A view that allows the user to input a color value
struct CBColorPicker: View {
    
    @Binding var value: CBColor
    
    var config = CBColorPickerConfig()
    
    var body: some View {
        VStack {
            if config.showColorPreview {
                value.swiftUIColor.cornerRadius(6.0)
            }
            VStack {
                CBTextSlider(value: $value.r, title: "R")
                CBTextSlider(value: $value.g, title: "G")
                CBTextSlider(value: $value.b, title: "B")
                CBTextSlider(value: $value.a, title: "A")
            }
            .accentColor(.gray)
        }
    }
}

#if DEBUG
struct CBColorPicker_Previews: PreviewProvider {
    
    @State static var color: CBColor = .purple
    
    static var config = CBColorPickerConfig(showColorPreview: true)
    
    static var previews: some View {
        
        CBColorPicker(value: $color, config: config)
            .padding()
            .previewLayout(.fixed(width: 500, height: 500))
    }
}
#endif
