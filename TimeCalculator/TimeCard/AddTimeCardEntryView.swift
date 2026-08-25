//
//  AddTimeCardEntryView.swift
//  TimeCalculator
//
//  Created by Christian Grise on 4/10/25.
//

import SwiftUI

struct AddTimeCardEntryView: View {
    @Environment(\.dismiss) var dismiss
    @State private var viewModel = AddTimeCardEntryViewModel()
    
    var onAdd: (TimeCardEntry) -> Void
    
    init(onAdd: @escaping (TimeCardEntry) -> Void) {
        self.onAdd = onAdd
    }
    
    var body: some View {
        Form {
            Section("Start") {
                DatePicker(
                    "Date & Time",
                    selection: $viewModel.startDate,
                    displayedComponents: [.date, .hourAndMinute]
                )
                .onChange(of: viewModel.startDate) { oldValue, newValue in
                    // Only update if the date actually changed
                    if !Calendar.current.isDate(oldValue, inSameDayAs: newValue) {
                        viewModel.handleStartDateChange()
                    }
                }
            }
            
            Section("End") {
                Toggle("Overnight Shift", isOn: $viewModel.isOvernightShift)
                    .onChange(of: viewModel.isOvernightShift) { _, newValue in
                        viewModel.handleOvernightToggle(newValue)
                    }
                
                DatePicker(
                    "Date & Time",
                    selection: $viewModel.endDate,
                    displayedComponents: [.date, .hourAndMinute]
                )
            }
            
            Section {
                HStack {
                    Text("Duration")
                    Spacer()
                    Text(viewModel.formattedDuration)
                        .foregroundStyle(viewModel.isValid ? Color.secondary : Color.red)
                }
            }
            
            Button("Add Entry") {
                onAdd(viewModel.createEntry())
                dismiss()
            }
            .disabled(!viewModel.isValid)
        }
        .navigationTitle("Add Time Entry")
    }
}

#Preview {
    NavigationStack {
        AddTimeCardEntryView() { _ in }
    }
}


