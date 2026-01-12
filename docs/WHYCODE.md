# WhyCode Documentation

## Overview

The WhyCode is a **project-type agnostic** workflow orchestration system for building ANY type of software project from documents to deployment. It works equally well for web apps, mobile apps, desktop software, CLI tools, games, embedded systems, ML pipelines, and more.

**Key Features:**
- **Project-type agnostic** - Supports any language, build system, and framework
- Interactive document intake with guided questions
- Dynamic tech stack setup based on project type
- Multi-agent autonomous implementation
- Real-time progress tracking via Linear
- Context-aware architecture following Anthropic best practices
- State persistence and crash recovery
- IMMUTABLE_DECISIONS enforcement
- Continuous validation throughout implementation
- Integration validation before handoff

**Supported Project Types:**
- Web Applications (Next.js, React, Vue, Django, Rails, etc.)
- Mobile Apps (React Native, Flutter, SwiftUI, Jetpack Compose)
- Desktop Applications (Electron, Tauri, Qt, .NET, WPF)
- CLI Tools (Rust/clap, Go/cobra, Python/click, etc.)
- Libraries & SDKs
- API & Backend Services
- Games (Unity, Unreal, Godot, Bevy)
- Embedded / IoT (Arduino, ESP-IDF, Zephyr)
- Data / ML Pipelines (PyTorch, TensorFlow, dbt)

---

## Table of Contents

1. [Quick Start](#quick-start)
2. [Architecture Overview](#architecture-overview)
3. [State Persistence & Recovery](#state-persistence--recovery)
4. [Fix and Learn (Self-Improvement)](#fix-and-learn-self-improvement)
5. [Phases](#phases)
6. [Agents](#agents)
7. [IMMUTABLE_DECISIONS](#immutable_decisions)
8. [Validation System](#validation-system)
9. [Context Management](#context-management)
10. [Linear Integration](#linear-integration)
11. [File Structure](#file-structure)
12. [Commands Reference](#commands-reference)
13. [Troubleshooting](#troubleshooting)

---

## Quick Start

### Starting a New Project

```bash
# In your terminal, run Claude Code
claude

# Start WhyCode
/whycode
```

WhyCode will guide you through:
1. **Document Intake** - Provide your project documents, answer clarifying questions
2. **Tech Stack Setup** - Choose frameworks, set up services, provide API keys
3. **Specification Review** - Approve the generated PRD and task breakdown
4. **Architecture Decision** - Choose your implementation approach
5. **Autonomous Build** - Sit back while agents implement everything
6. **Quality Review** - Review the completed implementation

### Resuming an Existing Project

WhyCode automatically saves state and can resume from interruptions:

```bash
# WhyCode checks for existing state on every run
/whycode

# If state exists, you'll see:
# "Found existing whycode state at Phase 4, Step 4c. Resume from where we left off? [Y/n]"
```

If you've already completed the planning phases:

```bash
# Skip to implementation using existing specs
/implement
```

---

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                        USER INTERACTION                          │
│                    (Phases 0-3: Interactive)                     │
└─────────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                         ORCHESTRATOR                             │
│                                                                  │
│  • Maintains global task queue                                   │
│  • Generates minimal context packets per task                    │
│  • Enforces IMMUTABLE_DECISIONS                                  │
│  • Spawns agents with scoped tools                              │
│  • Runs periodic build validation                                │
│  • Handles failures and retries                                  │
│  • Manages context compaction                                    │
│  • Updates Linear in real-time                                   │
│  • Saves state for crash recovery                                │
└─────────────────────────────────────────────────────────────────┘
                                │
          ┌─────────────────────┼─────────────────────┐
          ▼                     ▼                     ▼
┌─────────────────┐   ┌─────────────────┐   ┌─────────────────┐
│  Backend Agent  │   │ Frontend Agent  │   │   Test Agent    │
│                 │   │                 │   │                 │
│ • APIs          │   │ • Components    │   │ • Unit tests    │
│ • Database      │   │ • Pages         │   │ • Integration   │
│ • Auth          │   │ • Styling       │   │ • Coverage      │
│                 │   │                 │   │                 │
│ SELF-VALIDATES: │   │ SELF-VALIDATES: │   │ Uses PM from    │
│ • TypeCheck     │   │ • TypeCheck     │   │ task packet     │
│ • Lint          │   │ • Lint          │   │                 │
│ • Tests         │   │ • Build         │   │                 │
│ • Build         │   │ • Tests         │   │                 │
└─────────────────┘   └─────────────────┘   └─────────────────┘
          │                     │                     │
          └─────────────────────┼─────────────────────┘
                                ▼
                    ┌─────────────────────┐
                    │  docs/artifacts/    │
                    │  (Results Storage)  │
                    └─────────────────────┘
```

### Design Principles (Anthropic-Aligned)

Based on [Anthropic's multi-agent best practices](https://www.anthropic.com/engineering/multi-agent-research-system):

| Principle | Implementation |
|-----------|----------------|
| **Context Isolation** | Each agent gets a minimal task packet, not the full project |
| **Artifact-Based Handoff** | Agents write to files, return paths (not contents) |
| **Tool Scoping** | Each agent has explicit, limited tools |
| **Phase Compaction** | `/compact` runs between phases and every 5 tasks |
| **Lightweight Returns** | Orchestrator reads summaries, not full code |
| **IMMUTABLE_DECISIONS** | User technology choices are never substituted |
| **Agent Self-Validation** | Agents validate their own work (they have context) |
| **Orchestrator Black-Box Validation** | Periodic validation without code context |

---

## State Persistence & Recovery

WhyCode maintains state in `docs/whycode-state.json` for crash recovery and resumption.

### State File Structure

```json
{
  "status": "in_progress | completed | failed",
  "currentPhase": 4,
  "currentStep": "4c",
  "completedPhases": [0, 1, 2, 3],
  "startedAt": "2024-01-15T10:30:00Z",
  "lastUpdatedAt": "2024-01-15T14:45:00Z",
  "phase4Progress": {
    "linearIssuesCreated": true,
    "tasksTotal": 29,
    "tasksCompleted": ["task-001", "task-002", "task-003"],
    "tasksInProgress": ["task-004"],
    "tasksFailed": [],
    "lastCompletedTask": "task-003"
  },
  "artifacts": {
    "projectUnderstanding": "docs/intake/project-understanding.md",
    "techStack": "docs/decisions/tech-stack.json",
    "masterPrd": "docs/specs/master-prd.md",
    "taskGraph": "docs/specs/task-graph.json",
    "linearMapping": "docs/decisions/linear-mapping.json"
  },
  "lastError": null
}
```

### Startup Detection (EXECUTE FIRST)

**CRITICAL**: On EVERY harness invocation, check for existing state BEFORE doing anything else:

```
1. Check if docs/whycode-state.json exists
2. IF exists AND status == "in_progress":
   - Display: "Found existing whycode state at Phase {X}, Step {Y}"
   - Display: "Last activity: {lastUpdatedAt}"
   - Ask: "Resume from where we left off? [Y/n]"
   - IF yes: Jump to saved phase/step
   - IF no: Ask if they want to start fresh (WARNING: will lose progress)
3. IF exists AND status == "completed":
   - Display: "Previous harness run completed successfully"
   - Ask: "Start a new project? [Y/n]"
4. IF exists AND status == "failed":
   - Display: "Previous run failed at Phase {X}: {lastError}"
   - Ask: "Retry from failure point? [Y/n]"
5. IF not exists:
   - Proceed with fresh start
```

### State Update Rules

- Update state file at the START of each step (not just completion)
- Include `lastUpdatedAt` timestamp on every update
- On task completion, immediately update `tasksCompleted` array
- On failure, set `lastError` with descriptive message

---

## Fix and Learn (Self-Improvement)

WhyCode can learn from errors and update itself to prevent them from recurring.

### How It Works

When something goes wrong:
1. You describe what happened (or WhyCode detects it from state)
2. WhyCode analyzes the root cause
3. An immediate fix is applied to your project
4. WhyCode proposes updates to itself to prevent recurrence
5. With your approval, WhyCode updates its own files
6. The learning is recorded for future reference

### Triggering Fix and Learn

**Option 1: On Resume**

When resuming from a failed state, you'll see the "Fix and Learn" option:
```
I found an interrupted harness session WITH ERRORS:
- Last Error: Build failed - multiple lockfiles detected
- Failed Tasks: 3

What would you like to do?
> Fix and Learn (analyze issue, fix, update harness)  ← Select this
> Resume anyway (skip failed tasks)
> Start fresh
```

**Option 2: Direct Command**

```bash
# With description
/whycode fix "WhyCode used pnpm but my project uses yarn"

# Without description (will prompt you)
/whycode fix
```

### Issue Categories

WhyCode categorizes issues to determine the best fix:

| Category | Description | Example |
|----------|-------------|---------|
| TECH_STACK | Wrong build system/framework | "Used pnpm instead of yarn" |
| AGENT_BEHAVIOR | Agent ignored IMMUTABLE_DECISIONS | "Agent used styled-components instead of tailwind" |
| VALIDATION | Errors not caught early | "Type errors only found at end of phase" |
| INTEGRATION | Service configuration issues | "Clerk middleware wasn't set up correctly" |
| DOCUMENTATION | Missing/unclear instructions | "Didn't know I needed to add 'use client'" |
| STATE | State corruption/resumption issues | "Harness stuck in a loop" |

### Conservative Self-Updates

WhyCode uses **Conservative Mode** for self-updates:

- **Additive only** - Only adds validation steps and documentation
- **Never modifies core logic** automatically
- **Always asks for approval** before updating any file
- **Shows full diff** of proposed changes

Example approval flow:
```
I'd like to update SKILL.md to prevent this issue:

📄 Proposed update to: .claude/skills/whycode/SKILL.md
   Section: Step 1.3
   Change: Add explicit build system verification

   Diff:
   + ### Step 1.3d: Build System Verification
   + After selecting build system, immediately verify:
   + RUN: {pm} --version
   + Log: "✅ Confirmed using {pm}"

Apply these updates? [Yes/No/Show full diff]
```

### What Gets Auto-Applied (No Approval)

- Logging error to `docs/errors/error-patterns.json`
- Immediate fixes to your current project
- Updating whycode-state.json

### What Requires Approval

- Any edit to SKILL.md
- Any edit to agent files (.claude/agents/*.md)
- Any edit to harness.md
- Any edit to CLAUDE.md

### Learning Storage

Learnings are stored in:
- `docs/errors/error-patterns.json` - Structured error patterns
- `docs/errors/learnings.md` - Human-readable log

These help WhyCode recognize similar issues in the future.

---

## Pre-Flight Environment Checks

**CRITICAL**: These checks run BEFORE Phase 0 to catch environment issues early.

### Runtime/Compiler Version Detection

WhyCode detects your development environment and identifies known issues:

**For Web/Node.js projects:**
| Node Version | Known Issues |
|--------------|--------------|
| 25.x | Experimental localStorage conflicts with browser code during SSR |
| 22.x | Fetch API behavior changes in server components |

**For other ecosystems:**
- Rust: Checks `rustc --version` for compatibility
- Python: Checks Python version and virtual environment
- Go: Checks `go version`
- C++: Checks compiler availability (gcc, clang, MSVC)

If issues are detected, WhyCode stores them in `docs/decisions/environment-notes.json` and applies appropriate mitigations during setup.

### Required Tools Check

Verifies these universal tools are installed:
- `git` - Version control (required for all projects)

Project-type-specific tools are checked based on the selected tech stack:
- Web: `node`, `npm` (or pnpm/yarn/bun)
- Rust: `cargo`, `rustc`
- Python: `python`, `pip` (or poetry/conda)
- C++: `cmake`, `make`, or platform compiler
- Go: `go`
- Mobile: `flutter` or platform-specific tools

Optional tools checked:
- `gh` - GitHub CLI for PR creation

### Disk Space Check

Ensures sufficient disk space is available for dependencies and build artifacts (varies by project type).

---

## Phases

### Phase 0: Document Intake (Interactive)

**Purpose:** Understand your project requirements through guided conversation.

**What You Provide:**
- Project documents (drag/drop, paste, or file paths)
- Answers to clarifying questions
- Confirmation of extracted requirements

**What Happens:**
1. You provide documents
2. Claude extracts vision, features, constraints
3. You confirm or correct each extraction
4. User stories and acceptance criteria are drafted
5. Full understanding is summarized for your approval

**Output:** `docs/intake/project-understanding.md`

**Gate:** You must confirm understanding before proceeding.

---

### Phase 1: Tech Stack Setup (Interactive, Dynamic)

**Purpose:** Configure your development environment based on the detected project type.

**CRITICAL:** This phase adapts dynamically to ANY project type. The questions, options, and configurations vary based on what you're building.

**Decisions Made (varies by project type):**

| Project Type | Example Decisions |
|--------------|-------------------|
| Web App | Package manager (pnpm/yarn/npm), Framework (Next.js/React/Vue), Database, Auth, Hosting |
| Mobile App | Cross-platform (React Native/Flutter) or Native, Backend, Push notifications |
| Desktop App | Framework (Electron/Tauri/Qt/.NET), Auto-update, Crash reporting |
| CLI Tool | Language (Rust/Go/Python), CLI framework, Distribution |
| Game | Engine (Unity/Unreal/Godot), Multiplayer backend, Monetization |
| Embedded | Platform (Arduino/ESP-IDF/Zephyr), Cloud backend, OTA updates |
| Data/ML | Frameworks (PyTorch/TensorFlow), Experiment tracking, Orchestration |

**What You Provide:**
- Project type selection
- Language and build system preferences
- Framework choice
- Service providers
- API keys for selected services

**What Happens:**
1. Project type detected/selected
2. Language and build system chosen (varies by project type)
3. Build system verified & installed
4. Framework selected and configured
5. Services configured based on project type
6. Dependencies installed
7. Build verified

#### Step 1.3b: Verify & Install Build System

**CRITICAL**: The selected build system must be installed and working.

WhyCode supports many build systems across different languages:

| Language | Build Systems |
|----------|---------------|
| TypeScript/JavaScript | pnpm, yarn, npm, bun |
| Rust | cargo |
| C/C++ | CMake, Make, MSBuild, Meson |
| Python | pip, poetry, conda, uv |
| Go | go mod |
| Java/Kotlin | Gradle, Maven |
| C# | dotnet CLI, MSBuild |
| Dart | flutter, pub |

```bash
# Example verifications (actual command varies by build system)
IF selected_build_system == "cargo":
  which cargo || curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

IF selected_build_system == "poetry":
  which poetry || pip install poetry

IF selected_build_system == "CMake":
  which cmake || brew install cmake  # or apt install cmake
```

**Fetch current documentation** for the build system to ensure configuration is correct.

#### Step 1.3c: Create Build Commands Reference

WhyCode creates `docs/decisions/pm-commands.json` with the exact commands for your build system:

```json
{
  "_buildSystem": "cargo",
  "_warning": "Use ONLY these commands.",
  "install": "cargo build",
  "addDep": "cargo add",
  "runScript": "cargo",
  "build": "cargo build --release"
}
```

Or for a web project:

```json
{
  "_buildSystem": "pnpm",
  "_warning": "Use ONLY these commands.",
  "install": "pnpm install",
  "addDep": "pnpm add",
  "runScript": "pnpm run",
  "build": "pnpm run build"
}
```

#### Step 1.4: Lockfile/Manifest Consistency Check (Language-Specific)

For languages with lockfiles (JS/TS, Rust, Python with poetry, etc.), WhyCode verifies consistency:

**JavaScript/TypeScript:**
```python
lockfile_map = {
  "pnpm": "pnpm-lock.yaml",
  "yarn": "yarn.lock",
  "npm": "package-lock.json",
  "bun": "bun.lockb"
}
# Only ONE lockfile should exist, matching the selected PM
```

**Rust:** Cargo.lock is managed automatically by cargo.

**Python (poetry):** poetry.lock is managed by poetry.

**Other languages:** WhyCode respects each ecosystem's conventions.

#### Step 1.5: Tech Stack Setup Agent (Universal)

Different technology combinations require specific configurations. Rather than hardcoding these (which become outdated), WhyCode spawns a **tech-stack-setup-agent** that dynamically configures ANY project type:

1. **Analyzes** your tech stack combinations (works for ANY project type)
2. **Fetches** current documentation from official sources using WebSearch/WebFetch
3. **Applies** the correct configurations based on latest best practices
4. **Validates** the setup with a build

**Why an agent instead of hardcoded rules:**
- Technology documentation changes frequently
- New versions may require different configurations
- The agent adapts to ANY tech combination, not just web apps
- Works for C++, Rust, Python, mobile, embedded, games, etc.
- Always uses current best practices, not stale knowledge

**Examples of what the agent configures (varies by project type):**

| Project Type | Example Configurations |
|--------------|----------------------|
| Web (Next.js + Clerk) | Auth middleware, SSR-safe providers |
| Mobile (Flutter + Firebase) | Firebase initialization, platform setup |
| Desktop (Qt + Sentry) | Crash handler integration, build configuration |
| CLI (Rust + clap) | Argument parser setup, cargo configuration |
| Embedded (ESP-IDF + AWS IoT) | Device provisioning, certificate setup |
| Game (Unity + Photon) | Multiplayer networking, asset configuration |

**Output:**
- `docs/decisions/tech-stack.json` (project type, language, build system, framework)
- `docs/decisions/pm-commands.json` (exact commands for your build system)
- `docs/decisions/integration-setup.md` (what was configured and why)
- `.env.local` or equivalent (your API keys)
- `.env.example` (template for others)
- Framework-specific configuration files

**Gate:** Build must pass before proceeding.

---

### Phase 2: Specification Synthesis (Semi-Interactive)

**Purpose:** Transform your requirements into actionable specifications.

**What Gets Generated:**
1. **Master PRD** - Comprehensive product requirements
2. **Feature Specs** - One file per feature with scope, dependencies, criteria
3. **Technical Spec** - Architecture decisions and patterns
4. **Task Graph** - Dependency-ordered implementation tasks

**Output:**
- `docs/specs/master-prd.md`
- `docs/specs/features/*.md`
- `docs/specs/technical-spec.md`
- `docs/specs/task-graph.json`

**Gate:** You must approve specifications before implementation.

---

### Phase 3: Architecture Design (Semi-Interactive)

**Purpose:** Design the implementation approach.

**Options Presented:**
- **Minimal** - Fastest path to working software
- **Clean** - Best maintainability and patterns
- **Balanced** - Pragmatic middle ground

**What Happens:**
1. Code-architect agents analyze requirements
2. Component architecture designed
3. Interfaces and data contracts defined
4. Implementation roadmap created

**Output:** `docs/specs/architecture-decision.md`

**Gate:** You must choose an architecture approach.

---

### Phase 4: Autonomous Implementation (Fully Autonomous)

**Purpose:** Build the entire project without user interaction.

**Mode:** FULLY AUTONOMOUS - No user input required after Phase 3.

**What Happens:**

```
1. INITIALIZATION
   • Load task graph and decisions
   • Create Linear issues SEQUENTIALLY (1-second delays to prevent rate limiting)
   • Generate task-specific context packets with IMMUTABLE_DECISIONS
   • Verify lockfile consistency

2. EXECUTION LOOP (repeats until done)
   • Get next unblocked tasks
   • Spawn agents in parallel (max 3)
   • Update Linear: "In Progress"
   • Agent implements with MANDATORY SELF-VALIDATION
   • Agent returns artifact path with validation results
   • Update Linear: "Done"
   • Log to progress.md
   • Run ORCHESTRATOR_BUILD_VALIDATION every 5 tasks
   • Check compaction triggers
   • Handle any failures (retry up to 3x)
   • Update whycode-state.json

3. INTEGRATION VALIDATION (Step 4.6)
   • Verify package manager
   • Install dependencies
   • Build the app
   • Start the app (smoke test)
   • Basic health checks
   • Cleanup

4. COMPLETION
   • Update all Linear issues
   • Generate completion summary
   • Proceed to Phase 5 automatically
```

**Parallelization:**
- Up to 3 agents run simultaneously
- Tasks grouped by type (backend, frontend, test)
- Dependencies respected

**Failure Handling:**
- 3 retry attempts per task
- Failed tasks logged to `docs/blockers.md`
- Dependent tasks marked as skipped
- Execution continues with other tasks
- Never stops to ask user

**Progress Tracking:**
- Real-time Linear updates
- Detailed log in `docs/progress.md`
- State in `docs/whycode-state.json`

---

### Phase 5: Quality Review (Autonomous)

**Purpose:** Validate implementation quality.

**Review Categories:**
1. **Quality** - DRY, simplicity, elegance
2. **Bugs** - Logic errors, edge cases
3. **Conventions** - Project standards
4. **Security** - OWASP top 10

**What Happens:**
- Review agents analyze implemented code
- Issues logged to Linear
- Critical issues trigger fixes (re-enters Phase 4)

**Output:** `docs/review/quality-report.md`

---

### Phase 6: Summary & Handoff (Autonomous)

**Purpose:** Document completed work with CORRECT package manager commands.

**CRITICAL:** Load tech-stack.json to get the correct package manager:

```javascript
const decisions = load("docs/decisions/tech-stack.json");
const pm = decisions.packageManager;  // Use this, not assumptions!
```

**What Gets Generated:**
- What was built
- Key decisions made
- Files created/modified
- Test coverage report
- **Correct deployment instructions using {pm}**
- Known limitations
- Suggested next steps

**Output:** `docs/delivery/handoff-summary.md`

---

## Agents

### Backend Agent

**File:** `.claude/agents/backend-agent.md`

**Purpose:** Implements server-side features including APIs, database schemas, authentication, and business logic.

**Tools:**
- `Read`, `Write`, `Edit` - File operations
- `Bash` - Command execution
- `Glob`, `Grep` - File search
- `mcp__linear__update_issue` - Status updates
- `mcp__linear__create_comment` - Add comments

**Workflow:**
1. Read task packet from `docs/context/task-packets/task-{id}.json`
2. **CHECK IMMUTABLE_DECISIONS FIRST**
3. Implement the feature using ONLY specified technologies
4. Write tests
5. **MANDATORY SELF-VALIDATION:**
   - TypeCheck: `{pm} run typecheck`
   - Lint: `{pm} run lint`
   - Tests: `{pm} run test`
   - Build: `{pm} run build`
   - **DO NOT return "complete" if ANY validation fails**
6. Update Linear to "Done"
7. Write summary to `docs/artifacts/task-{id}/summary.md` with validation results
8. Return `{ status: "complete", artifactPath: "..." }`

**Code Standards:**
- RESTful API conventions
- Structured error responses
- Input validation
- Database migrations
- Unit + integration tests

---

### Frontend Agent

**File:** `.claude/agents/frontend-agent.md`

**Purpose:** Implements UI components, pages, and client-side logic with distinctive, non-generic aesthetics.

**Tools:**
- `Read`, `Write`, `Edit` - File operations
- `Bash` - Command execution
- `Glob`, `Grep` - File search
- `mcp__linear__update_issue` - Status updates

**Workflow:**
1. Read task packet
2. **CHECK IMMUTABLE_DECISIONS FIRST**
3. Implement component/page using ONLY specified technologies
4. **MANDATORY SELF-VALIDATION:**
   - TypeCheck: `{pm} run typecheck`
   - Lint: `{pm} run lint`
   - Build: `{pm} run build`
   - Tests: `{pm} run test` (if applicable)
   - **DO NOT return "complete" if ANY validation fails**
5. Update Linear to "Done"
6. Write summary with validation results to artifacts
7. Return `{ status: "complete", artifactPath: "..." }`

**Design Philosophy:**
- NEVER use generic fonts (Inter, Roboto, Arial) for hero text
- NEVER use purple gradients on white, cookie-cutter layouts
- DO use distinctive fonts, bold colors, intentional motion
- Commit to an aesthetic and execute with precision

**Code Standards:**
- TypeScript
- Functional components with hooks
- Tailwind CSS / CSS-in-JS
- Mobile-first responsive
- WCAG AA accessible

---

### Test Agent

**File:** `.claude/agents/test-agent.md`

**Purpose:** Writes and runs tests to validate implementations.

**Tools:**
- `Read` - Read implemented code
- `Bash` - Run tests
- `Glob`, `Grep` - Find files
- `mcp__linear__update_issue` - Status updates

**Workflow:**
1. Read artifact summary from implementation task
2. **CHECK PACKAGE_MANAGER_COMMANDS from task packet**
3. Read files-created.json to know what to test
4. Write comprehensive tests
5. Run test suite using correct package manager
6. Return `{ status: "pass|fail", coverage: "X%", failures: [...] }`

**Test Guidelines:**
- Test behavior, not implementation
- Independent tests
- Descriptive names
- Mock external dependencies
- Cover edge cases
- Target 80%+ coverage

---

### Review Agent

**File:** `.claude/agents/review-agent.md`

**Purpose:** Reviews code for quality, bugs, conventions, and security.

**Tools:**
- `Read` - Read code files
- `Grep`, `Glob` - Search patterns
- `mcp__linear__create_issue` - Create bug issues
- `mcp__linear__create_comment` - Add review comments

**Review Categories:**
1. **Quality** - DRY, single responsibility, clarity
2. **Bugs** - Logic errors, null checks, race conditions
3. **Conventions** - Naming, organization, types
4. **Security** - Injection, auth, data exposure, XSS

**Output:**
- `docs/artifacts/review-{id}/review-report.md`
- Linear issues for critical findings

---

### Tech Stack Setup Agent (Universal)

**File:** `.claude/agents/tech-stack-setup-agent.md`

**Purpose:** Configures project setup for ANY tech stack by fetching current best practices from official documentation. Works for web, mobile, desktop, CLI, games, embedded, ML, and any other project type.

**Tools:**
- `Read`, `Write`, `Edit` - File operations
- `Bash` - Command execution
- `Glob`, `Grep` - File search
- `WebFetch`, `WebSearch` - Fetch current documentation

**Workflow:**
1. Analyze project context (project type, language, build system, framework, services)
2. Identify what needs configuration (build system, framework, service integrations)
3. Search for and fetch current documentation from official sources
4. Apply configurations based on documentation
5. Create reference documentation for other agents
6. Validate setup with a build
7. Return summary of what was configured

**Why this agent exists:**
- Technology documentation changes frequently
- Hardcoded configurations become outdated quickly
- The agent adapts to ANY tech combination dynamically (not just web)
- Works for C++, Rust, Python, mobile, games, embedded, etc.
- Always uses current best practices

**Official documentation sources covered:**
- Web: Next.js, React, Vue, Clerk, Supabase, Stripe
- Mobile: React Native, Flutter, Firebase
- Desktop: Electron, Tauri, Qt, .NET MAUI
- Systems: Rust/cargo, CMake
- Python: FastAPI, Django, Poetry
- Games: Unity, Unreal, Godot, Bevy
- Data/ML: PyTorch, TensorFlow, MLflow
- Monitoring: Sentry, PostHog, Datadog

**Output:**
- Build system configuration files (Cargo.toml, CMakeLists.txt, package.json, etc.)
- Framework-specific configuration
- `docs/decisions/integration-setup.md` (documents what was configured)
- Build validation result

---

## IMMUTABLE_DECISIONS

### What Are They?

IMMUTABLE_DECISIONS are **user-specified technology choices** that agents must follow exactly. They are captured in Phase 1 and enforced throughout implementation.

### Why They Matter

Without strict enforcement:
- User specifies `yarn` but agent uses `pnpm`
- User specifies `tailwind` but agent uses `styled-components`
- User specifies `supabase` but agent uses `prisma`

This causes:
- Mixed package managers (multiple lockfiles)
- Dependency conflicts
- Broken builds
- Inconsistent codebase

### Task Packet Structure

Every task packet includes IMMUTABLE_DECISIONS and build commands. The structure adapts to any project type:

**Web Application Example:**
```json
{
  "taskId": "task-005",
  "linearId": "ABC-130",
  "objective": "Create login form component",
  "type": "frontend",

  "IMMUTABLE_DECISIONS": {
    "_warning": "These are USER-SPECIFIED choices. NEVER substitute alternatives.",
    "projectType": "Web Application",
    "language": "TypeScript",
    "buildSystem": "yarn",
    "framework": "next",
    "styling": "tailwind",
    "database": "supabase",
    "auth": "clerk"
  },

  "PACKAGE_MANAGER_COMMANDS": {
    "_warning": "Use ONLY these commands.",
    "install": "yarn install",
    "addDep": "yarn add <package>",
    "runScript": "yarn run <script>",
    "build": "yarn run build"
  },

  "acceptanceCriteria": [...],
  "writeArtifactsTo": "docs/artifacts/task-005/"
}
```

**Desktop C++ Example:**
```json
{
  "taskId": "task-012",
  "linearId": "ABC-145",
  "objective": "Implement main window with menu bar",
  "type": "frontend",

  "IMMUTABLE_DECISIONS": {
    "_warning": "These are USER-SPECIFIED choices. NEVER substitute alternatives.",
    "projectType": "Desktop Application",
    "language": "C++",
    "buildSystem": "CMake",
    "framework": "Qt",
    "crashReporting": "Sentry"
  },

  "PACKAGE_MANAGER_COMMANDS": {
    "_warning": "Use ONLY these commands.",
    "install": "cmake --build . --config Release",
    "addDep": "(edit CMakeLists.txt)",
    "runScript": "cmake",
    "build": "cmake --build . --config Release"
  },

  "acceptanceCriteria": [...],
  "writeArtifactsTo": "docs/artifacts/task-012/"
}
```

### Agent Enforcement Rules

**AGENTS MUST:**
- Check IMMUTABLE_DECISIONS before any implementation
- Use EXACTLY the `packageManager` specified
- Use EXACTLY the technologies specified
- Use PACKAGE_MANAGER_COMMANDS for all commands

**AGENTS MUST NEVER:**
- Substitute a different package manager because they "prefer" it
- Use a different library because it's "better" or "more popular"
- Change any user-specified technology choice for any reason
- Assume defaults that contradict IMMUTABLE_DECISIONS

**VIOLATIONS ARE TASK FAILURES.**

---

## Validation System

### Why Validation Matters

Without continuous validation:
- Errors accumulate silently
- Build failures discovered only at the end
- Type errors cascade across tasks
- Integration issues found too late to fix easily

### Validation Architecture

Based on research into multi-agent validation best practices, WhyCode uses a **hybrid approach**:

| Validator | Has Code Context? | When Runs | What It Checks |
|-----------|-------------------|-----------|----------------|
| Agent Self-Validation | Yes | After each task | TypeCheck, Lint, Tests, Build |
| Orchestrator Black-Box | No | Every 5 tasks | Build, Lockfile consistency |
| Integration Validation | No | End of Phase 4 | Full app smoke test |

### Agent Self-Validation (MANDATORY)

Every implementation agent (backend, frontend) MUST run these validations before returning "complete":

```bash
# Using commands from PACKAGE_MANAGER_COMMANDS
pm = PACKAGE_MANAGER_COMMANDS.runScript

# 1. Type Check
{pm} run typecheck
# IF fails → FIX before continuing

# 2. Lint Check
{pm} run lint
# IF fails → FIX before continuing

# 3. Unit Tests
{pm} run test
# IF fails → FIX before continuing

# 4. Build Check
{pm} run build
# IF fails → FIX before continuing
```

**CRITICAL**: Agents may ONLY return `status: "complete"` if ALL validations pass.

### Orchestrator Build Validation

The orchestrator runs periodic black-box validation (no code context needed):

**When it runs:**
- After every 5 completed tasks
- After completing all tasks for a feature

**What it checks:**
```bash
# 1. BUILD CHECK
{pm} run build

# 2. TYPECHECK
{pm} run typecheck

# 3. LOCKFILE CONSISTENCY
# Verify only one lockfile matching selected PM exists
```

**On failure:** Create fix task, assign to appropriate agent, re-run validation.

### Integration Validation (Step 4.6)

**CRITICAL**: The goal is a RUNNABLE APP. All tasks passing means nothing if the app doesn't start.

```bash
# STEP 1: Verify Package Manager
pm = load("docs/decisions/tech-stack.json").packageManager
verify_installed(pm)

# STEP 2: Install Dependencies
{pm} install

# STEP 3: Build the App
{pm} run build
# IF fails → Create fix task, retry

# STEP 4: Start the App (Smoke Test)
process = start_background("{pm} run dev")
wait_for_startup(timeout=30s)

# STEP 5: Basic Health Checks
# HTTP GET to main routes
# Verify 200 responses

# STEP 6: Cleanup
kill(process)
```

**On Validation Failure:**
1. Log error to `docs/blockers.md`
2. Create fix task with error details
3. Spawn agent to fix
4. Re-run integration validation
5. Maximum 3 attempts before marking harness as "needs manual intervention"

---

## Context Management

### The Problem

Large projects exceed LLM context windows. Loading everything into every agent causes:
- Token exhaustion
- Slow responses
- Lost information
- Higher costs

### The Solution: Minimal Context Packets

Each task gets a JSON packet with ONLY what it needs. The structure adapts to any project type:

**Web Project Example:**
```json
{
  "taskId": "task-005",
  "objective": "Create login form component",
  "type": "frontend",
  "IMMUTABLE_DECISIONS": {
    "projectType": "Web Application",
    "buildSystem": "yarn",
    "framework": "next"
  },
  "PACKAGE_MANAGER_COMMANDS": {
    "install": "yarn install",
    "addDep": "yarn add",
    "build": "yarn run build"
  },
  "acceptanceCriteria": ["Form renders correctly", "Validation works"],
  "writeArtifactsTo": "docs/artifacts/task-005/"
}
```

**Rust CLI Example:**
```json
{
  "taskId": "task-008",
  "objective": "Add --verbose flag to CLI",
  "type": "backend",
  "IMMUTABLE_DECISIONS": {
    "projectType": "CLI Tool",
    "buildSystem": "cargo",
    "framework": "clap"
  },
  "PACKAGE_MANAGER_COMMANDS": {
    "install": "cargo build",
    "addDep": "cargo add",
    "build": "cargo build --release"
  },
  "acceptanceCriteria": ["--verbose flag accepted", "Increases log output"],
  "writeArtifactsTo": "docs/artifacts/task-008/"
}
```

### Context Rules

**For Orchestrator:**
- Load summaries, not source documents
- Run `/compact` between phases
- Store artifact paths, not contents

**For Agents:**
- Read ONLY the task packet
- Retrieve additional files only if absolutely necessary
- Return `{ status, artifactPath }` - never full contents

### Compaction Triggers

`/compact` runs automatically when:
- 5 tasks complete
- 3 consecutive retries occur
- Agent returns >2000 characters
- 30 minutes of continuous execution
- Responses slow or truncate

---

## Linear Integration

### Setup

Linear MCP is configured in `.mcp.json`:

```json
{
  "mcpServers": {
    "linear": {
      "command": "npx",
      "args": ["-y", "mcp-remote", "https://mcp.linear.app/sse"]
    }
  }
}
```

### Issue Creation (Sequential with Delays)

**CRITICAL**: Create Linear issues SEQUENTIALLY with 1-second delays to prevent rate limiting.

```javascript
for (const task of tasks) {
  await mcp__linear__create_issue({
    title: task.title,
    description: task.description,
    team: teamId,
    parentId: featureIssueId
  });

  // IMPORTANT: Wait 1 second between API calls
  await sleep(1000);
}
```

### Issue Hierarchy

```
Project Issue (Parent)
├── Feature Issue (User Auth)
│   ├── Task Issue (Setup Clerk)
│   ├── Task Issue (Create Login Page)
│   └── Task Issue (Add Auth Middleware)
├── Feature Issue (Dashboard)
│   ├── Task Issue (Create Layout)
│   └── Task Issue (Add Widgets)
└── ...
```

### Status Flow

```
Backlog → In Progress → Done
                    ↘ Blocked (on failure)
```

### Mapping File

All Linear IDs stored in `docs/decisions/linear-mapping.json`:

```json
{
  "projectIssueId": "ABC-123",
  "features": {
    "user-auth": {
      "issueId": "ABC-124",
      "tasks": {
        "setup-clerk": "ABC-125",
        "create-login-page": "ABC-126"
      }
    }
  }
}
```

---

## File Structure

```
project/
├── .claude/
│   ├── settings.json           # Plugins and permissions
│   ├── agents/                 # Agent definitions
│   │   ├── backend-agent.md    # Includes IMMUTABLE_DECISIONS handling
│   │   ├── frontend-agent.md   # Includes IMMUTABLE_DECISIONS handling
│   │   ├── test-agent.md       # Uses PACKAGE_MANAGER_COMMANDS
│   │   └── review-agent.md
│   └── skills/
│       └── harness/
│           └── SKILL.md        # Harness definition
│
├── .mcp.json                   # MCP servers (Linear, etc.)
│
├── docs/
│   ├── intake/
│   │   └── project-understanding.md
│   │
│   ├── summaries/              # Phase completion summaries
│   │   ├── phase-0-intake.md
│   │   ├── phase-1-techstack.md
│   │   ├── phase-2-specs.md
│   │   └── phase-3-architecture.md
│   │
│   ├── decisions/              # All decisions (JSON for querying)
│   │   ├── tech-stack.json     # Includes packageManager
│   │   ├── pm-commands.json    # Exact package manager commands
│   │   ├── linear-mapping.json
│   │   └── implementation-log.md
│   │
│   ├── specs/
│   │   ├── master-prd.md
│   │   ├── features/           # One file per feature
│   │   ├── technical-spec.md
│   │   ├── architecture-decision.md
│   │   └── task-graph.json
│   │
│   ├── context/
│   │   └── task-packets/       # Minimal context per task
│   │       ├── task-001.json   # Includes IMMUTABLE_DECISIONS
│   │       ├── task-002.json
│   │       └── ...
│   │
│   ├── artifacts/              # Agent outputs
│   │   ├── task-001/
│   │   │   ├── summary.md      # Includes validation results
│   │   │   └── files-created.json
│   │   └── ...
│   │
│   ├── review/
│   │   └── quality-report.md
│   │
│   ├── delivery/
│   │   └── handoff-summary.md  # Uses correct package manager
│   │
│   ├── errors/                 # Fix and Learn storage
│   │   ├── error-patterns.json # Learned error patterns
│   │   └── learnings.md        # Human-readable learnings log
│   │
│   ├── progress.md             # Execution log
│   ├── whycode-state.json      # State for crash recovery
│   └── blockers.md             # Failed tasks
│
├── src/                        # Your application code
├── CLAUDE.md                   # Project instructions
└── .env.local                  # API keys (gitignored)
```

---

## Commands Reference

| Command | Description |
|---------|-------------|
| `/whycode` | Start full workflow from document intake |
| `/whycode intake` | Run only document intake phase |
| `/whycode setup` | Run only tech stack setup phase |
| `/whycode spec` | Run only specification synthesis |
| `/whycode fix` | **Fix and Learn** - Analyze error, fix it, update harness to prevent recurrence |
| `/whycode fix "desc"` | Fix and Learn with issue description |
| `/implement` | Skip to implementation (requires existing specs) |
| `/compact` | Manually compact context |
| `/tasks` | View running background tasks |
| `/cancel` | Cancel current operation |

---

## Troubleshooting

### Universal Issues (All Project Types)

#### "Linear MCP not found"

Ensure `.mcp.json` exists in project root:
```json
{
  "mcpServers": {
    "linear": {
      "command": "npx",
      "args": ["-y", "mcp-remote", "https://mcp.linear.app/sse"]
    }
  }
}
```

Then restart Claude Code.

#### "Linear rate limiting"

WhyCode now creates issues sequentially with 1-second delays. If you still hit rate limits:
1. Check `docs/whycode-state.json` for progress
2. Wait a few minutes
3. Run `/whycode` to resume

#### "Wrong build system used"

This should not happen with IMMUTABLE_DECISIONS enforcement. If it does:
1. Check `docs/decisions/tech-stack.json` has correct `buildSystem`
2. Verify task packets in `docs/context/task-packets/` have correct IMMUTABLE_DECISIONS
3. Report the issue - this is a harness bug

#### "Build failing during validation"

Check the agent's summary in `docs/artifacts/task-XXX/summary.md` for validation results:
```markdown
## Validation Results
- TypeCheck: ❌ FAIL - errors in src/components/Login.tsx
- Lint: ✅ Pass
- Tests: N/A
- Build: ❌ FAIL - blocked by type errors
```

#### "Task keeps failing"

Check `docs/blockers.md` for error details. Common causes:
- Missing environment variables
- API rate limits
- Build configuration issues
- Missing dependencies

#### "Context window exceeded"

The orchestrator should auto-compact, but you can force it:
```
/compact
```

Then resume with `/implement`.

#### "Agent not using correct tools"

Verify agent definition in `.claude/agents/{agent}-agent.md` has correct `tools:` in frontmatter.

#### "Deadlock - all tasks blocked"

This means a critical task failed and blocked everything downstream. Check:
1. `docs/blockers.md` for the root cause
2. Fix the issue manually
3. Update task status in Linear
4. Re-run `/implement`

#### "App doesn't build/run after harness completes"

WhyCode runs Integration Validation before completing. If you still have issues:
1. Check `docs/delivery/handoff-summary.md` for correct run commands
2. Verify all environment variables
3. Try running build commands manually from `docs/decisions/pm-commands.json`

#### Integration issues

The tech-stack-setup-agent configures integrations during Phase 1 by fetching current documentation.

If you have integration issues:
1. Check `docs/decisions/integration-setup.md` for what was configured
2. The agent documents the source documentation it used
3. If configuration is outdated, re-run WhyCode - the agent fetches fresh docs
4. Verify environment variables are set correctly

---

### Web/JavaScript-Specific Issues

#### "Multiple lockfiles detected"

WhyCode checks for lockfile consistency. If you see this:
1. Delete all lockfiles except the one for your chosen package manager
2. Run `{pm} install` to regenerate the correct one
3. Commit the single lockfile

#### "Missing dev script" or "Command not found: dev"

WhyCode validates workspace scripts. If you see this error:
1. Check that each workspace's `package.json` has required scripts
2. For shared packages, a simple `"dev": "tsc --watch"` may be sufficient
3. Re-run WhyCode to add missing script stubs

#### "createContext only works in Client Components" (Next.js)

This is a Next.js client/server component mismatch. The component uses hooks or browser APIs without `"use client"`.

Fix: Add `"use client"` at the very top of the file (before any imports).

Check `docs/decisions/integration-setup.md` for framework-specific component rules.

#### "localStorage is not defined" / "window is not defined" (Next.js/SSR)

This usually occurs when browser APIs are accessed during server-side rendering.

Fix options:
1. Check `docs/decisions/integration-setup.md` for Node.js version-specific fixes
2. Use dynamic imports with `ssr: false` for affected components
3. Wrap browser API usage in `typeof window !== "undefined"` checks

---

### Rust/Cargo-Specific Issues

#### "cargo build failed - missing dependencies"

1. Check `Cargo.toml` has all required dependencies
2. Run `cargo update` to refresh the lockfile
3. Check for version conflicts in the error message

#### "linking failed" (C/C++ interop)

1. Ensure required system libraries are installed
2. Check `build.rs` for correct library paths
3. On macOS, may need Xcode Command Line Tools

---

### Python-Specific Issues

#### "Module not found"

1. Ensure virtual environment is activated
2. Run `pip install -r requirements.txt` or `poetry install`
3. Check Python version matches project requirements

#### "poetry.lock out of sync"

Run `poetry lock --no-update` to regenerate lockfile.

---

### C++/CMake-Specific Issues

#### "CMake configuration failed"

1. Ensure CMake is installed and in PATH
2. Check `CMakeLists.txt` for syntax errors
3. Verify all required libraries are installed

#### "Undefined symbols" during linking

1. Check library paths in CMakeLists.txt
2. Ensure all target_link_libraries are correct
3. On Windows, check Debug vs Release configuration match

---

## References

- [Claude Code: Best practices for agentic coding](https://www.anthropic.com/engineering/claude-code-best-practices)
- [Building agents with the Claude Agent SDK](https://www.anthropic.com/engineering/building-agents-with-the-claude-agent-sdk)
- [How we built our multi-agent research system](https://www.anthropic.com/engineering/multi-agent-research-system)
- [Subagents Documentation](https://docs.anthropic.com/en/docs/claude-code/sub-agents)
