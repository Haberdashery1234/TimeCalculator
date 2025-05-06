//
//  ThemeEditorView.swift
//  TimeCalculator
//
//  Created by Christian Grise on 4/11/25.
//

import SwiftUI

struct ThemeEditorView: View {
    @Environment(ThemeManager.self) var themeManager
    @Environment(\.presentationMode) var presentationMode
    
    // Edit a copy of a theme or create a new one
    @State private var editingTheme: ColorTheme
    @State private var themeName: String
    
    // For color pickers
    @State private var showingBackgroundPicker = false
    @State private var showingTextPicker = false
    @State private var showingAccentPicker = false
    @State private var showingNumberButtonPicker = false
    @State private var showingNumberTextPicker = false
    @State private var showingOperationButtonPicker = false
    @State private var showingOperationTextPicker = false
    @State private var showingFunctionButtonPicker = false
    @State private var showingFunctionTextPicker = false
    @State private var showingDisplayBackgroundPicker = false
    @State private var showingDisplayTextPicker = false
    @State private var showingResultTextPicker = false
    
    init(theme: ColorTheme? = nil) {
        // If editing existing theme, use it; otherwise create a new one
        let initialTheme = theme ?? ColorTheme(
            name: "New Theme",
            backgroundColor: .black,
            textColor: .black,
            accentColor: .orange,
            numberButtonColor: Color(.systemGray5),
            numberTextColor: .white,
            operationButtonColor: .orange,
            operationTextColor: .white,
            functionButtonColor: Color(.systemGray3),
            functionTextColor: .white,
            displayBackgroundColor: .black,
            displayTextColor: .white,
            resultTextColor: .orange,
            isDarkTheme: true
        )
        
        _editingTheme = State(initialValue: initialTheme)
        _themeName = State(initialValue: initialTheme.name)
    }
    
    var body: some View {
        VStack {
            Section(header: Text("Theme Info")) {
                TextField("Theme Name", text: $themeName)
                    .onChange(of: themeName) { oldValue, newValue in
                        editingTheme.name = newValue
                    }
                
                Toggle("Dark Theme", isOn: $editingTheme.isDarkTheme)
            }
            .padding([.leading, .trailing])
            
            Section {
                CalculatorPreviewView(scale: 0.5)
                    .frame(height: 400)
                    .padding(.vertical, 5)
            }
        }
        
        Form {
            Section(header: Text("Main Colors")) {
                ColorPickerRow(title: "Background Color", color: $editingTheme.backgroundColor)
                ColorPickerRow(title: "Text Color", color: $editingTheme.textColor)
                ColorPickerRow(title: "Accent Color", color: $editingTheme.accentColor)
            }
            
            Section(header: Text("Button Colors")) {
                ColorPickerRow(title: "Number Button", color: $editingTheme.numberButtonColor)
                ColorPickerRow(title: "Number Text", color: $editingTheme.numberTextColor)
                ColorPickerRow(title: "Operation Button", color: $editingTheme.operationButtonColor)
                ColorPickerRow(title: "Operation Text", color: $editingTheme.operationTextColor)
                ColorPickerRow(title: "Function Button", color: $editingTheme.functionButtonColor)
                ColorPickerRow(title: "Function Text", color: $editingTheme.functionTextColor)
            }
            
            Section(header: Text("Display Colors")) {
                ColorPickerRow(title: "Display Background", color: $editingTheme.displayBackgroundColor)
                ColorPickerRow(title: "Display Text", color: $editingTheme.displayTextColor)
                ColorPickerRow(title: "Result Text", color: $editingTheme.resultTextColor)
            }
            
            Section(header: Text("Style")) {
                Stepper("Button Corner Radius: \(Int(editingTheme.buttonCornerRadius))", value: $editingTheme.buttonCornerRadius, in: 0...24, step: 2)
            }
        }
        .navigationTitle("Edit Theme")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    saveTheme()
                }
            }
        }
        .background(editingTheme.backgroundColor.edgesIgnoringSafeArea(.all))
        .foregroundColor(editingTheme.textColor)
    }
    
    private func saveTheme() {
        // Check if editing an existing theme
        if let index = themeManager.availableThemes.firstIndex(where: { $0.id == editingTheme.id }) {
            themeManager.updateTheme(editingTheme)
        } else {
            // This is a new theme
            themeManager.addTheme(editingTheme)
        }
        
        presentationMode.wrappedValue.dismiss()
    }
}

struct ColorPickerRow: View {
    var title: String
    @Binding var color: Color
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            ZStack {
                RoundedRectangle(cornerRadius: 4)
                    .strokeBorder(Color.gray.opacity(0.3), lineWidth: 1)
                    .background(RoundedRectangle(cornerRadius: 4).fill(color))
                    .frame(width: 30, height: 30)
            }
            ColorPicker("", selection: $color)
                .labelsHidden()
        }
    }
}

#Preview {
    ThemeEditorView()
        .environment(ThemeManager())
}
