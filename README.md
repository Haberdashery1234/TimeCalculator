# TimeCalculator

A small SwiftUI utility app for working with time. It has two tabs:

- **Calculator** — a custom keypad for adding and subtracting durations
  (`HH:MM`) directly, instead of doing the math by hand.
- **Time Card** — log shift entries (date, start time, end time) and see
  total hours worked across all entries.

## Features

- **Duration calculator** — enter times digit-by-digit on a dedicated
  keypad (`ButtonsView`), add/subtract them, and see a running
  calculation plus result, similar to a standard calculator app but
  operating on `HH:MM` durations instead of plain numbers.
- **Time card log** — add entries with a date, start time, and end time;
  each entry's hours are computed automatically
  (`endTime.timeIntervalSince(startTime)`), and a total across all
  entries is kept running.

## Tech stack

- SwiftUI
- `@Observable` view model (`TimeCardView_ViewModel.swift`) for the Time
  Card tab

## Project structure

```
TimeCalculator/
  MainTabView.swift        Tab container (Calculator, Time Card)
  Calculator/
    CalculatorView.swift     Display + calculation state
    ButtonsView.swift        Keypad UI
  TimeCard/
    TimeCardView.swift       Entry list + total
    TimeCardView_ViewModel.swift   TimeCardEntry model + totals
    AddTimeCardEntryView.swift     Add-entry form
```

## Getting started

1. Open `TimeCalculator.xcodeproj` in Xcode.
2. Build and run on the Simulator or a device.

## Status

Small, self-contained utility app — both tabs (Calculator, Time Card) are
functional.

## Screenshots

_Coming soon._
