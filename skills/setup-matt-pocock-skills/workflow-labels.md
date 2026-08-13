# Workflow labels

These exact labels are part of the engineering workflow protocol. Do not rename them per repository: the skills query these strings directly.

| Label | Default color | Meaning |
| --- | --- | --- |
| `pending` | `D4C5F9` | Deferred loose end; open but outside the execution frontier |
| `grill:session` | `D4C5F9` | Standalone HITL decision session; combine with `ready-for-human` |
| `spec` | `006b75` | Approved parent implementation contract; not executable |
| `wayfinder:map` | `1d76db` | Shared Wayfinder map |
| `wayfinder:research` | `0e8a16` | AFK research decision ticket |
| `wayfinder:prototype` | `fbca04` | HITL prototype decision ticket |
| `wayfinder:grilling` | `e99695` | HITL grilling decision ticket |
| `wayfinder:task` | `c5def5` | Manual task that unblocks a decision |

`ready-for-agent`, `ready-for-human`, `needs-info`, `needs-triage`, and `wontfix` are triage roles documented separately in `triage-labels.md`.

Existing `plan` labels are legacy. Preserve them for historical issues, but do not create or apply them in the GitHub-first flow.

On a real tracker, create only missing labels and preserve compatible existing colors/descriptions. If a name already exists with an incompatible meaning, resolve that conflict before using the workflow.
