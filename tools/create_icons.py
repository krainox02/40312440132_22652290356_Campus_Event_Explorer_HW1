"""Generate original campus dot-motif launcher icons with Pillow."""
import json
from pathlib import Path
from PIL import Image, ImageDraw

ROOT = Path(__file__).resolve().parents[1]
image = Image.new('RGB', (1024, 1024), '#203D35')
d = ImageDraw.Draw(image)
for x in range(-2, 3):
    for y in range(-2, 3):
        if x*x + y*y <= 5:
            radius = 34 if x*x + y*y < 2 else 21
            cx, cy = 512 + x*105, 512 + y*105
            d.ellipse((cx-radius, cy-radius, cx+radius, cy+radius), fill='#E3EDCE')
for density, size in [('mdpi',48), ('hdpi',72), ('xhdpi',96), ('xxhdpi',144), ('xxxhdpi',192)]:
    image.resize((size,size), Image.Resampling.LANCZOS).save(ROOT / f'android/app/src/main/res/mipmap-{density}/ic_launcher.png')
for size in (192,512):
    for stem in ('Icon', 'Icon-maskable'):
        image.resize((size,size), Image.Resampling.LANCZOS).save(ROOT / f'web/icons/{stem}-{size}.png')
image.resize((32,32), Image.Resampling.LANCZOS).save(ROOT / 'web/favicon.png')
folder = ROOT / 'ios/Runner/Assets.xcassets/AppIcon.appiconset'
entries = json.loads((folder / 'Contents.json').read_text())['images']
for entry in entries:
    size = round(float(entry['size'].split('x')[0]) * float(entry['scale'][:-1]))
    image.resize((size,size), Image.Resampling.LANCZOS).save(folder / entry['filename'])
manifest = ROOT / 'web/manifest.json'
data = json.loads(manifest.read_text())
data.update(name='Campus Event Explorer', short_name='campus.', background_color='#F7F7F0', theme_color='#203D35', description='Discover campus events. Find your next campus moment.')
manifest.write_text(json.dumps(data, indent=2) + '\n')
