# AGENTS.md: Thought Capture Development Guidelines

## Project Status
**Phase:** Pre-development (planning/research complete). Target: iOS app using SwiftUI, SwiftData.

## Build & Test Commands
```bash
xcodebuild build                           # Build project
xcodebuild test                            # Run all tests
xcodebuild test -only-testing: TargetName  # Run single test
swift test                                 # Run with Swift PM
```

## Architecture & Structure
- **Language:** Swift + SwiftUI (iOS 17+)
- **Data Layer:** SwiftData (local-first, on-device only for V1)
- **File Storage:** App document directory for audio/photos
- **Core Model:** Thread → Entries (1-to-many). Entry types: text, voice, photo gallery
- **App Pattern:** MVVM
- **Key Frameworks:** AVFoundation (audio), PhotosUI (photos), Speech (transcription), WidgetKit (quick capture)
- **No external dependencies:** All native iOS frameworks

## Code Style Guidelines
- **Naming:** camelCase for properties/methods, PascalCase for types
- **Structure:** One file per view/model (Swift convention)
- **Error Handling:** Use Result<T, Error> and Swift's throwing functions
- **Comments:** Document non-obvious logic; avoid restating code
- **Imports:** Organize alphabetically, group by framework type
- **No trailing commas:** Swift convention

## SwiftUI Patterns (see @.agents/skills/swiftui-expert-skill/SKILL.md)
**State Management:** `@State` (private, internal), `@Binding` (child modifies parent), `@StateObject` (owned), `@ObservedObject` (injected), `@Bindable` (iOS 17+ injected `@Observable`)
**View Composition:** Extract complex views to subviews, use modifiers over conditionals, keep `body` simple and pure, no side effects in view body
**Performance:** Pass only needed values, eliminate unnecessary dependencies, use stable identity in `ForEach`, avoid inline filtering, no `AnyView` in lists, gate geometry updates by thresholds
**Animations:** Use `.animation(_:value:)` with value parameter, `withAnimation` for event-driven, transitions outside conditionals, prefer transforms over layout changes
**Accessibility:** Prefer `Button` over `onTapGesture`, use `@ScaledMetric` for Dynamic Type, group related elements, provide `accessibilityLabel` when unclear

## Notes for Agents
- Minimize dependencies (all native frameworks)
- Performance critical: app launch < 1 second
- Local-first: no network calls in V1
- Test coverage expected for data models and transcription logic

## Landing the Plane (Session Completion)

**When ending a work session**, you MUST complete ALL steps below. Work is NOT complete until `git push` succeeds.

**MANDATORY WORKFLOW:**

1. **File issues for remaining work** - Create issues for anything that needs follow-up
2. **Run quality gates** (if code changed) - Tests, linters, builds
3. **Update issue status** - Close finished work, update in-progress items
4. **PUSH TO REMOTE** - This is MANDATORY:
   ```bash
   git pull --rebase
   bd sync
   git push
   git status  # MUST show "up to date with origin"
   ```
5. **Clean up** - Clear stashes, prune remote branches
6. **Verify** - All changes committed AND pushed
7. **Hand off** - Provide context for next session

**CRITICAL RULES:**
- Work is NOT complete until `git push` succeeds
- NEVER stop before pushing - that leaves work stranded locally
- NEVER say "ready to push when you are" - YOU must push
- If push fails, resolve and retry until it succeeds
