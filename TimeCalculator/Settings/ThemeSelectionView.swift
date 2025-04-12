//
//  ThemeSelectionView.swift
//  TimeCalculator
//
//  Created by Christian Grise on 4/11/25.
//

import SwiftUI

struct ThemeSelectionView: View {
    @Environment(ThemeManager.self) var themeManager
    @Environment(\.dismiss) var dismiss
    
    let columns = [
        GridItem(),
        GridItem()
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(themeManager.availableThemes) { theme in
                    Button {
                        themeManager.setTheme(theme)
                        dismiss()
                    } label: {
                        CalculatorView(theme: theme, scale: 0.3)
                            .padding()
                            .allowsHitTesting(false)
                    }
                }
            }
        }
    }
}

#Preview {
    ThemeSelectionView()
        .environment(ThemeManager())
}
