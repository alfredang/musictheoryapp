# Examples

## Trigger Phrases
- "/create_github_readme"
- "create github readme"
- "generate readme with screenshot"
- "create readme for my project"

## Example Prompts

### Basic Usage
```
User: I want to create github readme
```

### With Context
```
User: Can you help me create github readme for my course?
```

### With Live Site Screenshot
```
User: Create a readme for my project, the live site is at https://my-app.vercel.app

Claude: I'll generate a comprehensive GitHub README.md for your project.

First, let me capture a screenshot of your live site...

Navigating to https://my-app.vercel.app...
Screenshot captured and saved as screenshot.png

Now generating the README with:
- Auto-captured screenshot from live site
- Project header with badges
- About section with key features
- Tech stack table
- Architecture diagram
- Getting started guide
- Contributing guidelines

README.md created with screenshot.png embedded!
```

### Screenshot Auto-detected from package.json
```
User: /create_github_readme

Claude: I'll generate a comprehensive GitHub README.md for your project.

Detected live site URL from package.json homepage: https://user.github.io/my-app/

Capturing screenshot via Playwright MCP...
Screenshot saved as screenshot.png

Generating README.md...
Done! Screenshot embedded as ![Screenshot](screenshot.png)
```

### No Live Site Available
```
User: create readme for my cli tool

Claude: I'll generate a comprehensive GitHub README.md for your project.

No live demo URL detected — skipping screenshot capture.
Added a placeholder comment in the README for you to add a screenshot later.

Generating README.md...
Done!
```

## Expected Response
See SKILL.md for the standard response template.
