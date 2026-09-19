# Anti-Patterns to Flag During Iteration

If you notice any of these during the conversation, name it explicitly to
the student rather than quietly steering around it. Naming it is part of
what makes this scaffold work — the goal is for the student to notice the
pattern too, not just for the output to avoid it.

## 1. Implementation-first drift

**Signal**: the student (or the conversation) moves to "let's build a main
menu" or "let's pick an engine" before a learning objective or mechanic
has been articulated.

**Response**: pause and ask what the game is supposed to teach and how,
before writing code. It's fine to sketch technical feasibility, but design
should lead implementation, not the reverse.

## 2. Extrinsic (theme-only) integration

**Signal**: the mechanic is generic (match-3, platformer jumping, trivia
quiz) and the CS concept only appears in the flavor text, item names, or
as a gate between otherwise-unrelated levels.

**Response**: ask "if you removed the theme, would the mechanic still
teach the underlying skill?" If not, push toward a mechanic that
structurally *is* the concept (see `mechanic-concept-patterns.md`).

## 3. Vague, topic-level learning objectives

**Signal**: "teaches recursion," "about Big-O," "covers sorting
algorithms" — a subject, not a capability.

**Response**: ask what the player will be able to *do* differently after
playing. Don't accept a topic name as a finished learning objective.

## 4. Speed/high-stakes mechanics for concepts that need reflection

**Signal**: a timer, a "you must decide in 3 seconds" mechanic, or
punishing hesitation, applied to a concept that actually requires the
player to stop and reason (e.g. tracing execution, comparing tradeoffs).

**Response**: ask whether urgency serves the concept or works against it.
High-stakes, low-reflection mechanics can be a great fit for some
concepts (e.g. pattern recognition under constraint) and actively
counterproductive for others (e.g. anything requiring the player to
reason step-by-step before acting).

## 5. Storyline/narrative substituting for mechanic

**Signal**: the student can describe an elaborate plot but can't say what
the player *does* moment-to-moment that relates to the concept.

**Response**: ask them to describe the core 10-second play loop, with no
reference to story. If they can't, the mechanic isn't defined yet.

## 6. Scope creep during the build phase

**Signal**: the prototype grows levels, menus, art, or sound before the
single core mechanic is confirmed to work and to teach what it's meant to.

**Response**: redirect to the smallest playable slice that tests the
mechanic. More scope can come later; it isn't needed to answer the
pedagogical question this prototype exists to answer.

## 7. Publishing without consent

**Signal**: any request or drift toward making the game publicly
reachable via a live URL.

**Response**: this scaffold's publish phase requires the AI to explicitly
ask the student before running a live-publish script, every time, even if
the student has published before in this session. Local packaging does
not require this; live publishing always does.

## 8. Embedding API keys or live API calls in the published game

**Signal**: a request for the game itself to "call AI" or "generate
questions live" while being played — e.g. fetching from the Claude API
from inside the browser game.

**Response**: redirect to generating a pool of varied content at build
time instead (see Phase 3). These games get published as static files;
anything in client-side JavaScript, including an embedded API key, is
visible to anyone who views the page source. A key embedded in a public
game is effectively a public key. The build-time content-pool approach
gives players the same variety without ever exposing credentials or
requiring the published game to make authenticated calls.

## 9. One static instance instead of repeated, varied play

**Signal**: the prototype has exactly one scenario, one set of numbers,
or one fixed instance of the mechanic — a player who plays it once has
seen everything it has to offer.

**Response**: ask whether a single playthrough gives enough exposure to
answer questions about the concept afterward. Push toward multiple
rounds/instances of the *same* mechanic with real variation between them
(see Phase 3), not toward additional, different mechanics.

## 10. Design memo as afterthought

**Signal**: treating the post-memo or reflection as a formality to fill
out quickly after the "real" work is done.

**Response**: remind the student that articulating the design in writing
is itself part of the design process, not just a report on it — this is
often where the clearest pedagogical thinking actually happens, especially
if the build phase was implementation-heavy.
