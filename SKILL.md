---
name: visual-prompt-engine
description: Deterministic cinematographic prompt engine that turns a scene idea, script beat, emotion or brand brief into precise, camera-telemetry image and video prompts (Midjourney, Stable Diffusion/SDXL/ComfyUI, Flux, DALL-E/GPT-Image, Imagen, Ideogram, Runway, Kling, Veo, Sora, Pika, Luma). Uses an 8-slot syntax matrix (framing, camera geometry, subject blocking, Z-depth, lighting, atmosphere, optics, sensor/film/grade), positional token weighting, an emotion-to-optics dictionary, negative prompts, multi-shot character/continuity locks and ControlNet conditioning recipes. Use this whenever the user wants an AI image or video prompt, a keyframe, a storyboard shot list, a poster/thumbnail/ad visual, a cinematic look, a character sheet, a consistent character across shots, or asks to make a prompt "more cinematic", "more realistic", "better framed" or "like a film still" — even if they never say "prompt engineering".
---

# Visual Prompt Engine

Turn vague visual intent ("an epic hero shot", "a lonely woman at night") into a **locked master keyframe**: a prompt where every visual decision a cinematographer would make is stated as concrete physical telemetry rather than adjectives. Models render nouns, numbers and physical relationships far more reliably than words like "cinematic", "epic" or "beautiful" — so the whole engine exists to replace mood words with measurable camera, light and lens values.

## Reference library (read only what the job needs)

| File | Contents | Read when |
|---|---|---|
| `references/stage1-composition-camera-lighting.md` | Stage 1: shot scale (18 steps), multi-subject ratios, coverage, anatomical cut-lines, 39 aspect ratios, pitch/elevation/yaw/roll, vanishing points, rigs, grids, lead/headroom, Z-depth staging, continuity laws, Gestalt, light rig roles, contrast ratios & IRE zones, facial lighting geometries, light quality/volumetrics, Kelvin & colour harmony | Choosing Slots 1–6 values beyond the defaults below |
| `references/stage2-optics-sensor-color.md` | Stage 2: focal length continuum (4mm–2000mm), facial distortion vs distance, compression, crop factors, anamorphic squeeze, lens families & coatings, specialty glass, aperture/DoF tiers, bokeh geometry, aberrations & flares, shutter angle, frame rates, filters, sensor gates, film stocks, LUT/colour pipelines | Choosing Slots 7–8 or video motion/time values |
| `references/stage3-prompt-engine.md` | Stage 3: token-position zones, encoder mechanics (CLIP/T5/LLM), delimiters & bleed prevention, weighting syntax, negatives & CFG, full 8-slot spec, 22-entry optical translation dictionary, continuity anchoring, ControlNet/structural conditioning | Assembly rules, emotion mapping, continuity or ControlNet work |

Grep the files for a term (e.g. `Rembrandt`, `CineStill`, `Dutch`, `2.39`) rather than reading them whole.

## Workflow

### Step 1 — Parse the brief
Extract, inferring sensible defaults rather than interrogating the user:
- **Subject(s)** and action; **story beat / emotion**; **setting** and time of day
- **Target model/platform** (default: give a universal natural-language prompt + Midjourney + SD variants)
- **Deliverable**: single still, character sheet, multi-shot sequence, or video clip
- **Format**: aspect ratio / where it will be used (poster 2:3, reel 9:16, YouTube 16:9, cinema 2.39:1)

Ask at most one question, and only if the target platform or aspect ratio genuinely changes the output and cannot be inferred.

### Step 2 — Translate emotion into telemetry
Map every mood word to physical values using the Optical Translation Dictionary (Stage 3, section 3.3). Core mappings:

| Intent | Telemetry |
|---|---|
| Mythic heroism / dominance | 18–24mm, 12in ankle elevation, −35° to −45° pitch, 85:15 sky:ground, rim halo |
| Crushed / powerless / defeat | +45° to +60° high pitch, ceiling-corner elevation, subject in bottom third, 16:1 low-key, +20° CW roll |
| Paranoia / surveillance | 300mm telephoto, dirty FG slit (blinds/foliage), short-sided 15:85 lead room, hard side key |
| Dread / mental fracture | 28mm, ±20–25° Dutch roll, 16:1 split chiaroscuro |
| Isolation / loneliness | EWS, subject 5% of frame, 10:90 positive:negative space, 180° dorsal figure, 6500K overcast |
| Intimacy / romance | 85mm T1.4, MCU/choker, 5° lens-rim eyeline, 3:1 soft book-light, 3200K, 1/4 Black Pro-Mist |
| Confession / truth | 50mm, true eye level 5.5ft, clean single 100:0, Rembrandt 4:1, eye-light catchlight |
| Nostalgia / memory | Super 16mm gate, vintage Cooke, 3500–3800K golden hour, halation, 1/2 Pro-Mist |
| Dream / fever | Petzval swirl bokeh, 270–360° shutter smear, chromatic aberration, tilt-shift plane |
| Clinical / institutional | 40mm, 1-point dead-centre symmetry, 0° plumb pitch, 2:1 flat 4500K fluorescent green cast |
| Cyberpunk noir | 2.39:1 2x anamorphic 40mm, CineStill 800T halation, magenta key / cyan rim, wet asphalt |
| South Indian mass-hero entry | 2.39:1, 18mm, ankle-level −40° pitch, V-wedge phalanx, backlit dust, 120fps speed ramp |
| Comedy / slapstick | 1.85:1, wide master, T8 deep focus, 2:1 high-key, planar blocking |
| Stylised educational mascot | 1:3.5 head:body, 50mm zero distortion, 1.5:1 soft wrap, subsurface scattering |

For anything not listed, find the closest entry in 3.3 or derive values from Stage 1/2.

### Step 3 — Fill the 8-slot matrix
Decide every slot before writing prose. A slot can be minimal, but it should never be silently empty, because an empty slot hands that decision to the model's average (flat, centred, eye-level, over-lit).

| Slot | Decide | Example value |
|---|---|---|
| **1. Container & framing** | aspect ratio, shot scale, cut-line, subject ratio, coverage role | 2.39:1, cowboy shot cut mid-thigh, clean single |
| **2. Camera geometry** | lens height, pitch°, yaw°, roll°, horizon split, vanishing points, rig | 1ft ankle height, −35° pitch, 45° three-quarter yaw, 0° roll, 80:20 sky:ground |
| **3. Subject** | archetype, wardrobe + material + colour, proportion, torso/head/eye yaw, gesture, FACS expression, gaze & lead room | torso 30°, head 0°, eyes to lens; jaw clenched, brows lowered; 67:33 lead room |
| **4. Z-depth** | FG occlusion, MG grid placement, BG world scale, positive:negative space | OOF embers in FG 15%; subject on left third; BG burning refinery 1-pt perspective |
| **5. Lighting** | key clock position & pattern, key:fill ratio, negative fill, rim/kicker/practicals, Kelvin split | 4:30 Rembrandt key, 8:1, black negative fill, 135° rim, 3200K key vs 8000K rim |
| **6. Atmosphere** | haze density, god-rays, particulates, wet surfaces, shadow hardness | 20% haze, backlit dust, wet asphalt reflections, hard-edged shadows |
| **7. Optics** | focal length, spherical/anamorphic, T-stop & DoF, bokeh shape, shutter angle, filter, flare | 24mm 2x anamorphic, T2.8, oval bokeh, 180° shutter, 1/8 Black Pro-Mist, blue streak flare |
| **8. Capture & grade** | sensor/gate, film stock, grain, halation, LUT, IRE targets | Super 35, Kodak Vision3 500T, fine grain, Kodak 2383 print emulation, skin at 55–65 IRE |

### Step 4 — Run the conflict check
Before assembling, remove contradictions; they average out into mush:
- **Optical**: macro + extreme wide; fisheye + telephoto flatness; T1.4 shallow DoF + "everything sharp"; 14mm + "flattering portrait close-up".
- **Tonal**: high-key + noir; 2:1 ratio + "deep shadows".
- **Geometric**: low −40° pitch + "looking down on subject"; EWS + facial micro-expression detail (the face is too small to render it).
- **Physical**: anatomical cut at a joint (ankle, knee, wrist, elbow, chin tangent) — move it to mid-shaft (mid-calf, mid-thigh, collarbone).
- **Redundancy**: strip synonyms ("dark, moody, gloomy, shadowy") that burn token budget; keep the one physical value.

### Step 5 — Assemble in token-decay order
Earlier tokens carry the most attention, especially in CLIP-based models (77-token chunks). Order the prompt so structure locks before style:

1. **Zone 1 (first ~20 tokens)** — container, shot scale, camera geometry
2. **Zone 2 (~21–55)** — subject, pose, wardrobe, expression, action
3. **Zone 3 (~56–95)** — FG / MG / BG staging, environment
4. **Zone 4 (~96–150)** — lighting, Kelvin, atmosphere, lens, aperture, shutter
5. **Zone 5 (150+)** — film stock, grain, halation, grade

Binding rules (they prevent attribute bleed):
- Put colour and material immediately before their noun: "oxblood leather jacket", never "leather jacket … oxblood tones".
- Use spatial prepositions as anchors: "in the foreground", "on frame-left", "behind the subject".
- Hyphenate compound concepts: `low-angle`, `split-diopter`, `teal-and-amber`.
- Separate planes or characters with periods/semicolons; give each character a self-contained clause.
- Prefer active verbs ("reaching toward the lens") to static adjectives ("extended arm").
- State what *is* there instead of what isn't: "horizon cropped out, 100% ground plane" beats "no sky".

### Step 6 — Format for the target platform
Load platform syntax only for the requested model(s).

**Natural-language encoders (Flux, DALL-E/GPT-Image, Imagen, Ideogram, Veo, Sora)** — full grammatical sentences, plane-by-plane, numbers spelled as photographers say them ("shot on a 24mm lens at T2.8"). No weight syntax. Put exclusions as affirmative description. 80–200 words.

**Midjourney** — dense comma clauses, then parameters:
`--ar 21:9 --style raw --stylize 50–150 --chaos 0–10 --no <exclusions>`; concept weights with `::` (e.g. `hero::2 crowd::0.7`); character/style locks with `--cref <url> --cw 0–100` and `--sref <url> --sw`. Lower stylize = more prompt obedience.

**Stable Diffusion / SDXL / ComfyUI** — tag-style, structural tags first, weights `(token:1.2–1.4)` / `(token:0.6–0.8)`; never exceed ~1.5 (burns contrast, breaks anatomy). Separate negative prompt. Suggest CFG 4–7, steps 25–40, sampler DPM++ 2M Karras, fixed seed for iteration. Prompt scheduling `[from:to:0.4]` for layout-then-detail.

**Video (Runway, Kling, Veo, Sora, Pika, Luma)** — the still prompt becomes frame one; then add a separate **motion block**: camera move (dolly-in, crane-down, orbit 90°, whip-pan, dolly-zoom), speed and duration, subject action, frame-rate feel (24fps cadence, 120fps slow-motion ramp, undercranked 18fps), shutter blur (180° natural, 45° staccato). One primary camera move per clip; competing moves produce drift.

### Step 7 — Negatives (subtractive conditioning)
Build exclusions from four groups, chosen for the shot rather than dumped wholesale:
- **Framing/optics**: cropped feet, limbs cut at joints, tangent edges, accidental Dutch tilt, distorted faces at frame edge
- **Render**: plastic skin, waxy CGI sheen, over-smoothed, flat over-lit, clipped highlights, oversaturated, HDR halos
- **Anatomy**: extra fingers, fused limbs, asymmetrical pupils, malformed hands
- **Artifacts**: text, watermark, signature, logo, UI overlay, border, frame

### Step 8 — Continuity (multi-shot, character, brand series)
When more than one image must match:
- Write a **Character Lock string** once and paste it verbatim into every shot: face micro-anchors (scar, mole, brow shape, jawline, hair parting), head:body ratio, wardrobe with hex colours, fabric, wear state, hero prop and dominant hand.
- Write a **Look Lock string**: lens family, film stock, LUT, grain, Kelvin palette — identical across shots.
- Start with a turnaround sheet (0° front, 45°, 90° profile, 135°, 180° back on neutral grey, flat 5600K light) as the reference image.
- Respect the 180° rule (character A stays screen-left), the 30° camera-shift rule and the 20% scale-change rule between cuts; flip key-light screen side and background wall tokens on reverse shots.
- Platform locks: Midjourney `--cref`/`--sref`; SD IP-Adapter FaceID / InstantID / PuLID at 0.6–0.9, LoRA trigger at 0.6–1.0, fixed seed while only changing Slot 2; img2img denoise 0.15–0.30 for polish, 0.55–0.75 for re-angle.
- Video bridging: shot N+1's first frame = shot N's last frame.

### Step 9 — Structural conditioning (only when the user has ComfyUI/SD or references)
Recommend a ControlNet stack when exact pose or layout matters: DWPose/OpenPose (body, hands, face) at 1.0 for blocking; Depth (Depth-Anything/ZoeDepth) at 0.5–0.7 for Z-planes; Canny/MLSD at 0.3–0.5 ending around 0.65 of steps for architecture; Regional Prompter / attention masks to stop character feature bleed; IC-Light for relighting an existing character; Tile upscaling for 4K micro-texture. See Stage 3 section 3.5 for the full list.

## Output format

Deliver in this order, keeping explanation minimal — the user wants ready-to-paste prompts:

```
## [Shot name] — [one-line intent]

**Telemetry**
| Slot | Value |
|---|---|
| 1 Container & framing | … |
| 2 Camera geometry | … |
| 3 Subject | … |
| 4 Z-depth | … |
| 5 Lighting | … |
| 6 Atmosphere | … |
| 7 Optics | … |
| 8 Capture & grade | … |

**Universal prompt (natural language)**
<paste-ready prose>

**Midjourney**
<prompt> --ar … --style raw --stylize … --no …

**Stable Diffusion / SDXL**
Positive: …
Negative: …
Settings: CFG …, steps …, sampler …, seed …

**Motion block** (video only)
**Continuity locks** (multi-shot only)
**Variations** — 2–3 one-line slot swaps (e.g. "Swap Slot 5 to 16:1 noir split light for a darker read")
```

Include only the platform blocks that apply. For a sequence, give the Character Lock and Look Lock once at the top, then one compact block per shot with its slot changes.

## Worked example

**Brief:** "A woman waiting alone at a rain-soaked bus stop at night. Feels lonely."

**Telemetry**
| Slot | Value |
|---|---|
| 1 | 2.39:1, very wide shot, subject ~15% of frame height, clean single |
| 2 | 4ft chest-height lens, 0° pitch, 30° yaw, 0° roll, 1-point perspective down the street |
| 3 | woman in her 30s, charcoal wool coat, burgundy scarf, standing still, head lowered 15°, eyes to the empty road; short-sided 30:70 |
| 4 | FG: out-of-focus rain streaks on glass 10%; MG: bus shelter on left third; BG: empty boulevard receding to a single vanishing point, 80% negative space |
| 5 | single 4000K fluorescent shelter practical as top key, 16:1, no fill; distant 2200K sodium streetlamps as rim |
| 6 | light rain, 15% haze, wet asphalt mirroring sodium and fluorescent light |
| 7 | 40mm 2x anamorphic, T2.0, oval bokeh on streetlamps, 180° shutter, 1/8 Black Pro-Mist |
| 8 | CineStill 800T, red halation around lights, fine grain, lifted matte blacks |

**Universal prompt**
Anamorphic 2.39:1 very wide shot from chest height, level camera, a long empty city boulevard receding to a single vanishing point. On frame-left, a lone woman in a charcoal wool coat and burgundy scarf stands motionless inside a glass bus shelter, head lowered, gazing at the empty road; she occupies a small part of the frame, surrounded by dark open space. Rain streaks blur across glass in the foreground. A single cool fluorescent tube above her is the only key light, leaving deep shadows; distant amber sodium streetlamps rim her shoulders. Light rain and thin haze, wet asphalt mirroring amber and green-white light. Shot on a 40mm anamorphic lens at T2.0 with oval bokeh and a light Black Pro-Mist bloom, CineStill 800T film with red halation around the lights, fine grain, matte blacks.

**Midjourney**
anamorphic very wide shot, chest-height level camera, empty rain-soaked boulevard, 1-point perspective, lone woman in charcoal wool coat and burgundy scarf in glass bus shelter frame-left, head lowered, vast dark negative space, OOF rain streaks on foreground glass, single cool fluorescent top light, amber sodium streetlamp rim, 16:1 low-key, light rain, thin haze, wet asphalt reflections, 40mm anamorphic T2.0, oval bokeh, black pro-mist, CineStill 800T halation, fine grain --ar 21:9 --style raw --stylize 75 --no text, watermark, plastic skin, oversaturated, extra people

## Quality bar
Before delivering, check: every slot decided; no adjective-only mood words left where a physical value fits; no conflicts from Step 4; cut-lines on safe zones; colour bound to nouns; platform syntax valid; negatives relevant to this shot. Real people and copyrighted characters are not recreated by name — describe an original character with the same visual function instead.
