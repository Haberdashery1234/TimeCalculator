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
            DatePicker(
                "Start Time",
                selection: $startTime,
                displayedComponents: [.hourAndMinute]
            )
            DatePicker(
                "End Time",
                selection: $endTime,
                displayedComponents: [.hourAndMinute]
            )
            Button("Add") {
                onAdd(TimeCardEntry(date: date, startTime: startTime, endTime: endTime))
                dismiss()
            }
        }
    }
}

#Preview {
    AddTimeCardEntryView() { _ in }
}
