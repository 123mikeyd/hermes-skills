# hermes-skills

Custom skills for [Hermes Agent](https://github.com/NousResearch/hermes-agent) by 123mikeyd.

## Skills

### creative/meme-generation
Generate memes using template APIs, custom Pillow compositing, or AI-generated art. Features advanced avatar compositing with alpha channel background removal, angled projectile text labeling, and Nous Research team assets.

**Authors:** adanaleycio, mikeyd, hermes-agent

### skills/game-dev/godot-prototype-playtest

Build small Godot prototypes and hand them off with honest playtest evidence. Includes a scope-first workflow, save-isolation checks, a playtest report template, and an original headless state-transition example with explicit pass/fail exits.

An optional research reference covers Tripo, Hunyuan3D, and emerging world/scene/motion projects. Those projects are source-reviewed leads, not locally tested integrations or a verified end-to-end pipeline.

**Authors:** Mike (123mikeyd), Hermes Agent. **License:** MIT for this skill and its original example; this does not relicense other skills or linked projects.

**Example validation:** Godot 4.7.2 on Windows 11; 30 state checks passed, and the intentional failure exited nonzero. Not a visual, physics, keyboard, or full-game playtest. Other hosts are untested.

## Installation

Inspect and install the Godot skill through Hermes Skills Hub:

```bash
hermes skills inspect 123mikeyd/hermes-skills/skills/game-dev/godot-prototype-playtest
hermes skills install 123mikeyd/hermes-skills/skills/game-dev/godot-prototype-playtest
```

Optional: add the repository as a community source for skills under `skills/`:

```bash
hermes skills tap add 123mikeyd/hermes-skills
```

This is an independent community contribution, not an official bundled Hermes skill. Review the security scan before installing. The older creative skill remains at its original path and can be copied manually; it was not modified by this addition.

Try: “Use godot-prototype-playtest to prepare a tiny checkpoint-and-collectible demo. Preserve my existing project and clearly separate automated checks from actual playtesting.”
