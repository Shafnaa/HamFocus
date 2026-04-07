# CLAUDE.md

This file provides guidance to Claude when working with code in this repository.

---

## Overview

**HamFocus** is an iOS productivity app that helps users stay focused and manage their tasks efficiently. It combines two proven techniques — **Pomodoro** (Deep Focus) and **Eisenhower Matrix** (Task Prioritization) — and simplifies them for general users with no prior knowledge of these methods.

The app has two main screens:
1. **Focus Screen** — Pomodoro-based focus timer
2. **Task List Screen** — Eisenhower Matrix-based task prioritization

---

## Tech Stack

| Layer | Technology |
|---|---|
| Language | Swift |
| UI Framework | SwiftUI |
| Minimum iOS | iOS 26 |
| Architecture | MVVM |
| Persistence | SwiftData |
| Libraries | Native only — no third-party packages |
| Fonts | SF Pro (system font) only |

---

## Project Structure

```
HamFocus/
├── Models/
│   └── Task.swift               # SwiftData model
├── Views/
│   ├── FocusView.swift          # Main Pomodoro screen
│   ├── TaskListView.swift       # Main Eisenhower task list screen
│   ├── DeepFocusModalView.swift # Fullscreen modal during active focus session
│   └── Components/              # Reusable view components
├── ViewModels/
│   ├── FocusViewModel.swift     # Timer logic & state management
│   └── TaskViewModel.swift      # Task CRUD & Eisenhower logic
├── Utils/
│   └── EisenhowerHelper.swift   # Priority classification logic
└── Assets.xcassets/             # App icons, colors, images
```

**Rules:**
- All model definitions go in `Models/`
- All SwiftUI views go in `Views/` — subcomponents in `Views/Components/`
- All business logic and state go in `ViewModels/`
- Helper functions and utilities go in `Utils/`
- Never mix business logic into Views

---

## Data Model

```swift
@Model
class Task {
    var id: UUID
    var name: String
    var description: String
    var deadline: Date
    var duration: TimeInterval    // In minutes
    var importance: Bool          // true = Important, false = Not Important
    var isDone: Bool
    var createdAt: Date

    // Computed — do not store
    var eisenhowerQuadrant: EisenhowerQuadrant {
        // Logic based on deadline urgency + importance
    }
}

enum EisenhowerQuadrant {
    case doFirst      // Urgent + Important
    case schedule     // Not Urgent + Important
    case delegate     // Urgent + Not Important
    case eliminate    // Not Urgent + Not Important
}
```

**Rules:**
- `eisenhowerQuadrant` is always **computed**, never stored
- Urgency is derived from `deadline` proximity (not a stored field)
- `duration` is used to estimate Pomodoro sessions needed

---

## Feature Specifications

### 1. Task List Screen (Eisenhower Matrix)

- Display all tasks, grouped by Eisenhower quadrant
- Each task shows: name, deadline, quadrant badge, done status
- User can add a task by inputting: `name`, `description`, `deadline`, `duration`, `importance`
- App **automatically assigns** the Eisenhower quadrant — user does not pick manually
- User can mark task as `isDone`
- Tasks that are `isDone` are visually separated or muted
- No manual quadrant override by user

### 2. Focus Screen (Pomodoro)

- Default session: **25 minutes focus / 5 minutes break**
- States: Idle → Running → Break → Done
- User can start, pause, and reset the timer
- Shows current task being focused on (optional: user selects from task list)
- Tracks number of completed Pomodoro sessions

### 3. Deep Focus Modal

- Triggered when user starts a focus session
- Presented as a **fullscreen modal** overlaid on top of the app
- Shows: countdown timer, current task name, session count
- Minimal UI — no distractions
- User can end/pause session from within the modal
- Modal dismisses automatically when session ends

---

## Navigation Flow

```
App Launch
    ├── Tab 1: Task List Screen (TaskListView)
    │       └── Add Task Sheet (form input)
    └── Tab 2: Focus Screen (FocusView)
                └── [Start Focus] → DeepFocusModalView (fullscreen modal)
```

- Use `TabView` for top-level navigation between Task List and Focus
- Use `.sheet` for Add Task form
- Use `.fullScreenCover` for Deep Focus Modal

---

## Design System

Follow **Apple Human Interface Guidelines (HIG)** strictly.

### Typography
- Use **SF Pro** exclusively (system font) — no custom fonts
- Use SwiftUI semantic styles: `.largeTitle`, `.title`, `.title2`, `.headline`, `.body`, `.caption`
- Never hardcode font sizes — always use semantic styles or `Font.system(.body)`

### Colors
- Use **semantic system colors** from SwiftUI: `.primary`, `.secondary`, `Color(.systemBackground)`, `Color(.label)`, etc.
- Support **Dark Mode** automatically by using system colors only
- For accent/brand color, use `Color.accentColor` (configurable in Assets)
- No hardcoded hex colors

### Spacing & Layout
- Follow HIG spacing: use multiples of 4pt or 8pt
- Use `padding()` with standard values — avoid magic numbers
- Use `VStack`, `HStack`, `LazyVStack` appropriately
- Use `List` for task lists — do not reinvent with `ScrollView + ForEach` unless necessary

### Components
- Use native SwiftUI components where possible: `Button`, `Toggle`, `DatePicker`, `Picker`
- For Pomodoro timer display, use `Text` with `.monospacedDigit()` modifier
- Quadrant badges should use `Label` with SF Symbols

### SF Symbols
- Use SF Symbols for all icons — no custom icon assets unless provided in `Assets.xcassets`
- Match symbol weight to surrounding text weight

---

## Architecture Rules (MVVM)

- **View** — Only layout and presentation. No logic. No direct SwiftData queries.
- **ViewModel** — All state, business logic, computed properties. Marked `@Observable`.
- **Model** — SwiftData `@Model` only. No UI logic, no formatting.
- **Utils** — Pure functions, extensions, helpers. No state.

```swift
// ✅ Correct
@Observable
class TaskViewModel {
    var tasks: [Task] = []

    func addTask(...) { ... }
    func toggleDone(_ task: Task) { ... }
}

// ❌ Wrong — logic inside View
struct TaskListView: View {
    var body: some View {
        Button("Done") {
            task.isDone.toggle() // Don't do this directly in View
        }
    }
}
```

---

## Rules & Constraints

- ✅ Native Swift & SwiftUI only — no third-party libraries or Swift packages
- ✅ SwiftData for all persistence — no CoreData, no UserDefaults for model data
- ✅ MVVM strictly — no logic in Views
- ✅ SF Pro fonts only — use semantic text styles
- ✅ System semantic colors only — full Dark Mode support required
- ✅ Follow Apple HIG for all UI decisions
- ❌ No hardcoded hex colors
- ❌ No hardcoded font sizes
- ❌ Do not store `eisenhowerQuadrant` — always compute it
- ❌ Do not let users manually pick their Eisenhower quadrant
- ❌ Do not add new dependencies without explicit instruction
- ❌ Do not create new files outside the defined project structure

---

## Notes for Claude

- When generating SwiftUI views, always use `@Environment(\.modelContext)` for SwiftData access inside Views, and pass context to ViewModel as needed.
- Use `@Query` in Views only for reading data; mutations go through ViewModel.
- For the Pomodoro timer, use `Timer.publish` combined with `.onReceive` — not `asyncAfter`.
- Deep Focus Modal should use `.fullScreenCover` modifier, not `.sheet`.
- When in doubt about UI patterns, default to what Apple's own apps do (Clock, Reminders, Calendar).

