#!/usr/bin/env bash
set -e

echo "== Autonomous Project Team Installer =="

for cmd in python3 pip3; do
  if ! command -v "$cmd" > /dev/null 2>&1; then
    echo "Error: $cmd is required but not found. Please install it and rerun this script."
    exit 1
  fi
done

if ! command -v goose > /dev/null 2>&1; then
  if command -v pipx > /dev/null 2>&1; then
    echo "Installing Goose with pipx..."
    pipx install gooseai
  else
    echo "Installing Goose with pip3 (user)..."
    pip3 install --user gooseai
  fi
else
  echo "Goose already installed."
fi

CONFIG_PATH="$HOME/.config/goose/config.yaml"
if [ -f "$CONFIG_PATH" ]; then
  if ! grep -q "ALPHA_FEATURES: true" "$CONFIG_PATH"; then
    echo "ALPHA_FEATURES: true" >> "$CONFIG_PATH"
    echo "Enabled ALPHA_FEATURES in Goose config."
  else
    echo "ALPHA_FEATURES is already enabled in Goose config."
  fi
else
  mkdir -p "$(dirname "$CONFIG_PATH")"
  echo "ALPHA_FEATURES: true" > "$CONFIG_PATH"
  echo "Created Goose config and enabled ALPHA_FEATURES."
fi

RECIPE_DIR="recipes/autonomous_project_team"
mkdir -p "$RECIPE_DIR"

cat > "$RECIPE_DIR/main.yaml" <<"EOF"
version: 1.0.0
title: Autonomous Project Team Orchestrator
authors:
  - name: Autonomous Team Template
    contact: autopm@example.com
description: Main orchestrator agent that dynamically spawns and coordinates specialized sub-agents to deliver a project end-to-end.
ALPHA_FEATURES: true
extensions:
  - type: builtin
    name: developer
    display_name: Developer
    timeout: 300
    bundled: true
  - type: builtin
    name: web_search
    display_name: Web Search
    timeout: 300
    bundled: true
  - type: builtin
    name: tavily
    display_name: Tavily Search
    timeout: 300
    bundled: true
  - type: builtin
    name: github
    display_name: GitHub
    timeout: 300
    bundled: true
  - type: builtin
    name: memory
    display_name: Memory
    timeout: 300
    bundled: true
  - type: builtin
    name: shell
    display_name: Shell
    timeout: 300
    bundled: true
parameters:
  - key: project_goal
    input_type: string
    requirement: required
    description: High-level project goal (string or path to markdown file)
    default: ""
prompt: |
  You are the Orchestrator for an autonomous project team. Your responsibilities:
  
  1. Read {{ project_goal }}. If the value is a file path, load and parse the file.
  2. Decompose the goal into sub-goals suitable for the following roles:
     • Researcher – gathers information and best practices
     • Planner – breaks the work into milestones & tasks
     • Developer – writes code / artefacts
     • Reviewer – audits code for quality & security
     • QA – designs & runs tests
     • Documentation Writer – prepares user & developer docs
  3. Spawn one subagent for each role in parallel using the corresponding recipe in recipes/autonomous_project_team/.
  4. Provide each subagent with clear context and instructions. Collect their outputs.
  5. Integrate results, resolve conflicts, reiterate by redelegating where needed, until the project is satisfied.
  6. Produce a final structured summary containing:
     - Project plan
     - Source code or diff references
     - Test results & coverage
     - Documentation links
     - Any caveats or future work
  
  Strict rules:
  • Always run subagents with ALPHA_FEATURES true and the extensions declared above.
  • Prefer parallel execution when tasks are independent. When dependencies exist, run sequentially.
  • If any subagent fails, capture the error, decide whether to retry, or surface to user.
  • Use Markdown headings and bullet lists for readability of the orchestrator’s own output.
EOF

cat > "$RECIPE_DIR/researcher.yaml" <<"EOF"
version: 1.0.0
title: Research Agent
authors:
  - name: Autonomous Team Template
    contact: autopm@example.com
description: Gathers technical and competitive intelligence, synthesises insights, risks, and recommendations.
ALPHA_FEATURES: true
extensions:
  - type: builtin
    name: developer
    display_name: Developer
    timeout: 300
    bundled: true
  - type: builtin
    name: web_search
    display_name: Web Search
    timeout: 300
    bundled: true
  - type: builtin
    name: tavily
    display_name: Tavily Search
    timeout: 300
    bundled: true
  - type: builtin
    name: github
    display_name: GitHub
    timeout: 300
    bundled: true
  - type: builtin
    name: memory
    display_name: Memory
    timeout: 300
    bundled: true
parameters:
  - key: research_goal
    input_type: string
    requirement: required
    description: Specific research question or area of focus
    default: ""
prompt: |
  You are a Research Agent. Given the objective {{ research_goal }}:
  • Perform deep web and code searches using enabled extensions.
  • Collect relevant frameworks, libraries, design patterns, prior art, and best practices.
  • Summarise findings in bullet lists with links and citations.
  • Highlight risks, unknowns, and open questions.
  • Output a concise recommendation section.
EOF

cat > "$RECIPE_DIR/planner.yaml" <<"EOF"
version: 1.0.0
title: Planning Agent
authors:
  - name: Autonomous Team Template
    contact: autopm@example.com
description: Converts project goal and research into an executable multi-phase project plan.
ALPHA_FEATURES: true
extensions:
  - type: builtin
    name: developer
    display_name: Developer
    timeout: 300
    bundled: true
  - type: builtin
    name: memory
    display_name: Memory
    timeout: 300
    bundled: true
parameters:
  - key: planning_context
    input_type: string
    requirement: required
    description: Consolidated project goal and research summary
    default: ""
prompt: |
  You are a Planning Agent. Using {{ planning_context }}:
  • Define clear milestones with deliverables and acceptance criteria.
  • Break milestones into tasks mapped to Developer, Reviewer, QA, Doc Writer.
  • Produce timeline (relative days) and dependency graph.
  • Output as Markdown checklist.
EOF

cat > "$RECIPE_DIR/developer.yaml" <<"EOF"
version: 1.0.0
title: Developer Agent
authors:
  - name: Autonomous Team Template
    contact: autopm@example.com
description: Implements tasks with production-quality, tested code.
ALPHA_FEATURES: true
extensions:
  - type: builtin
    name: developer
    display_name: Developer
    timeout: 600
    bundled: true
  - type: builtin
    name: shell
    display_name: Shell
    timeout: 600
    bundled: true
parameters:
  - key: dev_task
    input_type: string
    requirement: required
    description: Exact task specification
    default: ""
prompt: |
  You are a Developer Agent. Complete {{ dev_task }} adhering to:
  • Language & framework conventions
  • Secure coding & lint rules
  • Add inline comments and docstrings
  • Produce unit tests alongside code
  • Summarise changes and highlight assumptions
EOF

cat > "$RECIPE_DIR/reviewer.yaml" <<"EOF"
version: 1.0.0
title: Reviewer Agent
authors:
  - name: Autonomous Team Template
    contact: autopm@example.com
description: Audits code and artefacts, providing actionable review feedback.
ALPHA_FEATURES: true
extensions:
  - type: builtin
    name: developer
    display_name: Developer
    timeout: 300
    bundled: true
parameters:
  - key: review_target
    input_type: string
    requirement: required
    description: Code or file path under review
    default: ""
prompt: |
  You are a Reviewer Agent. Review {{ review_target }} for correctness, security, readability, maintainability.
  • List issues with severity tags (critical/major/minor).
  • Suggest concrete fixes.
  • Conclude with overall approval status.
EOF

cat > "$RECIPE_DIR/qa.yaml" <<"EOF"
version: 1.0.0
title: QA Agent
authors:
  - name: Autonomous Team Template
    contact: autopm@example.com
description: Designs and executes tests to ensure deliverable quality.
ALPHA_FEATURES: true
extensions:
  - type: builtin
    name: developer
    display_name: Developer
    timeout: 300
    bundled: true
  - type: builtin
    name: shell
    display_name: Shell
    timeout: 300
    bundled: true
parameters:
  - key: qa_target
    input_type: string
    requirement: required
    description: Component or path to test
    default: ""
prompt: |
  You are a QA Agent. For {{ qa_target }}:
  • Define unit, integration, and (if applicable) manual test cases.
  • Specify expected vs actual results.
  • Identify bugs and severity.
  • Provide coverage estimate and recommendations.
EOF

cat > "$RECIPE_DIR/doc_writer.yaml" <<"EOF"
version: 1.0.0
title: Documentation Writer Agent
authors:
  - name: Autonomous Team Template
    contact: autopm@example.com
description: Produces user, developer, and API documentation.
ALPHA_FEATURES: true
extensions:
  - type: builtin
    name: developer
    display_name: Developer
    timeout: 300
    bundled: true
  - type: builtin
    name: web_search
    display_name: Web Search
    timeout: 300
    bundled: true
parameters:
  - key: doc_goal
    input_type: string
    requirement: required
    description: Documentation scope or target path
    default: ""
prompt: |
  You are a Documentation Writer Agent. Produce clear, comprehensive docs for {{ doc_goal }} including setup, usage, API reference, examples, FAQ.
EOF

cat > .env.template <<"EOF"
# Provider API Keys for Goose Autonomous Project Team
# Copy this file to .env and fill in your keys
ANTHROPIC_API_KEY=
OPENAI_API_KEY=
OPENROUTER_API_KEY=
# Add other provider keys as needed
EOF

echo "Created .env.template"

mkdir -p documentation
cat > documentation/MCP_SERVERS.md <<"EOF"
# MCP Servers Used by Autonomous Project Team

The following MCP (Multi-Channel Provider) servers/extensions are used and will be auto-started by Goose as needed:

- developer
- web_search
- tavily
- github
- memory
- shell (if available)

No manual setup is required for these extensions; Goose will auto-manage them. Ensure your provider API keys are configured in .env or your environment.
EOF

echo "Created documentation/MCP_SERVERS.md"

if command -v goose > /dev/null 2>&1; then
  echo "Testing Goose installation with 'goose list-recipes'..."
  goose list-recipes | grep autonomous_project_team && echo "[OK] Recipes installed."
else
  echo "[WARN] Goose not found in PATH; skipping recipe test."
fi

echo "Autonomous Project Team installation complete!"