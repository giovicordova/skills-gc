# Plan: Build CLI Tool for Converting Markdown to PDF

## Context
User needs a Node.js CLI tool that converts Markdown files to styled PDFs. Should support custom CSS, headers/footers, and syntax highlighting for code blocks. For internal team use.

## Steps

### Step 1: Set Up Project Structure
- Initialize npm project with TypeScript
- Set up ESLint, Prettier, tsconfig
- Create directory structure: src/parser, src/renderer, src/cli, src/styles
- Add commander.js for CLI argument parsing

### Step 2: Build Markdown Parser
- Write a custom Markdown tokenizer that handles:
  - Headings, paragraphs, lists (ordered/unordered)
  - Bold, italic, strikethrough, inline code
  - Code blocks with language detection
  - Tables, blockquotes, horizontal rules
  - Images and links
  - Footnotes and task lists
- Create an AST (Abstract Syntax Tree) representation
- Write unit tests for each token type

### Step 3: Build HTML Renderer
- Create an AST-to-HTML converter
- Implement syntax highlighting for code blocks using a custom tokenizer:
  - Support JavaScript, TypeScript, Python, Go, Rust, Ruby, CSS, HTML, SQL
  - Build language grammars for each
  - Generate styled HTML spans with appropriate class names
- Add support for inline math and block math (LaTeX) using a custom renderer

### Step 4: Build PDF Generator
- Use puppeteer to launch headless Chrome
- Create an HTML template system with header/footer support
- Implement page numbering, table of contents generation
- Handle page breaks (avoid breaking inside code blocks, tables)
- Support custom CSS injection
- Build custom pagination logic

### Step 5: Build CLI Interface
- Parse arguments: input file, output path, CSS file, paper size
- Add --watch mode for live preview
- Add batch processing for multiple files
- Create progress bars and colored output

### Step 6: Add Styling System
- Create a default CSS theme for the PDFs
- Build a theme system supporting multiple built-in themes
- Add CSS variable support for easy customization

### Step 7: Testing and Release
- Write integration tests for the full pipeline
- Test with real-world markdown files
- Create npm package configuration
- Write README with usage examples
