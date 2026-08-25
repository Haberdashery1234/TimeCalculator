//
//  TimeCardEntryRow.swift
//  TimeCalculator
//
//  Created by Christian Grise on 8/25/26.
//

import SwiftUI

struct TimeCardEntryRowView: View {
    var entry: TimeCardEntry
    var viewModel: TimeCardEntryRowViewModel
    
    init(entry: TimeCardEntry) {
        self.entry = entry
        self.viewModel = TimeCardEntryRowViewModel(entry: entry)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(viewModel.formattedEntryDate)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Spacer()
                Text("\(String(format: "%.2f", entry.hours)) hrs")
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
            
            HStack {
                Label {
                    Text(viewModel.formattedStartTime)
                } icon: {
                    Image(systemName: "clock")
                        .foregroundStyle(.green)
                }
                
                Image(systemName: "arrow.right")
                    .foregroundStyle(.secondary)
                    .font(.caption)
                
                Label {
                    Text(viewModel.formattedEndTime)
                } icon: {
                    Image(systemName: "clock")
                        .foregroundStyle(.red)
                }
            }
            .font(.body)
            
            // Show if it's an overnight shift
            if !Calendar.current.isDate(entry.startDate, inSameDayAs: entry.endDate) {
                Label("Overnight shift", systemImage: "moon.stars.fill")
                    .font(.caption)
                    .foregroundStyle(.blue)
            }
        }
    }
}

#Preview {
    let exampleEntry = TimeCardEntry.example
    TimeCardEntryRowView(entry: exampleEntry)
}
