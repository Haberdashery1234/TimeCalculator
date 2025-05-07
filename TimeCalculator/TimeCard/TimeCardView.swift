//
//  TimeCardView.swift
//  TimeCalculator
//
//  Created by Christian Grise on 4/10/25.
//

import SwiftUI

struct TimeCardView: View {
    @State var viewModel = ViewModel()
    @State var isShowingAddEntryView = false
    
    var body: some View {
        VStack {
            Text("Total Hours: \(String(format: "%.2f", viewModel.totalTime / 3600))")
                .accessibilityLabel("Total hours worked")
                .accessibilityIdentifier("Total hours label")
            List(viewModel.entries) { entry in
                HStack {
                    Text(DateFormatter.localizedString(from: entry.date, dateStyle: .medium, timeStyle: .none))
                    Spacer()
                    Text(DateFormatter.localizedString(from: entry.startTime, dateStyle: .none, timeStyle: .short) + "-" + DateFormatter.localizedString(from: entry.endTime, dateStyle: .none, timeStyle: .short))
                }
            }
            .padding()
            .navigationTitle("Time Card")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { isShowingAddEntryView = true }) {
                        Image(systemName: "plus")
                    }
                    .accessibilityLabel("Add new time entry")
                    .accessibilityIdentifier("AddEntryButton")
                }
            }
            .sheet(isPresented: $isShowingAddEntryView) {
                AddTimeCardEntryView() { newEntry in
                    viewModel.entries.append(newEntry)
                }
            }
        }
    }
}

#Preview {
    TimeCardView()
}
