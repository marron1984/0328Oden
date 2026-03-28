#!/bin/bash
set -e

FONT_BOLD="/usr/share/fonts/opentype/noto/NotoSansCJK-Bold.ttc"
FONT_REG="/usr/share/fonts/opentype/noto/NotoSansCJK-Regular.ttc"
W=1080
H=1920

# === 1. Create spring/sakura opening background ===
echo "Creating spring opening background..."

# Base: soft pink gradient
convert -size ${W}x${H} gradient:"#FFE4E8-#FFC0CB" /tmp/spring_base.png

# Draw sakura flower clusters + scattered petals
convert /tmp/spring_base.png \
  -fill "#FFB7C5" -draw "circle 200,300 230,330" \
  -fill "#FF99AA" -draw "circle 220,310 245,335" \
  -fill "#FFB7C5" -draw "circle 190,320 215,345" \
  -fill "#FF99AA" -draw "circle 210,290 235,315" \
  -fill "#FFB7C5" -draw "circle 180,300 205,325" \
  -fill "#FFCCD5" -draw "circle 205,305 215,315" \
  \
  -fill "#FFB7C5" -draw "circle 850,200 880,230" \
  -fill "#FF99AA" -draw "circle 870,210 895,235" \
  -fill "#FFB7C5" -draw "circle 840,220 865,245" \
  -fill "#FF99AA" -draw "circle 860,190 885,215" \
  -fill "#FFCCD5" -draw "circle 855,205 865,215" \
  \
  -fill "#FFB7C5" -draw "circle 500,150 530,180" \
  -fill "#FF99AA" -draw "circle 520,160 545,185" \
  -fill "#FFB7C5" -draw "circle 490,170 515,195" \
  -fill "#FFCCD5" -draw "circle 505,155 515,165" \
  \
  -fill "#FFB7C5" -draw "circle 150,700 175,725" \
  -fill "#FF99AA" -draw "circle 170,710 190,730" \
  -fill "#FFCCD5" -draw "circle 155,705 165,715" \
  \
  -fill "#FFB7C5" -draw "circle 900,600 925,625" \
  -fill "#FF99AA" -draw "circle 920,610 940,630" \
  -fill "#FFCCD5" -draw "circle 905,605 915,615" \
  \
  -fill "#FFB7C5" -draw "circle 300,1600 325,1625" \
  -fill "#FF99AA" -draw "circle 320,1610 340,1630" \
  \
  -fill "#FFB7C5" -draw "circle 750,1400 775,1425" \
  -fill "#FF99AA" -draw "circle 770,1410 790,1430" \
  \
  -fill "#FFB7C5" -draw "circle 100,1100 120,1120" \
  -fill "#FFB7C5" -draw "circle 950,1000 970,1020" \
  -fill "#FFB7C5" -draw "circle 600,1800 620,1820" \
  \
  -fill "#FFB0C0" -draw "ellipse 80,500 15,8 0,360" \
  -fill "#FF99AA" -draw "ellipse 300,900 12,7 0,360" \
  -fill "#FFB0C0" -draw "ellipse 700,800 14,8 0,360" \
  -fill "#FF99AA" -draw "ellipse 950,1300 13,7 0,360" \
  -fill "#FFB0C0" -draw "ellipse 400,1500 15,8 0,360" \
  -fill "#FF99AA" -draw "ellipse 200,1200 10,6 0,360" \
  -fill "#FFB0C0" -draw "ellipse 800,1700 12,7 0,360" \
  -fill "#FF99AA" -draw "ellipse 550,400 11,6 0,360" \
  -fill "#FFB0C0" -draw "ellipse 650,1100 13,7 0,360" \
  -fill "#FF99AA" -draw "ellipse 450,650 10,5 0,360" \
  \
  -blur 0x3 \
  /tmp/spring_opening.png

echo "Opening background done."

# === 2. Create ending background with store info ===
echo "Creating ending card..."

convert -size ${W}x${H} gradient:"#4A2030-#2D1520" /tmp/end_base.png

convert /tmp/end_base.png \
  -fill "rgba(255,183,197,0.15)" -draw "circle 150,200 180,230" \
  -fill "rgba(255,153,170,0.12)" -draw "circle 170,210 195,235" \
  -fill "rgba(255,183,197,0.15)" -draw "circle 140,220 165,245" \
  \
  -fill "rgba(255,183,197,0.15)" -draw "circle 900,150 930,180" \
  -fill "rgba(255,153,170,0.12)" -draw "circle 920,160 945,185" \
  \
  -fill "rgba(255,183,197,0.10)" -draw "circle 200,1700 225,1725" \
  -fill "rgba(255,153,170,0.08)" -draw "circle 220,1710 240,1730" \
  \
  -fill "rgba(255,183,197,0.10)" -draw "circle 850,1600 875,1625" \
  -fill "rgba(255,153,170,0.08)" -draw "circle 870,1610 890,1630" \
  \
  -fill "rgba(255,183,197,0.06)" -draw "ellipse 500,300 12,7 0,360" \
  -fill "rgba(255,183,197,0.06)" -draw "ellipse 100,900 10,6 0,360" \
  -fill "rgba(255,183,197,0.06)" -draw "ellipse 950,800 11,6 0,360" \
  -fill "rgba(255,183,197,0.06)" -draw "ellipse 400,1400 13,7 0,360" \
  \
  -blur 0x4 \
  /tmp/spring_ending_bg.png

# Add store info text
convert /tmp/spring_ending_bg.png \
  -font "$FONT_BOLD" \
  -fill white -pointsize 44 -gravity North \
  -annotate +0+280 "おでん×スタンド三徳六味" \
  -fill white -pointsize 34 -gravity North \
  -annotate +0+340 "ESTフードホール" \
  \
  -fill "#FFB7C5" -stroke "#FFB7C5" -strokewidth 1 \
  -draw "line 340,420 740,420" \
  \
  -font "$FONT_REG" -stroke none \
  -fill "rgba(255,255,255,0.6)" -pointsize 24 -gravity North \
  -annotate +0+470 "住 所" \
  -fill white -pointsize 26 -gravity North \
  -annotate +0+510 "〒530-0017" \
  -annotate +0+550 "大阪府大阪市北区角田町3-25" \
  -annotate +0+590 "EST FOODHALL" \
  \
  -fill "rgba(255,255,255,0.6)" -pointsize 24 -gravity North \
  -annotate +0+670 "電話番号" \
  -fill white -pointsize 30 -gravity North \
  -annotate +0+710 "06-6743-4501" \
  \
  -fill "rgba(255,255,255,0.6)" -pointsize 24 -gravity North \
  -annotate +0+790 "営業時間" \
  -fill white -pointsize 28 -gravity North \
  -annotate +0+830 "11:00〜23:00" \
  -fill "rgba(255,255,255,0.5)" -pointsize 22 -gravity North \
  -annotate +0+875 "(L.O. フード/22:00・ドリンク/22:15)" \
  \
  -fill "rgba(255,255,255,0.6)" -pointsize 24 -gravity North \
  -annotate +0+945 "定休日" \
  -fill white -pointsize 28 -gravity North \
  -annotate +0+985 "不定休（施設定休日に準ずる）" \
  \
  -fill "#FFB7C5" -stroke "#FFB7C5" -strokewidth 1 \
  -draw "line 340,1060 740,1060" \
  \
  -font "$FONT_REG" -stroke none \
  -fill "rgba(255,255,255,0.4)" -pointsize 20 -gravity North \
  -annotate +0+1090 "ご来店お待ちしております" \
  \
  /tmp/spring_ending.png

echo "Ending card done."
ls -lh /tmp/spring_opening.png /tmp/spring_ending.png
