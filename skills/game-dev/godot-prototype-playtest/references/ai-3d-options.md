# AI 3D options and research leads

This reference helps choose what to evaluate, not what to install automatically. The descriptions below were checked against the linked first-party project pages or papers on October 14, 2026. None of these services or research systems was executed as part of this skill's validation. Availability, model releases, compute needs, terms, and export support must be rechecked before use.

## Asset-generation entry points

### Tripo
- Role: text/image/multiview-to-3D asset generation. Its developer documentation also lists mesh processing, rigging, and animation capabilities.
- Official source: https://docs.tripo3d.ai/
- The checked documentation announces API V2 support ended October 1, 2026, with V2 endpoints scheduled to retire November 1, 2026. Follow its V3 migration guidance for new integrations.
- Integration boundary: use the user's chosen service/version and inspect its actual downloaded output. Confirm API version from the selected documentation; do not mix legacy and current endpoints. Do not assume every generated mesh can use an automatic rig successfully.

### Tencent Hunyuan3D
- Role: a family of 3D-generation models/tools, including shape and texture generation; not one interchangeable installation.
- Official source: https://github.com/Tencent/Hunyuan3D-2
- The Hunyuan3D 2.0 paper: https://arxiv.org/abs/2501.12202
- Integration boundary: identify the exact model/release or hosted service first. Distinguish hosted access from local inference; establish hardware requirements and licensing from that exact release. Do not infer compatibility with a consumer GPU from an online demo.

These are alternatives at the asset-input stage, not required dependencies. A user's existing tool or manually authored mesh is equally valid. No generated asset should be called engine-ready solely because it downloaded successfully.

## Research leads: distinct jobs, not a validated pipeline

### WorldPlay2 — interactive world models
- Source: https://worldplay2.github.io/
- Describes action and semantic controls with compressed historical memory for long-horizon interactive world generation.
- Evaluate for interactive world-model experiments. Do not equate demonstrated visual consistency with deterministic gameplay state, editable scene meshes, collision geometry, or a replacement for a conventional engine.

### DistScene — compositional scene generation
- Source: https://coolbeam.github.io/DistScene/
- Describes object-to-scene distillation, shared scene generation, and object-centric refinement; the page demonstrates navigation-simulation use.
- The checked page labels code, checkpoints, and dataset as coming soon. Evaluate scene export, object separation, scale, and collision/navigation conversion before claiming a Godot or Unreal workflow. No such integration was tested here.

### CoDimRecon — simulation-oriented reconstruction
- Source: https://shuzhaoxie.github.io/CoDimRecon/
- Reconstructs multi-view observations into scenes containing rigid, articulated, and deformable objects with simulation parameters.
- The checked page says "Code Soon". Treat it as a research lead, not an available installer. Its effective simulation parameters are not measured real-world material properties. Backend-specific deformable simulation does not establish equivalent behavior in a game engine.

### GenIA — observation-aligned object reconstruction
- Source: https://facebookresearch.github.io/GenIA/
- Uses test-time input alignment with SAM3D to improve reconstruction against observed geometry and appearance; includes single-view, multi-view, and dynamic settings.
- Determine the actual output representation before proposing mesh import or rigging. A rendered splat/point-based gallery does not by itself establish a skinned game-mesh export.

### TERRA — terrain-aware musculoskeletal motion
- Source: https://cnai.epfl.ch/terra/
- Recovers support geometry from motion and performs terrain-aware retargeting/control for musculoskeletal bodies.
- Evaluate for motion/contact research, not as an assumed drop-in humanoid animation retargeter. Its anatomical/control requirements must be reconciled with the target skeleton and runtime.

### MotionSpaceFlow / MSFlow — text-to-motion
- Source: https://yu1ut.com/MSFlow-HP/
- Direct fetch returned HTTP 403; the project content was verified through its first-party page source at https://github.com/yu1ut/MSFlow-HP/blob/main/index.html.
- Generates motion directly in motion space and describes a global-coordinate variant with inference-time joint/frame constraints.
- Evaluate output skeleton, coordinate convention, timing, root travel, export conversion, and motion/data terms before using it for a game character. No Blender/Godot retargeting path was exercised here.

### FlashDexRetarget — dexterous robot manipulation
- Submitted project URL: https://holiday-robot.github.io/FlashDexRetarget/
- The submitted project page was successfully retrieved and identifies the method as dexterous robot retargeting.
- Verified paper: https://arxiv.org/abs/2610.01849
- An RL-based framework for transferring human hand-object demonstrations to dexterous robot hands.
- This is not a general full-body game-character animation retargeter. Keep it in the robotics/hand-contact research category unless a separate export/integration workflow is demonstrated.

## Asset-to-engine evaluation procedure

1. Choose a concrete output: static prop, rigged character, environment, motion clip, or interactive world-model experiment. Do not substitute one representation for another silently.
2. Record the exact provider/model release and official source; check availability, required hardware, export formats, cost, and terms. Ask before billable generation, uploading private references, or large downloads.
3. Preserve the original download. Work on a separate derivative in Blender or the target engine; do not replace the user's live asset.
4. Inspect scale, axes, topology, material/texture dependencies, silhouette, and triangle/texture budgets. Choose limits from the target device, not a universal polygon number.
5. For a character, inspect rest pose, bone mapping, weights, deformation, clip names, timing, and root motion. Approve a representative pose and short animation before bulk processing. For static props, skip rigging rather than adding it unnecessarily.
6. Add and test appropriate collision/navigation separately from appearance. Never assume a visually complete model includes usable collision or physically meaningful material settings.
7. Import into an isolated scene, inspect rendered output, then test actual movement/interactions. Record every adapter/conversion step and any unsupported feature.
8. Separate code, weights, input images, output art, and motion-data rights. Link official terms rather than inferring blanket redistribution permission. Keep private provenance out of public examples.
9. Label the result accurately: source-page reviewed, downloaded, locally executed, imported, visually inspected, or gameplay-tested. Each label requires its own evidence.

Do not advertise the linked projects as a working end-to-end chain. A real integration contribution needs compatible representations, available code/weights, resource requirements, rights review, and executed handoff tests between each stage.
