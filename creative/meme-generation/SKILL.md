---
name: meme-generation
description: Generate memes from a topic using template APIs or original AI-generated art, with optional branding overlays.
version: 1.1.0
author: adanaleycio, mikeyd, hermes-agent
license: MIT
platforms: [linux]
metadata:
  hermes:
    tags: [creative, memes, humor, social-media]
    related_skills: [ascii-art]
    requires_toolsets: [terminal]
---

# Meme Generation

Generate memes using template-based APIs or fully custom AI-generated artwork with text overlays.

## When to Use

Use this skill when the user:
- wants to make a meme about a topic
- has a subject, situation, or frustration and wants a funny meme version
- asks for a relatable, sarcastic, or programmer-style meme idea
- wants caption ideas matched to a known meme format
- wants a completely original/custom meme (movie poster, fake presentation, etc.)

Do not use this skill when:
- the user wants a full graphic editor workflow
- the request is for hateful, abusive, or targeted harassment content
- the user wants a random joke without meme structure

## Quick Reference

| Input    | Meaning                                          |
|----------|--------------------------------------------------|
| topic    | The main subject of the meme                     |
| tone     | Optional style: relatable, programmer, sarcastic  |
| template | Optional specific meme template to use            |
| custom   | If true, generate original art instead of template |

### Template-to-Pattern Mapping

| Template ID        | Name                    | Lines | Best For                                    |
|--------------------|-------------------------|-------|---------------------------------------------|
| gru                | Gru's Plan              | 4     | A plan that fails at step 3 (repeat line 3 as line 4) |
| drake              | Drakeposting            | 2     | Rejecting one thing, approving another      |
| db                 | Distracted Boyfriend    | 3     | Line1=temptation, Line2=person, Line3=ignored thing |
| mordor             | One Does Not Simply     | 2     | Something that is harder than it sounds     |
| fine               | This is Fine            | 2     | Chaos, denial, pretending things are okay   |
| cmm                | Change My Mind          | 1     | Strong ironic opinion / hot take            |
| gb                 | Galaxy Brain            | 4     | Escalating irony or absurd superiority      |
| gandalf            | Confused Gandalf        | 2     | Confusion, forgetting, "I have no memory"   |
| buzz               | X, X Everywhere         | 2     | Something that is literally everywhere      |
| rollsafe           | Roll Safe               | 2     | Sarcastic "clever" advice                   |
| astronaut          | Always Has Been         | 4     | Revealing something was always true         |
| both               | Why Not Both?           | 2     | Refusing to choose between two options      |
| sparta             | This is Sparta!         | 2     | Aggressive rejection                        |
| success            | Success Kid             | 2     | Small victory celebration                   |

## Procedure

### Path A: Template-Based Meme (fast, one API call)

1. Read the user's topic and determine the core emotional pattern (chaos, distraction, dilemma, escalation, contradiction, failed plan, hot take).
2. Select the template that best matches that pattern using the table above.
3. Write captions that fit the template's line structure. Keep them short and punchy.
4. Generate the meme with memegen.link (free, no auth required):

```
GET https://api.memegen.link/images/{template_id}/{line1}/{line2}.png
```

- URL-encode each line with `urllib.parse.quote(text, safe='')`
- Lines are separated by `/` in the URL path
- Use `.png` extension for best quality
- To list all templates: `GET https://api.memegen.link/templates`
- To get template details: `GET https://api.memegen.link/templates/{id}`

Example:
```python
from urllib.parse import quote
import requests

line1 = quote("One does not simply", safe='')
line2 = quote("deploy on Friday", safe='')
url = f"https://api.memegen.link/images/mordor/{line1}/{line2}.png"
r = requests.get(url)
with open("/tmp/meme.png", "wb") as f:
    f.write(r.content)
```

5. If branding or extra overlays are needed, proceed to the Overlay step below.

### Path B: Custom/Object-Label Meme with Pillow (advanced, multi-step)

For memes that need avatar overlays, face replacements, or per-object labeling (like "Silent Protector", "Distracted Boyfriend" edits, etc.):

1. **Research first.** Before building, search Know Your Meme / imgflip / Google for popular versions of the template. Study how the best ones place labels, what font style they use, and what makes them effective. This avoids amateur-looking results.

2. **Download the blank template** via browser (imgflip blocks curl; use browser_get_images to find the CDN URL like `i.imgflip.com/XXXXX.png`, then curl that).

3. **Avatar overlays (face replacement):**
   - Download avatars from GitHub (`github.com/USERNAME.png`) or HuggingFace CDN
   - **Remove the background via alpha channel** -- the simple, correct way:
     - Detect white (or black) background pixels using a threshold
     - Set their alpha to 0 (transparent)
     - Paste with the alpha mask -- the character's natural shape sits on the scene
     - Choose EITHER white OR black to remove, almost never both. Check each avatar individually.
   - Do NOT use circular masks, white borders, feathered edges, or background-color painting hacks. Those look worse than simple alpha removal.
   
   ```python
   import numpy as np
   def remove_bg(image, color="white", threshold=230):
       """Remove white or black bg pixels via alpha channel"""
       data = np.array(image.convert("RGBA"))
       r, g, b, a = data[:,:,0], data[:,:,1], data[:,:,2], data[:,:,3]
       if color == "white":
           mask = (r > threshold) & (g > threshold) & (b > threshold)
       elif color == "black":
           dark = 255 - threshold
           mask = (r < dark) & (g < dark) & (b < dark)
       data[:,:,3] = np.where(mask, 0, a)
       return Image.fromarray(data)
   ```
   
   - **Mirror/flip** avatars with `img.transpose(Image.FLIP_LEFT_RIGHT)` if they face the wrong direction for the composition
   - Position over the character's head -- use `vision_analyze` to check placement

4. **Object/projectile labeling (the "anime arrows" technique):**
   - **Angle the text** to match the trajectory of the objects (~30-45 degrees)
   - Use NEGATIVE angles (e.g., -35) for objects falling from top-left to bottom-right
   - Use POSITIVE angles for objects going the other direction
   - Place labels **floating near** each projectile, not in boxes
   - White bold text with thick black outline (3px) -- the classic meme standard
   - This looks far more dynamic than horizontal text in dark boxes

   ```python
   def make_angled_text(text, font, angle, fill=(255,255,255,255), outline=(0,0,0,255), outline_w=3):
       dummy = Image.new("RGBA", (1, 1), (0, 0, 0, 0))
       bbox = ImageDraw.Draw(dummy).textbbox((0, 0), text, font=font)
       tw = bbox[2] - bbox[0] + outline_w * 2 + 6
       th = bbox[3] - bbox[1] + outline_w * 2 + 6
       txt_img = Image.new("RGBA", (tw, th), (0, 0, 0, 0))
       td = ImageDraw.Draw(txt_img)
       ox, oy = outline_w + 3, outline_w + 3 - bbox[1]
       for dx in range(-outline_w, outline_w + 1):
           for dy in range(-outline_w, outline_w + 1):
               if dx != 0 or dy != 0:
                   td.text((ox + dx, oy + dy), text, font=font, fill=outline)
       td.text((ox, oy), text, font=font, fill=fill)
       return txt_img.rotate(angle, expand=True, resample=Image.BICUBIC)
   ```

5. **Subject/protector labels:** Use rounded-rectangle pill backgrounds with transparency `(0, 0, 0, 200)` for text over busy areas. Color-code: blue for protector, green for protected, red for threats.

6. **Iterate with vision_analyze** -- check each version, fix positioning, then re-render. Common issues: avatar placed too low, text cut off at edges, wrong angle direction.

### Path C: Custom AI-Generated Meme (original artwork)

1. Use `image_generate` to create original artwork based on the concept.

   - Request space at top and bottom for text in the prompt.
   - Use portrait aspect ratio for poster-style, landscape for widescreen memes.
2. Use Pillow to add text overlays:
   - Title text: large bold font, gold or white with black outline.
   - Taglines: smaller italic/regular font below title.
   - Credits/footer: small font on semi-transparent dark bar at bottom.
3. Extend the canvas with black bars above/below if more text space is needed.

### Overlay Step: Adding Logos or Branding

When the user wants a logo or branding on the meme:

1. **Nous Research logo** is available from LobeHub CDN:
   ```
   https://registry.npmmirror.com/@lobehub/icons-static-png/latest/files/light/nousresearch.png
   ```
   - This is a 1024x1024 RGBA PNG
   - ALL pixels are (0,0,0) black with varying alpha for anti-aliasing
   - Background is already transparent (alpha=0)
   - Do NOT try to "remove white background" -- there is none

2. **To make the logo visible on dark backgrounds**, invert the RGB:
   ```python
   logo_data = logo.getdata()
   white_version = [(255, 255, 255, px[3]) for px in logo_data]
   logo.putdata(white_version)
   ```

3. **Create a circular badge** for clean presentation:
   ```python
   badge = Image.new("RGBA", (size, size), (0, 0, 0, 0))
   draw = ImageDraw.Draw(badge)
   draw.ellipse([0, 0, size-1, size-1], fill=(20, 20, 20, 190))
   logo_resized = logo_white.resize((size-10, size-10), Image.LANCZOS)
   badge.paste(logo_resized, (5, 5), logo_resized)
   ```

4. **Placement rules:**
   - Place logos in a CORNER of the image, not over faces
   - Place extra text (taglines, credits) ABOVE or BELOW the meme image
   - Use semi-transparent dark bars behind text on busy backgrounds
   - Extend the canvas with black bars if needed for clean text areas

### Text Styling with Pillow

### Font Priority

User prefers Courier New (Hermes = courier/messenger of the gods). Use in this order:
1. **Liberation Mono Bold** `/usr/share/fonts/truetype/liberation/LiberationMono-Bold.ttf` (Courier New metric-compatible replacement, usually available)
2. **Mondwest** (if installed)
3. **Helvetica** or **DejaVu Sans Bold** as fallback

For meme-style text overlays:
```python
from PIL import Image, ImageDraw, ImageFont

# Courier New style (Liberation Mono Bold)
font = ImageFont.truetype("/usr/share/fonts/truetype/liberation/LiberationMono-Bold.ttf", size)

# White text with black outline (classic meme style)
outline = 3
for dx in range(-outline, outline+1):
    for dy in range(-outline, outline+1):
        if dx != 0 or dy != 0:
            draw.text((x+dx, y+dy), text, font=font, fill=(0, 0, 0, 255))
draw.text((x, y), text, font=font, fill=(255, 255, 255, 255))
```

### Nous Research Team Assets (for Nous-related memes)

Avatars (download with curl, confirmed working):
| Person | Role | Avatar URL | Description |
|--------|------|-----------|-------------|
| Teknium | Head of Post Training | `https://cdn-avatars.huggingface.co/v1/production/uploads/6317aade83d8d2fd903192d9/erOwgMXc_CZih3uMoyTAp.jpeg` | Anime boy, green hair, red visor, leaves |
| Jeffrey Quesnelle | CEO, @theemozilla | `https://github.com/jquesnelle.png` | Minion character |
| Karan Malhotra | Head of Behavior, @karan4d | `https://github.com/conceptofmind.png` | Greek Odysseus marble sculpture |
| Bowen Peng | Researcher, @bloc97_ | `https://github.com/bloc97.png` | Vault Boy holding Nuka-Cola |

Note: Shivani Mitra (co-founder) has left Nous Research -- do not include her.

Logos:
- **Nous logo (LobeHub CDN):** `https://registry.npmmirror.com/@lobehub/icons-static-png/latest/files/light/nousresearch.png` -- 1024x1024 RGBA, black pixels with alpha. Invert to white for dark backgrounds.
- **Nous mascot:** Anime girl with bob haircut, headphones, waveform in hair. Blue line art. Copy at `https://files.catbox.moe/8oagmh.png`
- The GitHub org avatar (waveform) is NOT the real logo.

## Pitfalls

- Do NOT over-engineer with Pillow when memegen.link handles text placement perfectly in one API call. Use Pillow only for branding overlays or custom memes.
- Do NOT use imgflip API (requires account, CAPTCHA issues). Use memegen.link instead.
- Do NOT confuse the GitHub NousResearch org avatar (a waveform) with the actual Nous logo (anime girl with headphones). The real logo is on LobeHub CDN.
- Do NOT try to remove white backgrounds from the Nous logo -- it already has proper alpha transparency.
- Do NOT float logos or extra text over people's faces in template memes.
- Do NOT choose templates randomly; match the joke structure to the template pattern.
- Do NOT make captions too long -- short and punchy wins.
- Do NOT generate hateful, abusive, or personally targeted content.
- Do NOT place text labels in dark boxes for object-labeling memes -- use angled floating text with outlines instead (study popular examples first).
- Do NOT tilt projectile labels the WRONG direction -- negative angles for top-left-to-bottom-right trajectory, positive for the reverse.
- Do NOT skip the research step for custom template memes. Always look at 3-5 popular versions on Know Your Meme / imgflip before building to understand the visual conventions.
- Do NOT forget to mirror/flip avatars when the face points the wrong direction for the meme's composition.
- Do NOT use circular masks, white borders, feathered edges, or background-color painting to composite avatars. Just remove the bg color via alpha channel and paste. Simple > clever.
- Do NOT remove both white AND black backgrounds at the same time. Check each avatar and pick one. Some have white bg, some have dark/black bg.
- Do NOT use vision_analyze as the sole judge of whether text is cut off -- verify with actual pixel math (`textbbox()` vs image dimensions).
- imgflip blocks direct curl downloads; use browser_get_images to find the `i.imgflip.com` CDN URL, then curl THAT with a user-agent string.

## Verification

The output is correct if:
- The chosen template clearly matches the topic structure
- All captions are short, readable, and meme-appropriate
- The tone matches the user's request
- Any branding is cleanly placed in corners or above/below the image
- The result can be shared immediately without additional editing
- Text is fully readable and not obscured by image elements
