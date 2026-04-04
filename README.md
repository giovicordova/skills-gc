# skills-gc

Custom skills for [Claude Code](https://docs.anthropic.com/en/docs/claude-code).

Each skill is a self-contained markdown file that gives Claude specific behaviours when invoked. They work like slash commands: type `/checkpoint` and Claude follows the skill instructions instead of improvising.

## Skills

| Skill | What it does |
|-------|-------------|
| [checkpoint](checkpoint/) | Session handoff logs so the next session picks up with full context |
| [verify](verify/) | Audits Claude's output against the user's original request |
| [plan-challenger](plan-challenger/) | Stress-tests implementation plans before execution |

## Installation

```bash
# Link a single skill
ln -s /path/to/skills-gc/checkpoint ~/.claude/skills/checkpoint

# Or link all of them
for skill in checkpoint verify plan-challenger; do
  ln -s /path/to/skills-gc/$skill ~/.claude/skills/$skill
done
```

## License

MIT
