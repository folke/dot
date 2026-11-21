---
description: Test command template interpolation
model: gpt-5.5
args:
  focus:
    short: f
    type: string
    desc: Focus of the review
  model:
    default: gpt-5.5
    type: string
    desc: Model to use for review
  staged:
    type: boolean
    desc: Whether to review staged files only
---

# Review

Review $@ with $model.

- Focus: ${focus}
- Staged: $staged
- First file: $1
- All argv: $*
- Home from env: $HOME
- Unknown stays: $missing
