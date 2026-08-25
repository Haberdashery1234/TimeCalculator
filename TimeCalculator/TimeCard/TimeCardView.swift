//
//  TimeCardView.swift
//  TimeCalculator
//
//  Created by Christian Grise on 4/10/25.
//

import SwiftUI
import SwiftData

struct TimeCardView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \TimeCardEntry.startDate, order: .reverse) private var entries: [TimeCardEntry]
    @State var isShowingAddEntryView = false
    
    private var totalTime: TimeInterval {
        entries.reduce(0) { $0 + $1.endDate.timeIntervalSince($1.startDate) }
    }
    
    private var formattedTotalTime: String {
        let hours = Int(totalTime) / 3600
        let minutes = (Int(totalTime) % 3600) / 60
        return String(format: "%d:%02d", hours, minutes)
    }
    
    var body: some View {
        VStack {
            List {
                ForEach(entries) { entry in
                    TimeCardEntryRowView(entry: entry)
                    .padding(.vertical, 4)
                }
                .onDelete(perform: deleteEntries)
            }
            .navigationTitle("Time Card")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { isShowingAddEntryView = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isShowingAddEntryView) {
                NavigationStack {
                    AddTimeCardEntryView() { newEntry in
                        modelContext.insert(newEntry)
                    }
                }
            }
            .safeAreaInset(edge: .bottom) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Total Hours")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text(formattedTotalTime)
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Decimal")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text(String(format: "%.2f hrs", totalTime / 3600))
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding()
                .background(.ultraThinMaterial)
            }
            .overlay {
                if entries.isEmpty {
                    ContentUnavailableView(
                        "No Time Entries",
                        systemImage: "clock.badge.questionmark",
                        description: Text("Tap the + button to add your first time entry")
                    )
                }
            }
        }
    }
    
    private func deleteEntries(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(entries[index])
        }
    }
}

#Preview {
    NavigationStack {
        TimeCardView()
    }
}
