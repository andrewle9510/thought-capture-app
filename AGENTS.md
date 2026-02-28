# AGENTS.md: Thought Capture Development Guidelines

## Project Status
**Phase:** Pre-development (planning/research complete).

## Project Instructions
- Preserve product intent for V1: local-first behavior, no network dependencies, and fast startup
- Keep all changes aligned with repository workflows and tracking expectations in this file
- Do not add framework-specific coding rules here; use skills for technical implementation guidance

## Build & Test Commands
```bash
xcodebuild build                           # Build project
xcodebuild test                            # Run all tests
xcodebuild test -only-testing: TargetName  # Run single test
swift test                                 # Run with Swift PM
```

## Local Skills (.agents/skills)

Available project skills:
- **Tech Expert (Primary):** `@.agents/skills/swiftui-expert-skill/SKILL.md`
- **Memory Keeper:** `@.agents/skills/memory-keeper/SKILL.md`

Usage guidance:
- Use the primary technical skill for all programming tasks and implementation decisions
- Use Memory Keeper for preserving context and session continuity
- Keep this AGENTS file operational; keep technical rules in skill files

## Beads Workflow (.beads/README.md)

This repository uses Beads for issue tracking. Track work in `.beads/issues.jsonl` using `bd` commands.

Essential commands:
```bash
bd create "Issue title"
bd list
bd show <issue-id>
bd update <issue-id> --status in_progress
bd update <issue-id> --status done
bd sync
```

Beads expectations:
- Create and maintain Beads issues for follow-up work
- Keep issue status accurate (`open`, `in_progress`, `done`)
- Run `bd sync` during session completion before `git push`

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
