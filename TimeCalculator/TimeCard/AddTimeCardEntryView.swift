//
//  AddTimeCardEntryView.swift
//  TimeCalculator
//
//  Created by Christian Grise on 4/10/25.
//

import SwiftUI

struct AddTimeCardEntryView: View {
    @Environment(\.dismiss) var dismiss
    
    @State var date: Date = Date()
    @State var startTime: Date = Date()
    @State var endTime: Date = Date()
    
    var onAdd: (TimeCardEntry) -> Void
    
    private var isUITesting: Bool {
        ProcessInfo.processInfo.arguments.contains("isRunningUITests")
    }
    
    init(onAdd: @escaping (TimeCardEntry) -> Void) {
        self.onAdd = onAdd
    }
    
    var body: some View {
        Form {
            DatePicker(
                "Date",
                selection: $date,
                displayedComponents: [.date]
            )
            .accessibilityLabel("Date Date Picker")
            .accessibilityIdentifier("DateDatePicker")
            
            DatePicker(
                "Start Time",
                selection: $startTime,
                displayedComponents: [.hourAndMinute]
            )
            .accessibilityLabel("Start Time Date Picker")
            .accessibilityIdentifier("StartTimeDatePicker")
            
            DatePicker(
                "End Time",
                selection: $endTime,
                displayedComponents: [.hourAndMinute]
            )
            .accessibilityLabel("End Time Date Picker")
            .accessibilityIdentifier("EndTimeDatePicker")
            
            Button("Add") {
                onAdd(TimeCardEntry(date: date, startTime: startTime, endTime: endTime))
                dismiss()
            }
            .accessibilityLabel("Add")
            .accessibilityIdentifier("AddButton")
            
            if isUITesting {
                
                Button("Set to Valid Time") {
                    let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
                    let noon = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: tomorrow)!
                    date = tomorrow
                    startTime = noon
                    endTime = noon.addingTimeInterval(3600)
                }
                .accessibilityIdentifier("setValidDateButton")
                
                Button("Set to Invalid Time") {
                    let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
                    let evening = Calendar.current.date(bySettingHour: 20, minute: 0, second: 0, of: tomorrow)!
                    date = tomorrow
                    startTime = evening
                    endTime = evening.addingTimeInterval(-3600)
                }
                .accessibilityIdentifier("setInvalidDateButton")
            }
        }
    }
}

#Preview {
    AddTimeCardEntryView() { _ in }
}
