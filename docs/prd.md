# Product Requirements Document: Thought Capture

## Overview

**Product Name:** Thought Capture (working title)
**Platform:** iOS (primary), macOS (future)
**Target Users:** Students and working professionals who need to capture thoughts fast, without friction
**Version:** V1

## Problem Statement

The gap between having a thought and recording it is too wide. Existing note apps are designed for *writing*, not *capturing*. Users default to texting themselves, taking screenshots, or dropping thoughts in Slack DMs because note apps require too many steps: unlock → find app → open → pick folder → type.

Thought Capture eliminates every barrier between having a thought and saving it.

## Core Principles

1. **Zero friction** — Capture must be instant. One action to start writing. No titles, no folders, no decisions.
2. **Stream of consciousness** — Notes are raw, messy thoughts — not polished documents. The app embraces that.
3. **No organization burden** — Users don't organize. The app provides search and starring — that's it. No folders, no tags, no categories.
4. **Threads, not documents** — Notes live as threads that grow over time, like text messages to yourself.

## Target Users

| Segment | Use Case |
|---|---|
| **Students** | Capture ideas during lectures, study sessions, research. Quick thoughts between classes. |
| **Working Professionals** | Meeting thoughts, project ideas, fleeting insights during commutes or conversations. |

## V1 Feature Requirements

### 1. Thread-Based Notes

- Each new capture creates a **new thread**
- Users can **append to an existing thread** (like replying to a message)
- Threads display entries in **chronological order** with timestamps
- Main view shows a list of **all threads**, sorted by most recently updated
- No titles required — threads are identified by their first line / preview text

### 2. Instant Capture

- App opens directly to capture input — no splash screens, no navigation
- **< 1 second** from app launch to first keystroke
- Home screen widget for instant capture
- Lock screen / notification quick capture (iOS Live Activities or similar)
- "New thread" and "Append to last thread" as distinct quick actions

### 3. Multi-Format Capture

Each thread supports a mix of formats as individual entries:

| Format | Behavior |
|---|---|
| **Text** | Default input. Plain text, no rich formatting in V1. |
| **Voice** | Record audio → transcribe to text. **Keep original audio** alongside transcription. User can play back audio from the thread. |
| **Photos** | Select **multiple photos** at once. Displayed in a **gallery view** within the thread entry. |

### 4. Search

- Full-text search across all threads and entries
- Search results highlight matching text and link to the source thread
- Search includes voice transcriptions
- Recent searches preserved

### 5. Starring

- Users can **star/unstar threads**
- Starred threads accessible via a dedicated filter/view
- Star indicator visible in the thread list

### 6. Thread Management

- Delete threads
- Delete individual entries within a thread
- Edit text entries

## Out of Scope (V1)

| Feature | Reason |
|---|---|
| AI auto-organization / tagging | Not in this phase |
| AI summarization | Not in this phase |
| Smart / semantic search | Not in this phase |
| iCloud sync | Later phase |
| macOS app | Later phase |
| Collaboration / sharing | Later phase |
| Monetization / pricing tiers | Later phase |
| Folders, tags, categories | Against core philosophy — users don't organize |
| Rich text formatting | Keep it simple — plain text only in V1 |
| Note templates | Not in this phase |
| Export | Not in this phase |

## User Flow

```
App Launch
  → Thread List (main view, sorted by recent)
  → [+ New] → Capture Screen → type / record voice / attach photos → Submit → New Thread created
  → [Tap existing thread] → Thread View (chronological entries) → [+ Append] → add new entry
  → [Search icon] → Search across all threads
  → [Star filter] → View starred threads only
```

## Tech Stack

| Layer | Choice | Why |
|---|---|---|
| **Framework** | SwiftUI | Native iOS feel, same codebase extends to macOS later, less code than UIKit, Apple's future |
| **Language** | Swift | Required for SwiftUI, first-party Apple support |
| **Data persistence** | SwiftData | Apple's modern persistence framework, built for SwiftUI, replaces Core Data |
| **Voice transcription** | Apple Speech framework | On-device, no cloud dependency, free, privacy-friendly |
| **Photo picker** | PhotosUI (PHPicker) | Native multi-select, no permission prompt needed for selection |
| **Audio recording** | AVFoundation | Apple's standard audio recording framework |
| **Search** | Spotlight / NSPredicate | Full-text search over SwiftData models |
| **Minimum target** | iOS 17+ | SwiftData requires iOS 17. Covers ~90%+ of active devices |

## Technical Considerations

- **Local-first architecture** — all data stored on-device in V1
- **Performance** — App launch to input ready in < 1 second
- **Data model** — Thread → Entries (1-to-many). Entry types: text, voice, photo gallery
- **File storage** — Audio files and photos stored in app's document directory, referenced by SwiftData models
- **Widget** — WidgetKit for home screen quick capture
- **App architecture** — MVVM pattern (standard for SwiftUI apps)

## Success Metrics

| Metric | Target |
|---|---|
| Time from app launch to first input | < 1 second |
| Daily active capture rate | ≥ 3 captures/day per active user |
| Thread revisit rate | ≥ 30% of threads appended to at least once |
| Search success rate | ≥ 80% of searches result in a tap on a result |
| 30-day retention | ≥ 40% |

## Future Phases

| Phase | Features |
|---|---|
| **V2** | iCloud sync, macOS companion app |
| **V3** | AI auto-organization, smart search, resurfacing/daily review |
| **V4** | Monetization (freemium model), OCR for photo search, note linking |
