//
//  ColorTheme.swift
//  TimeCalculator
//
//  Created by Christian Grise on 4/11/25.
//

import SwiftUI

struct ColorTheme: Identifiable, Equatable, Codable {
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
    
    var id: String {
        name
    }
    
    // Built-in themes
    static let light = ColorTheme(
        name: "Light",
        backgroundColor: Color(.white),
        textColor: Color(.black),
        accentColor: Color(.systemGray),
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
        backgroundColor: Color(red: 0.12, green: 0.12, blue: 0.14),
        textColor: Color(.white),
        accentColor: .orange,
        numberButtonColor: Color(.systemGray),
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
    
    // Add more built-in themes as needed
    static let testTheme = ColorTheme(
        name: "Test",
        backgroundColor: Color(red: 0.12, green: 0.12, blue: 0.14),
        textColor: Color(.red),
        accentColor: .green,
        numberButtonColor: Color(.systemGray),
        numberTextColor: Color(.white),
        operationButtonColor: .green,
        operationTextColor: .white,
        functionButtonColor: Color(.systemGray3),
        functionTextColor: Color(.white),
        displayBackgroundColor: Color(.black),
        displayTextColor: Color(.white),
        resultTextColor: .green,
        isDarkTheme: true
    )
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
