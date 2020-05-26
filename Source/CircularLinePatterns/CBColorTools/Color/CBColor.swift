//
//  CBColor.swift
//  ColorTools-Demo
//
//  Created by Connor yass on 4/2/20.
//  Copyright © 2020 Chinaberry Tech, LLC. All rights reserved.
//

import SwiftUI

struct CBColor: Codable {
    
//    @Published var r: Float
//    @Published var g: Float
//    @Published var b: Float
//    @Published var a: Float
    
    var r: Float
    var g: Float
    var b: Float
    var a: Float
    
//    init(r: Float = 0, g: Float = 0, b: Float = 1, a: Float = 1) {
//        self.r = r
//        self.g = g
//        self.b = b
//        self.a = a
//    }
//
//    enum CodingKeys: CodingKey {
//        case r, g, b, a
//    }
//
//    required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        r = try container.decode(Float.self, forKey: .r)
//        g = try container.decode(Float.self, forKey: .g)
//        b = try container.decode(Float.self, forKey: .b)
//        a = try container.decode(Float.self, forKey: .a)
//    }
//
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(r, forKey: .r)
//        try container.encode(g, forKey: .g)
//        try container.encode(b, forKey: .b)
//        try container.encode(a, forKey: .a)
//    }
}

// MARK: -

extension CBColor: Equatable, Hashable {
    
    static func == (lhs: CBColor, rhs: CBColor) -> Bool {
        return (
            lhs.r == rhs.r &&
            lhs.g == rhs.g &&
            lhs.b == rhs.b &&
            lhs.a == rhs.a
        )
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(r)
        hasher.combine(g)
        hasher.combine(b)
        hasher.combine(a)
    }
}

// MARK: -

extension CBColor {
    
    static let white = CBColor(r: 1.00, g: 1.00, b: 1.00, a: 1.0)
    static let gray = CBColor(r: 0.50, g: 0.50, b: 0.50, a: 1.0)
    static let black = CBColor(r: 0.00, g: 0.00, b: 0.00, a: 1.0)
    
    static let red = CBColor(r: 0.96, g: 0.26, b: 0.26, a: 1.0)
    static let orange = CBColor(r: 0.96, g: 0.56, b: 0.26, a: 1.0)
    static let yellow = CBColor(r: 0.96, g: 0.80, b: 0.26, a: 1.0)
    static let lime = CBColor(r: 0.82, g: 0.96, b: 0.26, a: 1.0)
    static let green = CBColor(r: 0.47, g: 0.96, b: 0.26, a: 1.0)
    static let cyan = CBColor(r: 0.26, g: 0.96, b: 0.90, a: 1.0)
    static let blue = CBColor(r: 0.26, g: 0.52, b: 0.96, a: 1.0)
    static let purple = CBColor(r: 0.70, g: 0.26, b: 0.96, a: 1.0)
    static let pink = CBColor(r: 0.96, g: 0.26, b: 0.53, a: 1.0)
}

// MARK: -

extension CBColor {
    
    var swiftUIColor: Color {
        return Color(red: Double(r), green: Double(g), blue: Double(b), opacity: Double(a))
    }
    
    func withAlpha(_ alpha: Float) -> CBColor {
        return CBColor(r: r, g: g, b: b, a: alpha)
    }
}

// MARK: -

extension CBColor {
    
    var uiColor: UIColor {
        return UIColor(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: CGFloat(a))
    }
    
    init(uicolor: UIColor) {
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 0.0
        
        uicolor.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        self.init(r: Float(r), g: Float(g), b: Float(b), a: Float(a))
    }
}
