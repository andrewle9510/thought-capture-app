---
name: memory-keeper
description: Captures and documents important conversations, visions, and decisions from threads. Extracts key insights, searches for brainstorm context, and saves structured memories. Use when you want to record project visions, decisions, or important thread insights for future reference.
---

# Memory-Keeper

Alfred helps you capture and preserve important conversations, visions, and decisions from your work threads. Never lose context again.

## What Alfred Does

- **Reads threads** - Gets full conversation context from any Amp thread
- **Extracts insights** - Identifies key decisions, ideas, and visions
- **Brainstorms** - Web searches to enhance and validate your ideas
- **Saves memories** - Creates structured, searchable memory files in `docs/memories/`

## How to Use

### Capture a Thread
```
Alfred, remember this thread: [paste thread URL or ID]
```

Alfred will:
1. Read the thread
2. Extract: date, topic, summary, key decisions
3. Save to `docs/memories/YYYY-MM-DD-topic.md`

### Capture a Vision
```
Alfred, capture my vision of: [your idea]
```

Alfred will:
1. Record your vision
2. Web search for relevant patterns, technologies, examples
3. Synthesize findings
4. Save memory with vision + brainstorm insights + links

## Memory Format

All memories use YAML frontmatter + Markdown:

```markdown
---
date: 2026-02-01
topic: Real-Time Collaboration Feature - Vision
thread: T-abc123...
---

# Summary
One sentence describing the essence.

## Key Points
- Point 1
- Point 2

## Brainstorm Insights
(Populated by Alfred's web search if applicable)

## Links & References
- [Link 1]
- [Link 2]
```

### Topic Format
- Decisions: `Feature Name - Decision`
- Visions: `Feature Name - Vision`
- Learnings: `Topic - Learning`
- Ideas: `Idea Name - Idea`

## Memory Storage

All memories saved to: `docs/memories/`

Filename format: `YYYY-MM-DD-topic-slug.md`

Search past memories anytime by asking Alfred to review `docs/memories/` directory.

## Alfred's Toolbox

Alfred has access to:
- `find_thread` - Search your conversation history
- `read_thread` - Extract full thread content
- `web_search` - Research and brainstorm ideas
- `create_file` - Save structured memories

## Tips

- Memories are timestamped — review them later to recover lost context
- Use consistent topic names for related ideas
- Brainstorm sessions are great for visions you haven't fully implemented yet
- Memories become searchable knowledge base for your project
