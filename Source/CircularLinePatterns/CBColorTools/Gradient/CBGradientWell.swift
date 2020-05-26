//
//  CBGradientWell.swift
//  ColorTools-Demo
//
//  Created by Connor yass on 4/3/20.
//  Copyright © 2020 Chinaberry Tech, LLC. All rights reserved.
//

import SwiftUI

struct CBGradientWell: View {
    
    @ObservedObject public var value: CBGradient
        
    @State private var isPickerPresented = false
    
    @State var config = CBWellConfig()
    
    var body: some View {
        
        Button(action: { self.showPicker() }) {
            ZStack {
                RoundedRectangle(cornerRadius: config.corderRadius)
                   .fill(LinearGradient(
                        gradient: value.swiftUIGradient,
                        startPoint: .leading, endPoint: .trailing)
                    )
                RoundedRectangle(cornerRadius: config.corderRadius)
                   .stroke(Color.gray, lineWidth: 0.5)
            }
        }
        .popover(isPresented: $isPickerPresented) {
            CBGradientPicker(value: self.value)
        }
    }
    
    public func showPicker() {
        isPickerPresented = true
    }
}

#if DEBUG
struct CBGradientWell_Previews: PreviewProvider {
    
    @State static var gradient = CBGradient.rainbow
    
    @State static var config = CBWellConfig(bordered: true, corderRadius: 8)
    
    static var previews: some View {
        CBGradientWell(value: gradient, config: config)
            .frame(width: 125, height: 50, alignment: .center)
            .cornerRadius(8.0)
            .previewDevice("iPad Pro (11-inch)")
    }
}
#endif
