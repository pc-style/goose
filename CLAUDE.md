# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This repository contains the **Autonomous Project Team System** - a sophisticated Goose-based framework that enables fully autonomous project execution using specialized AI subagents. The system takes high-level project goals and autonomously designs, orchestrates, and executes complete projects to completion.

## Essential Commands

### Running the Autonomous Project Team
```bash
# Basic execution
goose run --recipe autonomous-project-team.yaml --params project_goal="Your project description"

# With specific parameters
goose run --recipe autonomous-project-team.yaml \
  --params project_goal="Create a task management web app" \
  --params execution_mode="auto" \
  --params team_size="optimal" \
  --params output_directory="./my-project-output"
```

### Installation and Setup
```bash
# Auto-installation
./install-autonomous-team.sh

# Configure your AI provider
goose configure

# Manual Goose configuration (if needed)
export ALPHA_FEATURES=true
```

### Testing Individual Subagents
```bash
# Test project researcher
goose run --recipe subagents/project-researcher.yaml --params project_goal="Test project"

# Test code developer
goose run --recipe subagents/code-developer.yaml --params task_specification="Build a simple API"
```

## Architecture Overview

### Core Components

1. **Main Orchestrator** (`autonomous-project-team.yaml`)
   - Meta-coordinator that analyzes project goals
   - Determines optimal team composition and workflow strategy
   - Orchestrates subagent execution (sequential/parallel)
   - Aggregates outputs and ensures project completion

2. **Specialized Subagents** (`subagents/` directory)
   - **project-researcher.yaml**: Requirements analysis and technology research
   - **task-manager.yaml**: Project decomposition and execution planning  
   - **code-developer.yaml**: Implementation and coding tasks
   - **code-reviewer.yaml**: Quality assurance and security review
   - **documentation-writer.yaml**: Comprehensive documentation creation
   - **qa-specialist.yaml**: Testing and quality validation
   - **deployment-specialist.yaml**: Production deployment and CI/CD

### Execution Flow

The system follows a 5-phase execution strategy with parallel optimization:

1. **Analysis & Research**: Project researcher analyzes goals and researches technologies (sequential)
2. **Planning & Breakdown**: Task manager creates execution roadmap with dependencies (sequential)
3. **Development**: Code developer and code reviewer work in PARALLEL (reviewer works on completed components)
4. **Documentation & Testing**: Documentation writer and QA specialist run in PARALLEL for maximum efficiency
5. **Deployment & Finalization**: Deployment specialist handles production setup (sequential)

### Configuration Architecture

- **Response Schemas**: Each subagent returns structured JSON with quality metrics
- **Parameter System**: Flexible parameter passing between orchestrator and subagents  
- **Extension Integration**: Built-in developer and memory extensions for enhanced capabilities
- **MCP Integration**: Leverages Model Context Protocol servers for extended functionality

## Key Features

- **Intelligent Orchestration**: Automatically determines team composition based on project complexity
- **Parallel/Sequential Execution**: Smart workflow management with dependency tracking
- **Structured Output**: Comprehensive JSON responses with quality metrics and progress tracking
- **Quality Assurance**: Built-in code review, testing, and security validation
- **Complete Deliverables**: From requirements to deployment-ready applications

## Working with the System

### Prerequisites
- **ALPHA_FEATURES=true** must be enabled in Goose configuration
- Python 3.8+, Goose AI framework installed
- API keys for AI providers (Anthropic, OpenAI, etc.) configured
- Optional: Node.js/npm for additional MCP servers

### Project Types Supported
- Web applications (React, Vue, vanilla JS)
- REST APIs and microservices
- CLI tools and utilities
- Data analysis and visualization tools
- Python libraries and packages
- Infrastructure and deployment configurations

### Output Structure
All projects generate outputs in the specified directory containing:
- Complete source code implementation
- Comprehensive test suites
- Documentation (README, API docs, user guides)
- Configuration files (Docker, CI/CD, environment)
- Quality reports and metrics

## Important Notes

- This is a **recipe-based system** using Goose's sub_recipes functionality
- Each subagent has its own YAML specification with detailed instructions and response schemas
- The main orchestrator coordinates all subagents and aggregates their outputs
- Execution can take 2-6 hours depending on project complexity
- Monitor API usage as complex projects consume significant tokens
- All subagents support customizable parameters for fine-tuning behavior