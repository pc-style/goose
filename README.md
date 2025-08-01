# Autonomous Project Team for Goose

This project provides a ready-to-use "Autonomous Project Team" system for Goose, enabling advanced project automation via a team of specialized AI agents (research, planning, coding, review, QA, documentation) orchestrated end-to-end.

## Features

- Main orchestrator recipe plus subagent recipes
- Parallel and iterative workflow
- ALPHA_FEATURES and powerful extensions enabled by default
- Easy install with one shell script

## Quickstart

1. **Run install script:**
   ```bash
   bash install_autonomous_project_team.sh
   ```
2. **Set up provider API keys:**
   - Copy `.env.template` to `.env` and fill in your keys
   - See `PROVIDER_SETUP.md` for details
3. **List and run recipes:**
   ```bash
   goose list-recipes
   goose run recipes/autonomous_project_team/main.yaml --project_goal "Build a REST API for a todo app"
   ```

## Directory Structure

- recipes/autonomous_project_team/*.yaml — Agent recipes
- documentation/MCP_SERVERS.md — MCP servers/extensions used
- .env.template — Environment variable template
- PROVIDER_SETUP.md — Provider key setup guide

## MCP Servers Used

- developer, web_search, tavily, github, memory, shell

## License

MIT (or as per your Goose project conventions)