# WhyCode

Development orchestrator with multi-agent workflows. Uses GSD+ methodology and ralph-wiggum for autonomous iteration.

**[Full Documentation](docs/WHYCODE.md)** - Comprehensive guide with all phases, agents, and troubleshooting.

## Installation

### Method 1: Using the Plugin UI (Recommended)

The most reliable method inside Claude Code:

```bash
# Step 1: Add the marketplace
/plugin marketplace add Carraigdubh/whycode

# Step 2: Open plugin manager
/plugin

# Step 3: Go to "Discover" tab → Select "whycode" → Press Enter to install
# Step 4: Choose "project" scope when prompted

# Step 5: Install ralph-wiggum dependency (same process)
# Go to "Discover" tab → Select "ralph-wiggum" → Install
```

### Method 2: Using Terminal Commands

Run these commands in your terminal **before** starting Claude Code:

```bash
# Add marketplace
claude plugin marketplace add Carraigdubh/whycode

# Install whycode
claude plugin install whycode@whycode-marketplace --scope project

# Install required dependency
claude plugin install ralph-wiggum@claude-plugins-official --scope project

# Start Claude Code
claude
```

### Known Issues

**`/plugin install` returns conversational response instead of installing:**

This is a [known Claude Code bug](https://github.com/anthropics/claude-code/issues). The slash command sometimes triggers a conversational response instead of executing.

**Workarounds:**
1. Use the `/plugin` UI method (Method 1 above)
2. Use terminal commands (Method 2 above)
3. Try running the command again

**Plugin shows "already installed" but `/whycode` not available:**

```bash
# Restart Claude Code after installation
# The slash command registers on restart
```

### Dependencies

| Dependency | Required | Purpose |
|------------|----------|---------|
| ralph-wiggum | **Yes** | Provides `/ralph-loop` for autonomous iteration |
| Linear MCP | No | Issue tracking integration |
| Chrome extension | No | E2E testing for web projects |

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
