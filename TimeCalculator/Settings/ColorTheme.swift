//
//  ColorTheme.swift
//  TimeCalculator
//
//  Created by Christian Grise on 4/11/25.
//

import SwiftUI

struct ColorTheme: Identifiable, Equatable, Codable {
    var id = UUID()
    var name: String
    
    // Primary colors
    var backgroundColor: Color
    var textColor: Color
    var accentColor: Color
    
    // Button colors
    var numberButtonColor: Color
    var numberTextColor: Color
    var operationButtonColor: Color
    var operationTextColor: Color
    var functionButtonColor: Color
    var functionTextColor: Color
    
    // Display colors
    var displayBackgroundColor: Color
    var displayTextColor: Color
    var resultTextColor: Color
    
    // Optional additional properties
    var isDarkTheme: Bool
    var buttonCornerRadius: CGFloat = 12
    var fontName: String = "System"
    
    // Built-in themes
    static let light = ColorTheme(
        name: "Light",
        backgroundColor: Color(.systemGray),
        textColor: Color(.white),
        accentColor: .orange,
        numberButtonColor: Color(.systemGray5),
        numberTextColor: Color(.label),
        operationButtonColor: .orange,
        operationTextColor: .white,
        functionButtonColor: Color(.systemGray3),
        functionTextColor: Color(.label),
        displayBackgroundColor: Color(.systemBackground),
        displayTextColor: Color(.label),
        resultTextColor: .orange,
        isDarkTheme: false
    )
    
    static let dark = ColorTheme(
        name: "Dark",
        backgroundColor: Color(.systemBackground),
        textColor: Color(.label),
        accentColor: .orange,
        numberButtonColor: Color(.systemGray5),
        numberTextColor: Color(.white),
        operationButtonColor: .orange,
        operationTextColor: .white,
        functionButtonColor: Color(.systemGray3),
        functionTextColor: Color(.white),
        displayBackgroundColor: Color(.black),
        displayTextColor: Color(.white),
        resultTextColor: .orange,
        isDarkTheme: true
    )
    
    static let blue = ColorTheme(
        name: "Blue",
        backgroundColor: Color(red: 0.05, green: 0.1, blue: 0.2),
        textColor: .white,
        accentColor: Color(red: 0.4, green: 0.7, blue: 1.0),
        numberButtonColor: Color(red: 0.15, green: 0.2, blue: 0.3),
        numberTextColor: .white,
        operationButtonColor: Color(red: 0.4, green: 0.7, blue: 1.0),
        operationTextColor: .white,
        functionButtonColor: Color(red: 0.2, green: 0.3, blue: 0.4),
        functionTextColor: .white,
        displayBackgroundColor: Color(red: 0.1, green: 0.15, blue: 0.25),
        displayTextColor: .white,
        resultTextColor: Color(red: 0.4, green: 0.7, blue: 1.0),
        isDarkTheme: true
    )
    
    // Add more built-in themes as needed
}

// Extension to make Color codable (needed for UserDefaults or other storage)
extension Color: Codable {
    enum CodingKeys: String, CodingKey {
        case red, green, blue, opacity
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let r = try container.decode(Double.self, forKey: .red)
        let g = try container.decode(Double.self, forKey: .green)
        let b = try container.decode(Double.self, forKey: .blue)
        let o = try container.decode(Double.self, forKey: .opacity)
        
        self.init(red: r, green: g, blue: b, opacity: o)
    }
    
    public func encode(to encoder: Encoder) throws {
        let components = self.components()
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(components.red, forKey: .red)
        try container.encode(components.green, forKey: .green)
        try container.encode(components.blue, forKey: .blue)
        try container.encode(components.opacity, forKey: .opacity)
    }
    
    private func components() -> (red: Double, green: Double, blue: Double, opacity: Double) {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var o: CGFloat = 0
        
        #if canImport(UIKit)
        UIColor(self).getRed(&r, green: &g, blue: &b, alpha: &o)
        #else
        NSColor(self).getRed(&r, green: &g, blue: &b, alpha: &o)
        #endif
        
        return (red: Double(r), green: Double(g), blue: Double(b), opacity: Double(o))
    }
}
