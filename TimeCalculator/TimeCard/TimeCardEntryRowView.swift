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
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(viewModel.formattedEntryDate)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Spacer()
                Text("\(String(format: "%.2f", entry.hours)) hrs")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
            }
            
            HStack(spacing: 16) {
                HStack(spacing: 6) {
                    Image(systemName: "clock.fill")
                        .foregroundStyle(.green)
                        .font(.caption)
                    Text(viewModel.formattedStartTime)
                        .font(.body)
                }
                
                Image(systemName: "arrow.right")
                    .foregroundStyle(.secondary)
                    .font(.caption)
                
                HStack(spacing: 6) {
                    Image(systemName: "clock.fill")
                        .foregroundStyle(.red)
                        .font(.caption)
                    Text(viewModel.formattedEndTime)
                        .font(.body)
                }
            }
            
            // Show if it's an overnight shift
            if !Calendar.current.isDate(entry.startDate, inSameDayAs: entry.endDate) {
                Label("Overnight shift", systemImage: "moon.stars.fill")
                    .font(.caption)
                    .foregroundStyle(.blue)
                    .padding(.top, 2)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    let exampleEntry = TimeCardEntry.example
    TimeCardEntryRowView(entry: exampleEntry)
}
