//
//  CBGradient.swift
//  ColorTools-Demo
//
//  Created by Connor yass on 4/2/20.
//  Copyright © 2020 Chinaberry Tech, LLC. All rights reserved.
//

import SwiftUI

class CBGradient: ObservableObject, Codable {
    
    struct Key: Codable {
        var color: CBColor
        var location: Float
    }
    
    // MARK: Variables
    
    /// The sorted array of `Keys`
    var keys: [Key]
    
    // MARK: Lifecycle
    
    init(keys: [Key]) {
        self.keys = keys.sorted(by: {$0.location < $1.location})
    }
    
    // MARK: Functions
    
    /// Adds a new key with the given color and location
    public func insert(color: CBColor, at location: Float) {
        objectWillChange.send()
        
        let newKey = Key(color: color, location: location)
        
        for (i, key) in keys.enumerated() {
            if (key.location > location) {
                keys.insert(newKey, at: i)
            }
        }
        keys.append(newKey)
    }
    
    /// Removes the key at the given index
    public func removeKeyframe(at index: Int) {
        objectWillChange.send()
        keys.remove(at: index)
    }
    
    /// Returns the color at the given location in this gradient
    public func sample(at location: CGFloat) -> CBColor {
        return .white
    }
}

extension CBGradient {
    
    /// Returns this CBGradient as a SwuitUI gradient
    var swiftUIGradient: Gradient {
        let stops = keys.map { (key) -> Gradient.Stop in
            return Gradient.Stop(color: key.color.swiftUIColor, location: CGFloat(key.location))
        }
        return Gradient(stops: stops)
    }
}

extension CBGradient {
    
    /// ROYGBIV
    static let rainbow: CBGradient = CBGradient(keys: [
        CBGradient.Key(color: .red,    location: 0.0),
        CBGradient.Key(color: .orange, location: 0.3),
        CBGradient.Key(color: .yellow, location: 0.4),
        CBGradient.Key(color: .green,  location: 0.6),
        CBGradient.Key(color: .blue,   location: 0.8),
        CBGradient.Key(color: .purple, location: 1.0)
    ])
    
    /// Red, White, and Blue
    static let RWB: CBGradient = CBGradient(keys: [
        CBGradient.Key(color: .red,   location: 0.00),
        CBGradient.Key(color: .white, location: 0.50),
        CBGradient.Key(color: .blue,  location: 1.00)
    ])
    
    /// The first half of the rainbow
    static let sunrise: CBGradient = CBGradient(keys: [
        CBGradient.Key(color: .red,    location: 0.00),
        CBGradient.Key(color: .orange, location: 0.50),
        CBGradient.Key(color: .yellow, location: 1.00)
    ])
    
    /// The second half of the rainbow
    static let sunset: CBGradient = CBGradient(keys: [
        CBGradient.Key(color: .green,  location: 0.00),
        CBGradient.Key(color: .blue,   location: 0.50),
        CBGradient.Key(color: .purple, location: 1.00)
    ])
}
