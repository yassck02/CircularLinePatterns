//
//  ContentView.swift
//  ColorTools-Demo
//
//  Created by Connor yass on 3/27/20.
//  Copyright © 2020 Chinaberry Tech, LLC. All rights reserved.
//

import SwiftUI

/// A slider and a text field that can be used to input a numeric value.
/// The text in the text field and the slider are kept in sync
struct CBTextSlider: View {
    
    var value: Binding<Float>
    
    private var title: String
    
    private var minimumValue: Int
    
    private var maximumValue: Int
    
    init(minimum: Int = 0, value: Binding<Float>, maximum: Int = 100, title: String = "") {
        self.minimumValue = min(maximum, minimum)
        self.maximumValue = max(maximum, minimum)
        self.value = value
        self.title = title
    }
    
    var body: some View {
        let f = NumberFormatter()
        f.alwaysShowsDecimalSeparator = true
        f.formatWidth = 3
        f.minimum = minimumValue as NSNumber
        f.maximum = maximumValue as NSNumber
        
        return HStack(spacing: 12.0) {
            Text(title)
                .frame(width: 75, alignment: .leading)
            Slider(value: value)
            TextField("", value: value, formatter: f)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.decimalPad)
                .frame(width: 75, height: nil, alignment: .center)
        }
    }
}

#if DEBUG
struct CBSliderTextView_Previews: PreviewProvider {
    
    static var previews: some View {
        CBTextSlider(minimum: 0, value: .constant(0.5), maximum: 1, title: "Title")
            .previewLayout(.fixed(width: 500, height: 50))
            .accentColor(.gray)
            .padding()
    }
}
#endif
