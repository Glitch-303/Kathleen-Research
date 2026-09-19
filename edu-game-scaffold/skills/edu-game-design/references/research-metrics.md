# Extracting Process Metrics from Session Logs (For the Researcher)

Pi logs every session as a timestamped event stream to disk — you don't
need to instrument the scaffold or ask the AI to self-report timing. This
keeps the metric objective and keeps the conversation itself uninstrumented
and natural, per the "stay conversational" guidance elsewhere in this
skill.

## Where sessions live

Pi stores sessions outside the project folder, not inside it: by default
at `~/.pi/agent/sessions/` (or under `$PI_CODING_AGENT_DIR` if that's
set), in a subfolder keyed by the encoded absolute path of the working
directory the session was run from. This is a real detail to get right —
`package-local.sh` now bundles each game's transcript automatically (see
Phase 6 of SKILL.md), using either an explicit session path passed to it
or a best-effort guess at this default location. Confirm this is actually
working with a real test run before event day — pi's internal path
encoding is the kind of detail that could change between versions.

```bash
pi config          # shows settings paths
```

Sessions are typically stored as JSONL (one JSON event per line), with
each event carrying a timestamp. Open one after a test run to
see the actual field names in your installed version:

```bash
find . -name "*.jsonl" -newer <some marker file>
```

## Metric: time from session start to first code-writing action

1. Find the timestamp of the session's first event (session start / first
   user message).
2. Find the timestamp of the first tool call that writes or edits a file
   under `src/` (i.e., the first actual code change, as opposed to reading,
   asking questions, or running `init-project.sh` to scaffold the empty
   template — scaffolding the template isn't "writing code," it's just
   creating the placeholder files).
3. The difference is your "time in design conversation before first code"
   metric, per student, with no subjective judgment involved.

## Why this is better than asking the AI to log it

Asking the model to narrate or log its own phase transitions reintroduces
the exact "narrating the scaffold" problem this skill otherwise avoids —
and self-reported timestamps from inside a conversation are less reliable
than the tool-call timestamps pi already records independently of what the
model says about itself.

## Collecting this on event day

Make sure each student's project folder (and therefore its session log)
ends up somewhere you can collect it — a shared drive, a git repo, or a
USB handoff — the same way you're already collecting memos and packaged
game builds. No separate collection step is needed if the session log
lives alongside the project folder by default.
