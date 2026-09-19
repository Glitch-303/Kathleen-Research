# Mechanic–Concept Integration Patterns

## Intrinsic vs. extrinsic integration

**Extrinsic (theme-only) integration**: the game mechanic is generic, and
the CS concept is bolted on as flavor or a gate to progress. Example:
"answer a multiple-choice question about hash tables to open the next
door." The player's actual moment-to-moment actions (navigate, click,
choose) have no structural relationship to hashing. This is sometimes
called "chocolate-covered broccoli" — the concept is still just being
studied, wrapped in a game-shaped wrapper.

**Intrinsic integration**: the mechanic itself *is* an instance of the
concept. The player's actions are structurally the thing being taught.
Example: a tower-defense game where enemy waves mutate in ways that
force the player's defense strategy to generalize rather than memorize a
fixed pattern — the core loop **is** the overfitting/generalization
tradeoff, not a quiz about it.

Intrinsic integration is almost always the stronger pedagogical choice.
It's also harder to design, which is exactly why this scaffold spends two
full phases on it before any code gets written.

## Topic-level vs. capability-level learning objectives

**Topic-level** (weak): "the game teaches recursion." "the game is about
Big-O." "the game covers git commands." These name a subject, not a
change in the player.

**Capability-level** (strong): "the player will be able to predict what a
recursive call returns before it returns." "the player will be able to
compare two algorithms' growth rates and predict which wins at scale."
"the player will leave with working knowledge of git status/add/commit
well enough to recover from a merge conflict."

Push every learning objective from topic-level to capability-level before
leaving Phase 1. Ask: "after playing, what will the player be able to *do*
that they couldn't before?"

## Misconception-targeting

Novice designers often default to "students find X confusing" without
naming *what* the confusion actually is. Push further:

- Is it a **procedural** misconception (they follow the wrong steps)?
- Is it a **conceptual** misconception (they have the wrong mental model)?
- Is it a **transfer** failure (they understand it in one context but not
  a slightly different one)?

Naming the misconception precisely is what lets a mechanic actually target
it, rather than just present the correct information again in a different
format.

## A useful test

For any proposed mechanic, ask: "If I removed the CS theme and left only
the mechanic, would it still teach the underlying skill or pattern?" If
yes, integration is likely intrinsic. If the mechanic becomes meaningless
or arbitrary without the theme, it's likely extrinsic.
