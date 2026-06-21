---
name: Create GitHub README
description: Generate or update a professional GitHub README.md file following open standards with tech badges, architecture diagrams, auto-captured screenshots via Playwright MCP, setup instructions, and acknowledgements. Auto-pushes to GitHub after generation.
---

# Create GitHub README

## Command
`/readme`, `/create_github_readme`, or `create_github_readme`

## Navigate
Documentation

## Keywords
readme, github readme, create readme, generate readme, project readme, documentation, readme.md, update readme, write readme, project documentation, create github readme, create_github_readme

## Description
Generate or update a professional GitHub README.md file following open standards and best practices. If a README already exists and the user requests an update, regenerates it using the latest template including a fresh screenshot. Auto-pushes to GitHub after generation.

## Execution
This skill runs using **Claude Code with subscription plan**. Do NOT use pay-as-you-go API keys. All AI operations should be executed through the Claude Code CLI environment with an active subscription.

## Response
I'll generate (or update) a comprehensive GitHub README.md for the project, then push it to GitHub.

The README will include:

| Section | Description |
|---------|-------------|
| **Screenshot** | Auto-captured via Playwright MCP (if live site exists) |
| **Header** | Project name, badges, tagline, links |
| **About** | Project description and key features |
| **Tech Stack** | Technologies used with badges |
| **Architecture** | System diagram (ASCII art) |
| **Project Structure** | File/folder organization |
| **Getting Started** | Prerequisites, installation, running |
| **Deployment** | Docker, Hugging Face Spaces instructions |
| **Contributing** | Fork, PR workflow, discussions |
| **Developed By** | Tertiary Infotech Academy Pte. Ltd. |
| **Acknowledgements** | Credits and thanks |

## Instructions

### Pre-check: Create or Update?

Before generating, check if a `README.md` already exists:

```bash
ls README.md 2>/dev/null
```

**If README.md does NOT exist:** Proceed to create a new README from scratch (Section 0 onwards).

**If README.md already exists AND the user requests an update:**
1. Read the existing README to understand current content
2. Check if the README already contains a screenshot (see Section 0.1)
3. Regenerate the README using the latest template below, preserving project-specific details (description, features, tech stack) from the existing README
4. Only re-capture the screenshot if the README is missing one (see Section 0)
5. Overwrite the existing README.md with the updated version

When generating or updating a README, follow this open standard structure:

### 0. Screenshot Capture (Auto — Conditional)

Before generating the README, determine whether a screenshot capture is needed. A screenshot should **only** be captured when **both** conditions are met:
1. A live demo URL is available
2. The README does **not** already contain a screenshot (i.e., no `![Screenshot]` or `![screenshot]` image reference exists)

If the README already has a screenshot image reference, **skip capture entirely** and preserve the existing screenshot reference.

#### 0.1 Check for Existing Screenshot in README

If a `README.md` exists, read it and check for any of these patterns:
- `![Screenshot](screenshot.png)` or similar image markdown with "screenshot" in the alt text or path
- `![screenshot]` image references in any format
- `<img` tags referencing a screenshot file

**If a screenshot reference is found:** Skip to Section 1 — do NOT re-capture. Preserve the existing screenshot section as-is.

**If no screenshot reference is found:** Continue to Section 0.2 to detect a live URL and capture.

#### 0.2 Detect Live Demo URL

Check these sources in order:
1. User-provided URL
2. `package.json` → `homepage` field
3. Vercel project URL: `https://<project-name>.vercel.app`
4. GitHub Pages URL: `https://<owner>.github.io/<repo>/`
5. Any URL found in an existing README.md

#### 0.3 Capture Screenshot with Playwright MCP

Only execute this step if a live demo URL was found in Section 0.2 **and** no existing screenshot was detected in Section 0.1.

Use the Playwright MCP tools in this sequence:

```
1. mcp__playwright__browser_navigate → Navigate to the live demo URL
2. mcp__playwright__browser_wait_for → Wait for the page to fully load (wait a few seconds)
3. mcp__playwright__browser_take_screenshot → Take a full-page screenshot and save to project root
4. mcp__playwright__browser_close → Close the browser
```

**Playwright MCP tool calls:**
```
Tool: mcp__playwright__browser_navigate
Args: { "url": "<LIVE_DEMO_URL>" }

Tool: mcp__playwright__browser_wait_for
Args: { "time": 3 }

Tool: mcp__playwright__browser_take_screenshot
Args: { "type": "png", "filename": "screenshot.png", "fullPage": true }

Tool: mcp__playwright__browser_close
Args: {}
```

**Important:** The screenshot file will be saved relative to the current working directory. After capture, verify the file exists before referencing it in the README.

#### 0.4 Add Screenshot to README

Insert the screenshot after the header section:
```markdown
## Screenshot

![Screenshot](screenshot.png)
```

If the screenshot shows the main UI or hero section, use it. If the page requires authentication or shows a loading state, note this and skip the screenshot.

#### 0.5 If No Live URL Found

Skip screenshot capture and add a commented-out placeholder:
```markdown
## Screenshot

<!-- Add a screenshot of your app here -->
<!-- ![Screenshot](screenshot.png) -->
```

### 1. Header Section
```markdown
<div align="center">

# Project Name

[![Badge1](url)](link)
[![Badge2](url)](link)

**Tagline**

[Demo](url) · [Report Bug](url) · [Request Feature](url)

</div>
```

### 2. Required Badges
- Python version
- Framework (Chainlit)
- AI Provider (Claude/Anthropic)
- License
- Docker
- Deployment platform

### 3. About Section
- Brief description (2-3 sentences)
- Key features as bullet points or table
- Platform statistics (optional)

### 4. Tech Stack
Table format with categories:
- Frontend
- Backend
- AI/LLM
- Database
- Deployment
- Document Processing

### 5. Architecture Diagram
ASCII art showing:
- UI layer
- Application layer
- AI agents
- Data/document layer

### 6. Project Structure
```
project/
├── app.py
├── modules/
└── ...
```

### 7. Getting Started
- Prerequisites
- Clone & install steps
- Environment setup
- Run command

### 8. Deployment
- Docker instructions
- Cloud platform instructions

### 9. Contributing
- Fork instructions
- PR workflow
- Link to discussions

### 10. Footer
- Developed by: Company name
- Acknowledgements: Credits
- Call to action: Star the repo

### 11. Push to GitHub

After generating or updating the README, invoke the `/github-push` skill to push changes to GitHub.

The github-push skill will:
1. Scan for exposed secrets (mandatory security check)
2. Stage `README.md` and `screenshot.png` (if created)
3. Commit with an appropriate message (e.g., `docs: generate README` or `docs: update README to latest template`)
4. Push to the remote repository
5. Auto-configure repo description, topics, and discussions if needed

## Capabilities
- Auto-capture screenshot of live site using Playwright MCP
- Generate or update README.md following GitHub best practices
- Include technology badges with shields.io
- Create ASCII architecture diagrams
- Document file structure
- Provide multi-platform deployment instructions
- Add proper attribution and acknowledgements
- Auto-push to GitHub via `/github-push` skill after generation

## Next Steps
After running `/create_github_readme`:
1. Verify the push succeeded on GitHub
2. Review the auto-captured screenshot (screenshot.png) — replace if needed
3. Verify repo description, topics, and discussions are configured
4. Share the repository link
