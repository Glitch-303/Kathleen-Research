# Publishing Guide

## Local packaging (default, always available)

`scripts/package-local.sh <game-name>` copies the built game into
`<game-name>/dist/` and zips it. No account, network access, or
confirmation beyond running the script is required. This is the safe
default output for every student, every time — hand this in, run it
offline, or share the zip directly with a playtester.

## Live publishing (opt-in, requires explicit confirmation)

Live publishing makes the game reachable at a public URL. **The AI must
ask the student for explicit confirmation before running either script
below**, every time, regardless of what was decided earlier in the
session. Do not treat an earlier "yes" as standing consent for a later
publish action.

### Option A: GitHub Pages (`scripts/publish-github-pages.sh`)

**Prerequisites**:
- The project folder must be a git repository with a `origin` remote
  already configured (`git remote add origin <url>`), pointing to a
  GitHub repo the student has push access to.
- `git` must be installed and authenticated (SSH key or credential
  helper).

**What the script does**: builds the game, pushes the built output to a
`gh-pages` branch, and prints the resulting `https://<user>.github.io/<repo>/`
URL. It does not create the GitHub repo for you — the student (or the AI,
with confirmation) needs to have created it first.

**Best for**: students who already use GitHub and want the game tied to
a repo they can also submit as their project artifact.

### Option B: itch.io (`scripts/publish-itch.sh`)

**Prerequisites**:
- An itch.io account and a game project page created on itch.io
  (`https://<user>.itch.io/<game-slug>`).
- The `butler` CLI installed and authenticated (`butler login`) —
  see https://itch.io/docs/butler/installing.html.

**What the script does**: builds the game and pushes it to the itch.io
project via `butler push`, tagged for HTML5 web play.

**Best for**: sharing with playtesters who aren't necessarily technical,
since itch.io pages are simple, playable links with no GitHub context
needed.

## Choosing between them

If the student doesn't have a strong preference, GitHub Pages is the
lighter-weight default for a CS student audience. itch.io is worth
suggesting if the primary audience for playtesting is non-technical peers,
since the itch.io page reads more like a normal game listing than a
developer's repo.

## What not to do

Do not run a live-publish script speculatively "to see if it works," and
do not default to publishing live just because local packaging succeeded.
Treat every live-publish action as a distinct, consequential step that
needs its own confirmation.
