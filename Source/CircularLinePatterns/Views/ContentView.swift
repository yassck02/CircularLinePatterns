//
//  ViewController.swift
//  Life
//
//  Created by Connor yass on 5/18/20.
//  Copyright © 2020 Chinaberry Tech, LLC. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State var pattern: Pattern
    
    @ObservedObject var gradient: CBGradient
    
    @State var percent: Float = 1.0
    
    var body: some View {
        VStack {
            HStack {
                Button(action: { self.onPress_camera() }) {
                    Image(systemName: "camera")
                }
                Spacer()
                Button(action: { self.onPress_share() }) {
                    Image(systemName: "square.and.arrow.up")
                }
            }
            Spacer()
            PatternView(pattern: $pattern, gradient: gradient, percent: $percent)
                .aspectRatio(1.0, contentMode: .fit)
            Spacer()
            VStack(spacing: 15) {
                Slider(value: $percent)
                Stepper("Multiple: \(pattern.multiple)", value: Binding<Int>(get: {
                    return Int(self.pattern.multiple)
                }, set: { i in
                    self.pattern.multiple = uint(i)
                }) , in: 0...800)
                Stepper("Divisions: \(pattern.divisions)", value: Binding<Int>(get: {
                    return Int(self.pattern.divisions)
                }, set: { i in
                    self.pattern.divisions = uint(i)
                }) , in: 0...800)
                CBGradientWell(value: gradient).frame(height: 50)
            }
        }
        .padding()
        .accentColor(.gray)
    }
    
    func onPress_camera() {
        
    }
    
    func onPress_share() {
        
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        ContentView(pattern: TEST_PATRN, gradient: TEST_GRAD)
    }
}
#endif
