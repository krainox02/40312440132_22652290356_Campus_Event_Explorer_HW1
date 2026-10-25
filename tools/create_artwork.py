"""Generate original, offline category artwork. Requires Pillow, not used by app."""
from pathlib import Path
from PIL import Image, ImageDraw

ROOT = Path(__file__).resolve().parents[1] / 'assets' / 'images'
ROOT.mkdir(parents=True, exist_ok=True)
S = 3


def artwork(name, background, draw_scene):
    image = Image.new('RGB', (1200, 600), background)
    draw = ImageDraw.Draw(image)
    draw_scene(draw)
    image.save(ROOT / f'{name}.png', optimize=True)


def technology(d):
    d.ellipse((650, -170, 1330, 510), fill='#BDCCB1')
    for x in range(30, 1200, 50):
        for y in range(25, 600, 50):
            d.ellipse((x, y, x+3, y+3), fill='#98B5A8')
    d.rounded_rectangle((270, 105, 900, 480), radius=32, fill='#244B42')
    d.rounded_rectangle((295, 130, 875, 450), radius=18, fill='#E9EDD5')
    d.polygon([(200, 480), (970, 480), (1030, 520), (140, 520)], fill='#173F36')
    d.rounded_rectangle((360, 190, 560, 215), radius=10, fill='#789C83')
    d.rounded_rectangle((360, 240, 680, 255), radius=7, fill='#B3C8A6')
    d.rounded_rectangle((360, 280, 610, 295), radius=7, fill='#B3C8A6')
    d.rounded_rectangle((360, 320, 720, 335), radius=7, fill='#B3C8A6')
    d.ellipse((690, 175, 815, 300), fill='#E7AF69')
    d.polygon([(740, 198), (717, 247), (745, 247), (730, 280), (790, 230), (758, 230), (778, 198)], fill='#244B42')
    d.line((160, 160, 180, 160), fill='#244B42', width=7)
    d.line((170, 150, 170, 170), fill='#244B42', width=7)


def arts(d):
    d.ellipse((-160, 150, 510, 820), fill='#DF9575')
    d.ellipse((810, -150, 1260, 300), fill='#ECC794')
    d.rounded_rectangle((370, 90, 800, 490), radius=200, fill='#8B443C')
    d.rounded_rectangle((405, 120, 765, 490), radius=180, fill='#EFC5A1')
    d.rectangle((405, 310, 765, 500), fill='#EFC5A1')
    d.line((600, 180, 600, 395), fill='#633A35', width=15)
    d.line((600, 180, 720, 150, 720, 360), fill='#633A35', width=15)
    d.ellipse((530, 360, 610, 412), fill='#633A35')
    d.ellipse((650, 327, 730, 379), fill='#633A35')
    d.line((900, 300, 940, 210, 980, 300, 880, 250, 1000, 250, 900, 300), fill='#8B443C', width=7)
    d.arc((150, 150, 300, 300), 200, 345, fill='#8B443C', width=9)
    d.ellipse((275, 315, 295, 335), fill='#633A35')
    d.line((0, 520, 1200, 520), fill='#BC715A', width=4)


def sports(d):
    d.ellipse((740, -130, 1150, 280), fill='#F6D78B')
    d.polygon([(0, 420), (350, 190), (700, 420)], fill='#A2BFA7')
    d.polygon([(470, 450), (850, 210), (1200, 440), (1200, 600), (470, 600)], fill='#6D9988')
    d.rectangle((0, 440, 1200, 600), fill='#D99165')
    for y in (475, 530, 585):
        d.line((0, y, 1200, y), fill='#F6E7C4', width=5)
    d.ellipse((500, 135, 558, 193), fill='#244B42')
    d.line((520, 210, 595, 300, 700, 340), fill='#244B42', width=34)
    d.line((575, 290, 510, 365, 415, 380), fill='#244B42', width=30)
    d.line((540, 220, 620, 210, 660, 155), fill='#244B42', width=20)
    d.line((540, 225, 475, 270, 430, 230), fill='#244B42', width=20)
    d.line((700, 340, 725, 345), fill='#F9E9CC', width=24)
    d.line((415, 380, 390, 375), fill='#F9E9CC', width=24)


artwork('technology', '#D9E4CE', technology)
artwork('arts', '#F2D9BD', arts)
artwork('sports', '#D8E6DB', sports)
