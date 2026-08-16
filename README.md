> [!WARNING]
> **Archived imported upstream derivative/reference — do not use this repository for new work.**
>
> This repository was imported from the canonical [aaif-goose/goose](https://github.com/aaif-goose/goose) project (formerly `block/goose`), with shared upstream base commit [`b4ab7743297b02cf3d20e10c67a3fe8fd148afb`](https://github.com/aaif-goose/goose/commit/b4ab7743297b02cf3d20e10c67a3fe8fd148afb). The upstream project is licensed under Apache-2.0. This repository's current tree has no standalone `LICENSE` or `NOTICE` file; the imported upstream history and any notices present in that history or in individual files are preserved.
>
> **Maintained pc-style delta:** none. **Historical, unmaintained delta:** 14 commits added an Autonomous Project Team system and related installers, orchestration/subagent configuration, documentation, fixes, and cleanup; the last custom commit was 2025-08-05. There is no ongoing upstream sync, maintenance, or support here.
>
> Use [the canonical upstream](https://github.com/aaif-goose/goose) for current code, releases, issues, and security updates.

# Autonomous Project Team System

> **A revolutionary Goose-based system for fully autonomous project execution using specialized AI subagents**

## 🚀 Overview

The Autonomous Project Team system is a sophisticated framework that takes high-level project goals and autonomously designs, orchestrates, and executes complete projects to completion. Using specialized AI subagents, it can handle everything from requirements analysis to deployment.

## ✨ Key Features

- **🧠 Intelligent Orchestration**: Meta-AI coordinator that analyzes project goals and determines optimal team composition
- **👥 Specialized Subagents**: 7 expert AI agents handling different aspects of development
- **⚡ Parallel Execution**: **STRICT** parallel optimization for Phases 3 & 4 - up to 40% faster execution
- **📊 Structured Output**: Comprehensive JSON outputs with quality metrics and progress tracking
- **🔧 MCP Integration**: Leverages powerful MCP servers for extended capabilities
- **📚 Complete Documentation**: Auto-generated documentation, tests, and deployment configs

## 🏗️ System Architecture

```
Project Goal → Main Orchestrator → Specialized Subagents → Complete Project
```

### Specialized Subagents

1. **🔍 Project Researcher** - Requirements analysis and technology research
2. **📋 Task Manager** - Project decomposition and execution planning
3. **💻 Code Developer** - Implementation following best practices
4. **🔍 Code Reviewer** - Quality assurance and security review
5. **📖 Documentation Writer** - Comprehensive documentation creation
6. **🧪 QA Specialist** - Testing and quality validation
7. **🚀 Deployment Specialist** - Production deployment and CI/CD

## 🚀 Quick Start

### 1. One-Line Installation

```bash
# Install from anywhere with one command
bash <(curl -fsSL https://raw.githubusercontent.com/pc-style/goose/main/install-autonomous-team.sh)
```

### 2. Configure Your AI Provider

```bash
# Use Goose's built-in configuration
goose configure
```

### 3. Run Your First Project

```bash

goose run --recipe .goose-autonomous-team/recipes/autonomous-project-team.yaml \
  --params project_goal="Create a task management web app with React and Node.js"
```

## 📋 Prerequisites

- Python 3.8+
- Goose AI framework
- Node.js and npm
- API keys for AI providers (Anthropic, OpenAI, etc.)

## 🎯 Example Projects

### Web Application
```bash

goose run --recipe .goose-autonomous-team/recipes/autonomous-project-team.yaml \
  --params project_goal="Build a responsive e-commerce website with user authentication, product catalog, shopping cart, and payment integration"
```

### REST API
```bash

goose run --recipe .goose-autonomous-team/recipes/autonomous-project-team.yaml \
  --params project_goal="Create a RESTful API for a blog platform with user management, posts, comments, and authentication"
```

### Data Analysis Tool
```bash

goose run --recipe .goose-autonomous-team/recipes/autonomous-project-team.yaml \
  --params project_goal="Develop a Python tool for CSV data analysis with statistical computations and visualization"
```

## 🎛️ Configuration Options

| Parameter | Description | Options |
|-----------|-------------|---------|
| `project_goal` | High-level project description | Any text |
| `execution_mode` | How tasks are executed | `auto`, `sequential`, `parallel` |
| `team_size` | Number of subagents to use | `minimal`, `optimal`, `comprehensive` |
| `project_complexity` | Expected complexity level | `simple`, `medium`, `complex`, `auto-detect` |
| `output_directory` | Where to store outputs | Any valid path |

## 📊 Expected Deliverables

For each project, the system typically delivers:

- ✅ **Complete Implementation** - Fully functional code
- ✅ **Comprehensive Tests** - Unit, integration, and end-to-end tests
- ✅ **Documentation** - README, API docs, user guides
- ✅ **Quality Reports** - Code review, security analysis, performance metrics
- ✅ **Deployment Configuration** - Docker, CI/CD, infrastructure setup
- ✅ **Project Analysis** - Requirements, architecture, risk assessment

## 🔧 Advanced Features

### Dynamic Team Composition
The system intelligently selects which subagents to use based on project requirements.

### Parallel Processing
**MANDATORY** parallel execution for development and testing phases:
- **Phase 3**: Code developer + Code reviewer work simultaneously
- **Phase 4**: Documentation writer + QA specialist run concurrently
- **Result**: Up to 40% faster project completion

### Structured Output
All results are provided in structured JSON format for easy integration.

### Memory Management
Persistent context and learning across project executions.

## 📚 Documentation

- **[Complete Guide](AUTONOMOUS_PROJECT_TEAM_GUIDE.md)** - Comprehensive documentation
- **[Installation Guide](install-autonomous-team.sh)** - Auto-installation script
- **[API Reference](subagents/)** - Individual subagent specifications

## 🛠️ System Requirements

### Required
- **Goose AI Framework** - Core orchestration platform
- **Python 3.8+** - Runtime environment
- **API Keys** - For AI providers (Anthropic, OpenAI, etc.)

### Optional
- **Node.js** - For additional MCP servers
- **Docker** - For containerized deployments
- **Git** - For version control integration

## 🔑 Supported AI Providers

- **Anthropic Claude** - Recommended for complex reasoning
- **OpenAI GPT** - General-purpose performance
- **OpenRouter** - Access to multiple models

## 🚨 Important Notes

- **Alpha Features Required**: Enable `ALPHA_FEATURES=true` in Goose config (auto-handled by installer)
- **API Costs**: Monitor usage as complex projects may consume significant tokens
- **Execution Time**: Projects take 2-6 hours (40% faster with parallel execution)
- **Updates**: Re-run installer to get latest features: `bash <(curl -fsSL https://raw.githubusercontent.com/pc-style/goose/main/install-autonomous-team.sh)`

## 🤝 Contributing

We welcome contributions! See our [contribution guidelines](AUTONOMOUS_PROJECT_TEAM_GUIDE.md#contributing) for details on:

- Adding custom subagents
- Extending functionality
- Improving workflow orchestration
- Adding new integrations

## 📄 License

This system is designed to work with the Goose AI framework. Please refer to Goose's licensing terms.

## 🆘 Support

1. **Check the [Troubleshooting Guide](AUTONOMOUS_PROJECT_TEAM_GUIDE.md#troubleshooting)**
2. **Review [Configuration Settings](AUTONOMOUS_PROJECT_TEAM_GUIDE.md#configuration)**
3. **Verify Prerequisites** are properly installed
4. **Check API Key Validity** and permissions

## 🎉 Get Started

Ready to revolutionize your development workflow? 

```bash
# One command to rule them all
bash <(curl -fsSL https://raw.githubusercontent.com/pc-style/goose/main/install-autonomous-team.sh)
```

Then configure and run:

```bash
goose configure

goose run --recipe .goose-autonomous-team/recipes/autonomous-project-team.yaml \
  --params project_goal="Your amazing project idea here"
```

**Happy autonomous coding! 🚀**

---

*Built with ❤️ using [Goose AI](https://github.com/block/goose) and the Model Context Protocol*