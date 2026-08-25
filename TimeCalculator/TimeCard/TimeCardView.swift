//
//  TimeCardView.swift
//  TimeCalculator
//
//  Created by Christian Grise on 4/10/25.
//

import SwiftUI

struct TimeCardView: View {
    @State var viewModel = TimeCardViewModel()
    @State var isShowingAddEntryView = false
    
    var body: some View {
        VStack {
            Text("Total Hours: \(String(format: "%.2f", viewModel.totalTime / 3600))")
                .font(.headline)
                .padding()
            
            List {
                ForEach(viewModel.entries) { entry in
                    TimeCardEntryRowView(entry: entry)
                    .padding(.vertical, 4)
                }
                .onDelete { indexSet in
                    viewModel.entries.remove(atOffsets: indexSet)
                }
            }
            .navigationTitle("Time Card")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { isShowingAddEntryView = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isShowingAddEntryView) {
                NavigationStack {
                    AddTimeCardEntryView() { newEntry in
                        viewModel.entries.append(newEntry)
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        TimeCardView()
    }
}
