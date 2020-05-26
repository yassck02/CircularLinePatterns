//
//  CBColorWell.swift
//  ColorTools-Demo
//
//  Created by Connor yass on 4/3/20.
//  Copyright © 2020 Chinaberry Tech, LLC. All rights reserved.
//

import SwiftUI

/// A button used to display a colorpicker
struct CBColorWell: View {
    
    @Binding public var value: CBColor
    
    @State private var isPickerPresented = false
    
    @State var config = CBWellConfig()
    
    var body: some View {
        Button(action: { self.showPicker() }) {
            ZStack {
                 RoundedRectangle(cornerRadius: config.corderRadius)
                    .fill(value.swiftUIColor)
                 RoundedRectangle(cornerRadius: config.corderRadius)
                    .stroke(Color.gray, lineWidth: 0.5)
            }
        }
        .popover(isPresented: $isPickerPresented) {
            CBColorPicker(value: self.$value)
        }
    }
    
    public func showPicker() {
        isPickerPresented = true
    }
    
    public func hidePicker() {
        isPickerPresented = false
    }
}

#if DEBUG
struct CBColorWell_Previews: PreviewProvider {
    
    @State static var color: CBColor = .yellow
    
    @State static var config = CBWellConfig(bordered: true, corderRadius: 8)
    
    static var previews: some View {
        CBColorWell(value: $color, config: config)
            .frame(width: 100, height: 50, alignment: .center)
            .previewDevice("iPad Pro (11-inch)")
    }
}
#endif
