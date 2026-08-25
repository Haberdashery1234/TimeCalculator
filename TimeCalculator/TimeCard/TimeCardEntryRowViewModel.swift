//
//  TimeCardEntryRowViewModel.swift
//  TimeCalculator
//
//  Created by Christian Grise on 8/25/26.
//

import Foundation

@Observable
final class TimeCardEntryRowViewModel {
    var entry: TimeCardEntry
    
    var formattedEntryDate: String {
        entry.formattedEntryDate
    }
    
    var formattedStartTime: String {
        entry.formattedStartTime
    }
    
    var formattedEndTime: String {
        entry.formattedEndTime
    }
    
    init(entry: TimeCardEntry) {
        self.entry = entry
    }
}
