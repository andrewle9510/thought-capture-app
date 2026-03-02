# Mindmap Research: Visualization for Thought Capture

## Decision
**Chosen: Grape (SwiftGraphs/Grape)** — Native SwiftUI force-directed graph library

## Why Grape
- MIT licensed, actively maintained (v1.1.0+, Jan 2025)
- SwiftUI-first API, integrates via Swift Package Manager
- Force-directed layout — perfect for visualizing connections between thoughts (graph, not strict tree)
- Aligns with local-first, no network dependencies, fast startup goals
- No WKWebView bridging complexity

## Alternatives Considered

### Native Options
| Option | License | Pros | Cons |
|---|---|---|---|
| **Grape** ✅ | MIT | SwiftUI-first, SPM, force-directed | Some features in-progress |
| **Pure SwiftUI Canvas** | N/A | Zero deps, full control | More build effort |

### Web-based (WKWebView) Options
| Option | License | Pros | Cons |
|---|---|---|---|
| **Mind Elixir** | MIT | Full editor, very active (v5.9.1) | WebView bridging, theming overhead |
| **jsMind** | BSD-3 | Simple, small (~437 kB) | Less customizable |
| **markmap** | MIT | Markdown → mindmap | Renderer only, not an editor |
| **Cytoscape.js** | MIT | Very powerful graph viz | Build mindmap UX yourself |
| **vis-network** | MIT/Apache-2 | Simple force-directed | Similar to Cytoscape but simpler |
| **SimpleMindMap** | MIT* | Plugin-based, feature-rich | Heavy, extra attribution expectations |

### Other Approaches
- **Graphviz-style (DOT → SVG)**: Deterministic layouts but heavy (WASM), less interactive
- **Manual layout (no algorithm)**: Users drag nodes, persist positions — simplest but no auto-layout

## Integration Plan (Grape)
- **Repo:** https://github.com/swiftgraphs/Grape
- **Integration:** Swift Package Manager
- **Model:** Graph nodes = threads/entries, edges = connections (stored in SwiftData)
- **Phase 1:** Read-only graph explorer (pan/zoom, tap node to open thread)
- **Phase 2:** Editing (create/delete edges, pin positions)
- **Persistence:** Pin node positions for stable layout between launches

## Key Risks & Mitigations
- **Force layout instability** → Support pinning + persist positions
- **Performance with large graphs** → Limit visible nodes (e.g., show neighborhood of selected thread)
- **Grape roadmap items** → Some link styling marked 🚧; fall back to custom drawing if needed

## References
- Grape repo: https://github.com/swiftgraphs/Grape
- Mind Elixir: https://github.com/SSShooter/mind-elixir-core
- jsMind: https://github.com/hizzgdev/jsmind
- Cytoscape.js: https://github.com/cytoscape/cytoscape.js
