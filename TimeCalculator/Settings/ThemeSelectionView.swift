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
                        VStack {
                            Text(theme.name)
                            CalculatorView(theme: theme, scale: 0.3)
                                .allowsHitTesting(false)
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 1)
                        )
                    }
                    .padding()
                }
            }
        }
    }
}

#Preview {
    ThemeSelectionView()
        .environment(ThemeManager())
}
