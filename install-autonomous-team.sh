#!/bin/bash

# Autonomous Project Team - Auto-Installation Script
# This script sets up the complete Goose-based Autonomous Project Team system

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
INSTALL_DIR="$HOME/.goose-autonomous-team"
RECIPES_DIR="$INSTALL_DIR/recipes"
SUBAGENTS_DIR="$RECIPES_DIR/subagents"

# Print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "\n${BLUE}================================================${NC}"
    echo -e "${BLUE} $1 ${NC}"
    echo -e "${BLUE}================================================${NC}\n"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check prerequisites
check_prerequisites() {
    print_header "CHECKING PREREQUISITES"
    
    local missing_deps=()
    
    # Check Python 3
    if ! command_exists python3; then
        missing_deps+=("python3")
        print_error "Python 3 is not installed"
    else
        python_version=$(python3 --version | cut -d' ' -f2)
        print_success "Python 3 found: $python_version"
    fi
    
    # Check pip3
    if ! command_exists pip3; then
        missing_deps+=("pip3")
        print_error "pip3 is not installed"
    else
        print_success "pip3 found"
    fi
    
    # Check uv (Python package installer)
    if ! command_exists uv; then
        print_warning "uv not found - will install it"
        curl -LsSf https://astral.sh/uv/install.sh | sh
        export PATH="$HOME/.cargo/bin:$PATH"
        if command_exists uv; then
            print_success "uv installed successfully"
        else
            print_error "Failed to install uv"
            missing_deps+=("uv")
        fi
    else
        print_success "uv found"
    fi
    
    # Check Goose
    if ! command_exists goose; then
        print_error "Goose is not installed"
        print_status "Please install Goose first: https://github.com/block/goose"
        print_status "Quick install: pip install goose-ai"
        missing_deps+=("goose")
    else
        goose_version=$(goose --version 2>/dev/null || echo "unknown")
        print_success "Goose found: $goose_version"
    fi
    
    # Check Node.js and npm (for some MCP servers)
    if ! command_exists node; then
        print_warning "Node.js not found - some MCP servers may not work"
    else
        node_version=$(node --version)
        print_success "Node.js found: $node_version"
    fi
    
    if ! command_exists npm; then
        print_warning "npm not found - some MCP servers may not work"
    else
        npm_version=$(npm --version)
        print_success "npm found: $npm_version"
    fi
    
    if [ ${#missing_deps[@]} -gt 0 ]; then
        print_error "Missing required dependencies: ${missing_deps[*]}"
        print_status "Please install the missing dependencies and run this script again"
        exit 1
    fi
    
    print_success "All prerequisites satisfied!"
}

# Enable ALPHA_FEATURES in Goose config
enable_alpha_features() {
    print_header "ENABLING ALPHA FEATURES"
    
    local config_dir="$HOME/.config/goose"
    local config_file="$config_dir/config.yaml"
    
    # Create config directory if it doesn't exist
    mkdir -p "$config_dir"
    
    # Check if config file exists
    if [ ! -f "$config_file" ]; then
        print_status "Creating new Goose config file"
        cat > "$config_file" << 'EOF'
# Goose Configuration
ALPHA_FEATURES: true

# Model Configuration (update with your preferred provider)
# GOOSE_PROVIDER: "anthropic"
# GOOSE_MODEL: "claude-3.5-sonnet"

# Extensions Configuration
extensions:
  developer:
    bundled: true
    enabled: true
    name: developer
    timeout: 600
    type: builtin
  
  memory:
    bundled: true
    enabled: true
    name: memory
    timeout: 300
    type: builtin
EOF
        print_success "Created new Goose config with ALPHA_FEATURES enabled"
    else
        # Check if ALPHA_FEATURES is already enabled
        if grep -q "ALPHA_FEATURES: true" "$config_file"; then
            print_success "ALPHA_FEATURES already enabled in config"
        else
            # Add ALPHA_FEATURES to existing config
            print_status "Adding ALPHA_FEATURES to existing config"
            if grep -q "ALPHA_FEATURES:" "$config_file"; then
                # Replace existing ALPHA_FEATURES line
                sed -i 's/ALPHA_FEATURES:.*/ALPHA_FEATURES: true/' "$config_file"
            else
                # Add ALPHA_FEATURES at the beginning
                echo -e "# Alpha Features\nALPHA_FEATURES: true\n\n$(cat $config_file)" > "$config_file"
            fi
            print_success "ALPHA_FEATURES enabled in existing config"
        fi
    fi
    
    # Also set environment variable for current session
    export ALPHA_FEATURES=true
    print_success "ALPHA_FEATURES environment variable set for current session"
}

# Create installation directory structure
create_directories() {
    print_header "CREATING DIRECTORY STRUCTURE"
    
    print_status "Creating installation directories..."
    mkdir -p "$INSTALL_DIR"
    mkdir -p "$RECIPES_DIR"
    mkdir -p "$SUBAGENTS_DIR"
    mkdir -p "$INSTALL_DIR/examples"
    mkdir -p "$INSTALL_DIR/docs"
    
    print_success "Directory structure created at: $INSTALL_DIR"
}

# Copy recipe files
install_recipes() {
    print_header "INSTALLING RECIPE FILES"
    
    # Check if we're running from the source directory
    if [ -f "autonomous-project-team.yaml" ]; then
        print_status "Copying recipe files from current directory..."
        
        # Copy main orchestrator recipe
        cp "autonomous-project-team.yaml" "$RECIPES_DIR/"
        print_success "Main orchestrator recipe installed"
        
        # Copy subagent recipes
        if [ -d "subagents" ]; then
            cp -r subagents/* "$SUBAGENTS_DIR/"
            print_success "Subagent recipes installed"
        else
            print_error "Subagents directory not found"
            return 1
        fi
        
    else
        print_status "Creating recipe files from templates..."
        
        # We'll create the recipes here if not running from source
        # This is a fallback - normally recipes should be copied from source
        print_warning "Recipe source files not found - creating minimal templates"
        
        # Create a basic main recipe template
        cat > "$RECIPES_DIR/autonomous-project-team.yaml" << 'EOF'
version: "1.0.0"
title: "Autonomous Project Team - Main Orchestrator"
description: "Meta-orchestrator for autonomous project execution"
instructions: |
  You are the Meta-Orchestrator of an Autonomous Project Team system.
  Analyze project goals and coordinate specialized subagents.

parameters:
  - key: project_goal
    input_type: string
    requirement: required
    description: "High-level project goal or description"

extensions:
  - type: builtin
    name: developer
    timeout: 600
    bundled: true

prompt: |
  Execute this project autonomously: {{ project_goal }}
EOF
        
        print_success "Basic recipe template created"
    fi
}

# Install MCP servers
install_mcp_servers() {
    print_header "INSTALLING MCP SERVERS"
    
    print_status "Installing essential MCP servers..."
    
    # Install web search capabilities
    print_status "Installing Tavily MCP server..."
    if command_exists npm; then
        npm install -g tavily-mcp || print_warning "Failed to install tavily-mcp"
    fi
    
    # Install fetch server
    print_status "Installing Fetch MCP server..."
    if command_exists uv; then
        uv tool install mcp-server-fetch || print_warning "Failed to install mcp-server-fetch"
    fi
    
    # Install knowledge graph memory
    print_status "Installing Knowledge Graph Memory MCP server..."
    if command_exists npm; then
        npm install -g @modelcontextprotocol/server-memory || print_warning "Failed to install server-memory"
    fi
    
    print_success "MCP servers installation completed"
    print_warning "Note: Some MCP servers may require API keys to function properly"
}

# Create environment template
create_env_template() {
    print_header "CREATING ENVIRONMENT TEMPLATE"
    
    cat > "$INSTALL_DIR/.env.template" << 'EOF'
# Autonomous Project Team - Environment Configuration Template
# Copy this file to .env and fill in your API keys

# =============================================================================
# AI PROVIDER CONFIGURATION
# =============================================================================

# Anthropic (Claude)
# Get your API key from: https://console.anthropic.com/
ANTHROPIC_API_KEY=your_anthropic_api_key_here

# OpenAI (GPT)
# Get your API key from: https://platform.openai.com/api-keys
OPENAI_API_KEY=your_openai_api_key_here

# OpenRouter (Multiple models)
# Get your API key from: https://openrouter.ai/keys
OPENROUTER_API_KEY=your_openrouter_api_key_here

# =============================================================================
# MCP SERVER CONFIGURATION
# =============================================================================

# Tavily Search API
# Get your API key from: https://tavily.com/
TAVILY_API_KEY=your_tavily_api_key_here

# GitHub Personal Access Token
# Create at: https://github.com/settings/tokens
GITHUB_PERSONAL_ACCESS_TOKEN=your_github_token_here

# =============================================================================
# OPTIONAL INTEGRATIONS
# =============================================================================

# Figma Access Token (for design integration)
FIGMA_ACCESS_TOKEN=your_figma_token_here

# Cloudflare API Token (for infrastructure management)
CLOUDFLARE_API_TOKEN=your_cloudflare_token_here

# MongoDB Connection String (for database integration)
MONGODB_CONNECTION_STRING=mongodb://localhost:27017/your_database

# =============================================================================
# GOOSE CONFIGURATION
# =============================================================================

# Enable alpha features (required for subagents)
ALPHA_FEATURES=true

# Default provider and model
GOOSE_PROVIDER=anthropic
GOOSE_MODEL=claude-3.5-sonnet

# Execution mode
GOOSE_MODE=smart_approve

# Maximum turns
GOOSE_MAX_TURNS=100
EOF
    
    print_success "Environment template created at: $INSTALL_DIR/.env.template"
}

# Create documentation
create_documentation() {
    print_header "CREATING DOCUMENTATION"
    
    # Create main README
    cat > "$INSTALL_DIR/README.md" << 'EOF'
# Autonomous Project Team System

A comprehensive Goose-based system for autonomous project execution using specialized AI subagents.

## Quick Start

1. **Set up environment variables:**
   ```bash
   cp .env.template .env
   # Edit .env with your API keys
   ```

2. **Run a project:**
   ```bash
   goose run --recipe recipes/autonomous-project-team.yaml \
     --params project_goal="Create a simple web application for task management"
   ```

## System Architecture

The Autonomous Project Team consists of specialized subagents:

- **Project Researcher**: Analyzes requirements and researches technologies
- **Task Manager**: Breaks down projects into manageable tasks
- **Code Developer**: Implements solutions following best practices
- **Code Reviewer**: Reviews code quality and security
- **Documentation Writer**: Creates comprehensive documentation
- **QA Specialist**: Tests functionality and validates requirements
- **Deployment Specialist**: Handles deployment and production setup

## Configuration

### AI Providers

The system supports multiple AI providers. Configure your preferred provider in the `.env` file:

- **Anthropic Claude**: Best for complex reasoning and code generation
- **OpenAI GPT**: Good general-purpose performance
- **OpenRouter**: Access to multiple models through one API

### MCP Servers

The system uses various MCP servers for extended capabilities:

- **Developer Tools**: Built-in file operations and shell commands
- **Memory**: Persistent context and information storage
- **Web Search**: Research capabilities via Tavily
- **GitHub**: Repository management and operations

## Usage Examples

### Simple Web Application
```bash
goose run --recipe recipes/autonomous-project-team.yaml \
  --params project_goal="Build a React todo app with local storage"
```

### API Development
```bash
goose run --recipe recipes/autonomous-project-team.yaml \
  --params project_goal="Create a REST API for user management with authentication"
```

### Data Analysis Tool
```bash
goose run --recipe recipes/autonomous-project-team.yaml \
  --params project_goal="Build a Python script to analyze CSV data and generate reports"
```

## Troubleshooting

### Common Issues

1. **ALPHA_FEATURES not enabled**: Ensure `ALPHA_FEATURES=true` in your config
2. **Missing API keys**: Check your `.env` file configuration
3. **MCP server errors**: Verify MCP servers are installed correctly

### Getting Help

- Check the documentation in the `docs/` directory
- Review example projects in the `examples/` directory
- Ensure all prerequisites are installed

## Advanced Configuration

### Custom Subagents

You can create custom subagents by adding new recipe files to the `recipes/subagents/` directory.

### Team Composition

Modify the main orchestrator recipe to customize which subagents are used for different project types.

### Execution Strategies

Configure parallel vs sequential execution based on your project requirements.
EOF
    
    # Create provider setup guide
    cat > "$INSTALL_DIR/docs/provider-setup-guide.md" << 'EOF'
# AI Provider Setup Guide

This guide covers setting up various AI providers for the Autonomous Project Team system.

## Anthropic Claude

### Getting Started
1. Visit [Anthropic Console](https://console.anthropic.com/)
2. Sign up or log in to your account
3. Navigate to API Keys section
4. Create a new API key
5. Copy the key to your `.env` file as `ANTHROPIC_API_KEY`

### Recommended Models
- **claude-3.5-sonnet**: Best for complex reasoning and code generation
- **claude-3-haiku**: Fast and cost-effective for simpler tasks

### Configuration
```bash
GOOSE_PROVIDER=anthropic
GOOSE_MODEL=claude-3.5-sonnet
ANTHROPIC_API_KEY=your_key_here
```

## OpenAI GPT

### Getting Started
1. Visit [OpenAI Platform](https://platform.openai.com/)
2. Sign up or log in to your account
3. Go to API Keys section
4. Create a new secret key
5. Copy the key to your `.env` file as `OPENAI_API_KEY`

### Recommended Models
- **gpt-4**: Best overall performance
- **gpt-4-turbo**: Faster with good performance
- **gpt-3.5-turbo**: Cost-effective option

### Configuration
```bash
GOOSE_PROVIDER=openai
GOOSE_MODEL=gpt-4
OPENAI_API_KEY=your_key_here
```

## OpenRouter

### Getting Started
1. Visit [OpenRouter](https://openrouter.ai/)
2. Sign up for an account
3. Go to Keys section
4. Create a new API key
5. Copy the key to your `.env` file as `OPENROUTER_API_KEY`

### Benefits
- Access to multiple models through one API
- Competitive pricing
- Model routing and fallbacks

### Configuration
```bash
GOOSE_PROVIDER=openrouter
GOOSE_MODEL=anthropic/claude-3.5-sonnet
OPENROUTER_API_KEY=your_key_here
```

## Cost Optimization Tips

1. **Use appropriate models**: Don't use expensive models for simple tasks
2. **Set context limits**: Configure `GOOSE_MAX_TURNS` to control conversation length
3. **Monitor usage**: Regularly check your API usage and costs
4. **Use caching**: Enable response caching where available

## Troubleshooting

### Authentication Errors
- Verify API key is correct and not expired
- Check if your account has sufficient credits
- Ensure the model you're requesting is available

### Rate Limiting
- Implement retry logic with exponential backoff
- Consider using multiple API keys for higher throughput
- Switch to models with higher rate limits

### Model Availability
- Some models may be temporarily unavailable
- Have fallback models configured
- Check provider status pages for outages
EOF
    
    print_success "Documentation created"
}

# Create example projects
create_examples() {
    print_header "CREATING EXAMPLE PROJECTS"
    
    # Example 1: Simple web app
    cat > "$INSTALL_DIR/examples/web-app-example.md" << 'EOF'
# Example: Simple Web Application

This example demonstrates creating a simple web application using the Autonomous Project Team.

## Project Goal
"Create a responsive task management web application with the following features:
- Add, edit, and delete tasks
- Mark tasks as complete/incomplete
- Filter tasks by status (all, active, completed)
- Local storage persistence
- Clean, modern UI design
- Mobile-friendly responsive layout"

## Command
```bash
goose run --recipe recipes/autonomous-project-team.yaml \
  --params project_goal="Create a responsive task management web application with add/edit/delete tasks, completion status, filtering, local storage, and modern mobile-friendly UI"
```

## Expected Deliverables
- HTML/CSS/JavaScript implementation
- Responsive design
- Local storage functionality
- Comprehensive documentation
- Testing suite
- Deployment instructions

## Estimated Time
2-4 hours depending on complexity and team configuration
EOF
    
    # Example 2: API development
    cat > "$INSTALL_DIR/examples/api-example.md" << 'EOF'
# Example: REST API Development

This example shows how to create a REST API using the Autonomous Project Team.

## Project Goal
"Build a RESTful API for a book library management system with:
- User authentication and authorization
- CRUD operations for books and authors
- Search functionality
- Data validation and error handling
- API documentation
- Unit and integration tests
- Docker containerization"

## Command
```bash
goose run --recipe recipes/autonomous-project-team.yaml \
  --params project_goal="Build a RESTful API for book library management with user auth, CRUD operations, search, validation, documentation, tests, and Docker containerization"
```

## Expected Deliverables
- Complete API implementation
- Authentication system
- Database integration
- API documentation
- Test suite
- Docker configuration
- Deployment guide

## Estimated Time
4-6 hours for full implementation
EOF
    
    print_success "Example projects created"
}

# Run optional test
run_test() {
    print_header "RUNNING SYSTEM TEST"
    
    read -p "Would you like to run a quick system test? (y/N): " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_status "Running system test..."
        
        # Test basic Goose functionality
        if command_exists goose; then
            print_status "Testing Goose installation..."
            goose --version >/dev/null 2>&1 && print_success "Goose test passed" || print_error "Goose test failed"
        fi
        
        # Test recipe validation
        print_status "Validating main recipe..."
        if [ -f "$RECIPES_DIR/autonomous-project-team.yaml" ]; then
            # Basic YAML validation (if yq is available)
            if command_exists yq; then
                yq eval '.' "$RECIPES_DIR/autonomous-project-team.yaml" >/dev/null 2>&1 && \
                    print_success "Recipe validation passed" || \
                    print_warning "Recipe validation failed - but this might be okay"
            else
                print_success "Recipe file exists (yq not available for validation)"
            fi
        else
            print_error "Main recipe file not found"
        fi
        
        print_success "System test completed"
    else
        print_status "Skipping system test"
    fi
}

# Main installation function
main() {
    print_header "AUTONOMOUS PROJECT TEAM INSTALLER"
    echo "This script will install and configure the complete Goose-based"
    echo "Autonomous Project Team system on your machine."
    echo
    
    # Run installation steps
    check_prerequisites
    enable_alpha_features
    create_directories
    install_recipes
    install_mcp_servers
    create_env_template
    create_documentation
    create_examples
    run_test
    
    # Final success message
    print_header "INSTALLATION COMPLETE!"
    echo
    print_success "Autonomous Project Team system installed successfully!"
    echo
    print_status "Installation location: $INSTALL_DIR"
    print_status "Next steps:"
    echo "  1. Copy and configure environment variables:"
    echo "     cp $INSTALL_DIR/.env.template $INSTALL_DIR/.env"
    echo "     # Edit .env with your API keys"
    echo
    echo "  2. Run your first autonomous project:"
    echo "     cd $INSTALL_DIR"
    echo "     goose run --recipe recipes/autonomous-project-team.yaml \\"
    echo "       --params project_goal=\"Your project description here\""
    echo
    echo "  3. Check the documentation:"
    echo "     cat $INSTALL_DIR/README.md"
    echo "     cat $INSTALL_DIR/docs/provider-setup-guide.md"
    echo
    print_status "Happy autonomous coding! 🚀"
}

# Run main function
main "$@"