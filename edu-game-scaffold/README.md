# edu-game-scaffold

A pi package containing a constructionist design scaffold for AI-assisted
educational game design. Guides a student through learning design, mechanic
design, an AI-assisted Phaser 3 prototype build, a pedagogical self-check,
and publishing (local always, live optional with explicit confirmation).

This extends the `skills.md` scaffold used in *A Constructionist Scaffold
for AI-Assisted Educational Game Design in Undergraduate Computer Science*
with a build phase and a publish phase, so the same design reasoning the
original scaffold produced can now carry through to a working, shareable
artifact.

## Install

Local install (for testing/development). Unzip this package first, then
`cd` into the extracted folder and install from the current directory —
this avoids path-name mixups from how different zip tools name the
extracted folder:

```bash
cd edu-game-scaffold
pi install .
```

Or, once pushed to a git repo:

```bash
pi install git:github.com/<you>/edu-game-scaffold
```

Or try it without installing, from inside the extracted folder:

```bash
pi -e .
```

## What's included

```
edu-game-scaffold/
├── package.json                     # pi manifest
└── skills/
    └── edu-game-design/
        ├── SKILL.md                 # the scaffold itself (6 phases)
        ├── references/
        │   ├── mechanic-concept-patterns.md   # intrinsic vs extrinsic integration
        │   ├── anti-patterns.md               # what to flag during iteration
        │   └── publishing-guide.md            # prerequisites for each publish option
        ├── scripts/
        │   ├── init-project.sh                # scaffold a Phaser 3 project
        │   ├── package-local.sh                # zip a local, offline build
        │   ├── publish-github-pages.sh         # live publish via GitHub Pages
        │   └── publish-itch.sh                 # live publish via itch.io (butler)
        └── assets/
            └── template/                        # minimal Phaser 3 starter copied by init-project.sh
```

## Usage

Once installed, the skill is discoverable automatically (`edu-game-design`)
or can be forced with `/skill:edu-game-design` in a Pi session. Point a
student at a Pi session with this package installed and let the scaffold
guide the conversation from concept pitch through to a packaged (and
optionally published) prototype.

## Prerequisites for students/researchers

- Node.js + npm (for `npx serve` and the Phaser CDN-based template — no
  build step required, so no bundler install needed)
- `zip` (packaging)
- For live publish only: `git` + a GitHub remote (GitHub Pages option), or
  the `butler` CLI + an itch.io account (itch.io option)

## Notes for research use

- Local packaging (`package-local.sh`) never requires network access or
  confirmation — it's the safe default output for every participant.
- Live publishing is gated: the SKILL.md instructs the AI to ask for
  explicit, per-action confirmation before running either publish script,
  regardless of earlier consent in the same session.
- The template's `MainScene.js` and `README.md` are stamped with the
  concept description passed to `init-project.sh`, so the pedagogical
  intent stays attached to the code, not just the design memo.
