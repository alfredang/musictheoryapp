# README Generator Skill

A Claude Code skill that generates comprehensive, professional README.md files for any project.

## Overview

This skill analyzes your project structure, detects technologies used, and generates a complete README with:

- Tech stack badges (shields.io)
- Feature descriptions
- Architecture diagrams (Mermaid)
- File structure documentation
- Step-by-step setup instructions
- Configuration tables
- API reference (if applicable)
- Testing instructions
- Deployment guides
- Live demo sections
- Contributing guidelines
- License information
- Acknowledgments

## Installation

This skill is installed globally in `~/.claude/skills/readme/` and is available across all projects.

## Usage

### Basic Usage

```
/readme
```

Generates a comprehensive README for the current project.

### With Options

```
/readme --style=minimal
/readme --style=standard
/readme --style=comprehensive
```

### Programmatic Invocation

From Claude Code, simply say:
- "Generate a readme for this project"
- "Create documentation for this repo"
- "/readme"

## Skill Structure

```
~/.claude/skills/readme/
├── skill.json          # Skill metadata and configuration
├── prompt.md           # Main skill prompt with instructions
├── README.md           # This file
├── templates/
│   ├── comprehensive.md  # Full README template
│   ├── standard.md       # Standard README template
│   └── minimal.md        # Minimal README template
└── examples/
    ├── python-fastapi-example.md
    └── react-nextjs-example.md
```

## Configuration (skill.json)

```json
{
  "name": "readme",
  "version": "1.0.0",
  "description": "Generate comprehensive README.md files",
  "triggers": ["/readme", "generate readme", "create readme"],
  "scope": "global",
  "inputs": {
    "project_path": { "default": "." },
    "style": { "enum": ["minimal", "standard", "comprehensive"] },
    "include_demo": { "default": true }
  }
}
```

## Open Standard Format

This skill follows an open standard structure:

| File | Purpose |
|------|---------|
| `skill.json` | Metadata, triggers, inputs, outputs |
| `prompt.md` | Main execution prompt |
| `README.md` | Skill documentation |
| `templates/` | Output templates by style |
| `examples/` | Example outputs |

## Generated README Sections

### Header
- Project title
- Badges (license, version, build status)
- Short description
- Quick links (demo, docs, issues)

### Tech Stack
- Auto-detected technologies
- shields.io badges with versions
- Technology table

### Architecture
- Mermaid diagrams
- System overview
- Component relationships

### Project Structure
- Directory tree
- File descriptions
- Module organization

### Getting Started
1. Prerequisites
2. Clone instructions
3. Dependency installation
4. Environment configuration
5. Database setup (if applicable)
6. Run commands

### Configuration
- Environment variables table
- Default values
- Required vs optional

### API Reference (if applicable)
- Endpoint documentation
- Request/response examples
- Parameter tables

### Testing
- Test commands
- Coverage reports
- Test types

### Deployment
- Docker instructions
- Cloud platform guides
- CI/CD integration

### Contributing
- Fork/branch workflow
- Commit guidelines
- PR process

### License & Acknowledgments
- License type and link
- Third-party credits
- Contributor thanks

## Badge Reference

The skill automatically generates appropriate badges:

```markdown
![Python](https://img.shields.io/badge/Python-3.12-3776AB?logo=python&logoColor=white)
![TypeScript](https://img.shields.io/badge/TypeScript-5.3-3178C6?logo=typescript&logoColor=white)
![React](https://img.shields.io/badge/React-18-61DAFB?logo=react&logoColor=black)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-16-4169E1?logo=postgresql&logoColor=white)
```

## Examples

See the `examples/` directory for complete README examples:

- `python-fastapi-example.md` - FastAPI microservice
- `react-nextjs-example.md` - Next.js e-commerce app

## License

MIT License

## Author

Claude Code Skills
