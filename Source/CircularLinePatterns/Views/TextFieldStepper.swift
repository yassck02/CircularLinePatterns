//
//  TextFieldStepper.swift
//  Life
//
//  Created by Connor yass on 5/18/20.
//  Copyright © 2020 Chinaberry Tech, LLC. All rights reserved.
//

import SwiftUI

struct TextFieldStepper: View {
    
    var value: Binding<Int>
    
    private var title: String
    
    private var minimumValue: Int
    
    private var maximumValue: Int
    
    init(minimum: Int = 0, value: Binding<Int>, maximum: Int = 100, title: String = "") {
        self.minimumValue = min(maximum, minimum)
        self.maximumValue = max(maximum, minimum)
        self.value = value
        self.title = title
    }
    
    var body: some View {
        let f = NumberFormatter()
        f.minimum = minimumValue as NSNumber
        f.maximum = maximumValue as NSNumber
        
        return HStack {
            Stepper(title, value: value, in: minimumValue...maximumValue, step: 1)
            TextField("", value: value, formatter: f)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
        }
    }
}

#if DEBUG
struct TextFieldStepper_Previews: PreviewProvider {
    
    @State static var value: Int = 5
    
    static var previews: some View {
        TextFieldStepper(minimum: 0, value: $value, maximum: 10, title: "Title")
            .previewLayout(.fixed(width: 500, height: 50))
            .accentColor(.gray)
            .padding()
    }
}
#endif
