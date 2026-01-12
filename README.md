# WhyCode

Development orchestrator with multi-agent workflows. Uses GSD+ methodology and ralph-wiggum for autonomous iteration.

**[Full Documentation](docs/WHYCODE.md)** - Comprehensive guide with all phases, agents, and troubleshooting.

## Installation

```bash
# Add marketplace (global)
/plugin marketplace add Carraigdubh/whycode

# Install plugin (project-scoped recommended)
/plugin install whycode@whycode-marketplace --scope project

# Also requires ralph-wiggum
/plugin install ralph-wiggum@claude-plugins-official
```

**For local development/testing:**
```bash
/plugin install /Users/martinquinlan/dev/whycode-marketplace/plugins/whycode --scope project
```

## Usage

```bash
/whycode              # Start full 8-phase workflow
/whycode fix          # Fix and Learn mode
/whycode fix "desc"   # Fix with description
```

## What It Does

**8-Phase Workflow:**

| Phase | Name | Mode |
|-------|------|------|
| 0 | Document Intake | Interactive |
| 0.5 | Codebase Mapping | Auto (brownfield) |
| 1 | Discovery | Optional |
| 2 | Tech Stack Setup | Interactive |
| 3 | Specification | Semi-interactive |
| 4 | Architecture | Semi-interactive |
| 5 | Implementation | Autonomous |
| 6 | Quality Review | Autonomous |
| 7 | Documentation | Autonomous |
| 8 | Handoff | Autonomous |

**7 Specialized Agents:**

| Agent | Purpose |
|-------|---------|
| `backend-agent` | Backend APIs, database, server logic |
| `frontend-agent` | UI components, pages, client logic |
| `test-agent` | Unit/integration testing |
| `e2e-agent` | E2E UI testing (Chrome for web, Maestro for Expo) |
| `review-agent` | Code quality, bugs, security |
| `tech-stack-setup-agent` | Project setup, configuration |
| `docs-agent` | Documentation generation |

## Key Features

- **IMMUTABLE_DECISIONS**: User technology choices are never substituted
- **GSD+ Methodology**: Fresh 200k context per plan, max 3 tasks per plan
- **ralph-wiggum Integration**: Autonomous iteration with `/ralph-loop`
- **Linear Integration**: Issue tracking (optional)
- **Version Checking**: Shows updates on startup with changelog

## Repository Structure

```
whycode-marketplace/                    # Git repo root
├── .claude-plugin/
│   └── marketplace.json                # Marketplace definition
├── plugins/whycode/                    # Plugin files
│   ├── .claude-plugin/plugin.json
│   ├── CHANGELOG.md
│   ├── agents/                         # 7 agent definitions
│   │   ├── backend-agent.md
│   │   ├── frontend-agent.md
│   │   ├── test-agent.md
│   │   ├── e2e-agent.md
│   │   ├── review-agent.md
│   │   ├── tech-stack-setup-agent.md
│   │   └── docs-agent.md
│   └── skills/whycode/
│       ├── SKILL.md                    # Main orchestrator
│       └── reference/
│           ├── AGENTS.md               # Agent execution protocols
│           └── TEMPLATES.md            # Document templates
└── README.md                           # This file
```

## Development

### Editing Plugin Files
```bash
cd /Users/martinquinlan/dev/whycode-marketplace/plugins/whycode
# Edit agents, skills, etc.
```

### Committing Changes
```bash
cd /Users/martinquinlan/dev/whycode-marketplace
git add .
git commit -m "feat: description of change"
git push
```

### Version Bump
1. Update `plugins/whycode/.claude-plugin/plugin.json` → `version`
2. Update `plugins/whycode/CHANGELOG.md`
3. Commit and push

### Testing Locally
```bash
# In test project
/plugin install /Users/martinquinlan/dev/whycode-marketplace/plugins/whycode --scope project
```

## Dependencies

- **ralph-wiggum**: Required for `/ralph-loop` autonomous iteration
- **Linear MCP** (optional): For issue tracking integration
- **Chrome extension** (optional): For E2E testing of web projects

## References

- [GSD: Get Shit Done](https://github.com/glittercowboy/get-shit-done)
- [ralph-wiggum](https://github.com/anthropics/claude-plugins-official)
- [Anthropic: Multi-agent best practices](https://www.anthropic.com/engineering/multi-agent-research-system)
