//
//  ViewController.swift
//  Life
//
//  Created by Connor yass on 5/18/20.
//  Copyright © 2020 Chinaberry Tech, LLC. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        HStack {
            PatternView(Pattern: <#T##Pattern#>,
                        gradient: <#T##CBGradient#>,
                        parameters: <#T##<<error type>>#>)
        }
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        ContentView()
    }
}
#endif
