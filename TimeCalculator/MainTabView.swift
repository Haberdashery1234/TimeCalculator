//
//  TabView.swift
//  TimeCalculator
//
//  Created by Christian Grise on 4/10/25.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        NavigationStack {
            TabView {
                CalculatorView()
                    .tabItem {
                        Image(systemName: "plusminus")
                        Text("Calculator")
                    }
                TimeCardView()
                    .tabItem {
                        Image(systemName: "tablecells")
                        Text("Time Card")
                    }
            }
        }
    }
}

#Preview {
    MainTabView()
}
