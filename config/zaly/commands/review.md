---
description: Review current code changes
args:
  focus:
    short: f
    type: string
    default: ""
    desc: Focus of the review
  staged:
    type: boolean
    desc: Whether to review staged files only
---

Can you review my current working changes?
{{ $ }}

- Focus: {{ focus }}

```bash !
A=123
echo "{{ focus }}"
```

{{#if staged }}
!`git diff --staged`
{{else}}
!`git status -s`
{{/if}}

Thanks!
