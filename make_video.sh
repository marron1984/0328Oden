#!/bin/bash
set -e

cd /home/user/0328Oden
FONT="/usr/share/fonts/opentype/noto/NotoSansCJK-Bold.ttc"
FONT_REG="/usr/share/fonts/opentype/noto/NotoSansCJK-Regular.ttc"
W=1080
H=1920
FPS=30
OUT="oden_stand_summer.mp4"

D_OPEN=3
D_SLIDE=5
D_END=3

echo "=== Creating opening title ==="
ffmpeg -y -f lavfi -i "color=c=0x1a1a1a:s=${W}x${H}:d=${D_OPEN}:r=${FPS}" \
  -vf "drawtext=fontfile=${FONT}:text='夏、はじめました。':fontsize=72:fontcolor=white:x=(w-text_w)/2:y=(h-text_h)/2:alpha='if(lt(t,0.5),t/0.5,if(gt(t,2.5),(3-t)/0.5,1))'" \
  -c:v libx264 -pix_fmt yuv420p -t ${D_OPEN} /tmp/clip_00_title.mp4

echo "=== Processing slides ==="

make_slide() {
  local INPUT="$1"
  local OUTPUT="$2"
  local TEXT="$3"
  local DIRECTION="$4"
  local DUR="$5"
  local FRAMES=$((DUR * FPS))

  # Zoompan needs a large input. Scale to fill 1080x1920 * 1.3 = 1404x2496
  # Use scale2ref-like approach: scale to cover target with margin, then let zoompan handle sizing
  local ZW=2160
  local ZH=3840

  if [ "$DIRECTION" = "zoom_in" ]; then
    local ZP="zoompan=z='1.0+0.3*on/${FRAMES}':x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':d=${FRAMES}:s=${W}x${H}:fps=${FPS}"
  elif [ "$DIRECTION" = "zoom_out" ]; then
    local ZP="zoompan=z='1.3-0.3*on/${FRAMES}':x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':d=${FRAMES}:s=${W}x${H}:fps=${FPS}"
  elif [ "$DIRECTION" = "pan_up" ]; then
    local ZP="zoompan=z='1.15':x='iw/2-(iw/zoom/2)':y='ih*0.25-ih*0.1*on/${FRAMES}':d=${FRAMES}:s=${W}x${H}:fps=${FPS}"
  else
    local ZP="zoompan=z='1.15':x='iw/2-(iw/zoom/2)':y='ih*0.05+ih*0.1*on/${FRAMES}':d=${FRAMES}:s=${W}x${H}:fps=${FPS}"
  fi

  # Scale to fill ZWxZH (cover, not fit), then crop to exact ZWxZH
  local PRESCALE="scale=${ZW}:${ZH}:force_original_aspect_ratio=increase,crop=${ZW}:${ZH}"

  ffmpeg -y -loop 1 -i "$INPUT" \
    -vf "${PRESCALE},${ZP},drawtext=fontfile=${FONT}:text='${TEXT}':fontsize=48:fontcolor=white:borderw=3:bordercolor=black@0.6:x=(w-text_w)/2:y=h*0.82:alpha='if(lt(t,0.5),t/0.5,if(gt(t,${DUR}-0.5),(${DUR}-t)/0.5,1))'" \
    -c:v libx264 -pix_fmt yuv420p -t ${DUR} "$OUTPUT"

  echo "Done: $OUTPUT"
}

make_slide "gp_18.JPG" "/tmp/clip_01_sashimi1.mp4" "朝獲れ鮮魚の、お造り" "zoom_in" ${D_SLIDE}
make_slide "gp_17.JPG" "/tmp/clip_02_sashimi2.mp4" "今日のおすすめ、揃ってます" "pan_up" ${D_SLIDE}
make_slide "gp_14.JPG" "/tmp/clip_03_oden1.mp4" "出汁で炊いた、夏野菜おでん" "zoom_out" ${D_SLIDE}
make_slide "gp_13.JPG" "/tmp/clip_04_oden2.mp4" "ひんやり冷菜も、じんわりおでんも" "pan_down" ${D_SLIDE}
make_slide "gp_41.JPG" "/tmp/clip_05_all.mp4" "おでんだけじゃない、この品揃え。" "zoom_out" ${D_SLIDE}

echo "=== Creating end card ==="
ffmpeg -y -f lavfi -i "color=c=0x1a1a1a:s=${W}x${H}:d=${D_END}:r=${FPS}" \
  -vf "[in]drawtext=fontfile=${FONT}:text='おでんスタンド':fontsize=64:fontcolor=white:x=(w-text_w)/2:y=(h-text_h)/2-50,drawtext=fontfile=${FONT_REG}:text='今夜、お待ちしています。':fontsize=36:fontcolor=white@0.8:x=(w-text_w)/2:y=(h/2)+40:alpha='if(lt(t,0.8),t/0.8,1)'[out]" \
  -c:v libx264 -pix_fmt yuv420p -t ${D_END} /tmp/clip_06_end.mp4

echo "=== Concatenating all clips ==="
cat > /tmp/concat_list.txt << 'CEOF'
file '/tmp/clip_00_title.mp4'
file '/tmp/clip_01_sashimi1.mp4'
file '/tmp/clip_02_sashimi2.mp4'
file '/tmp/clip_03_oden1.mp4'
file '/tmp/clip_04_oden2.mp4'
file '/tmp/clip_05_all.mp4'
file '/tmp/clip_06_end.mp4'
CEOF

ffmpeg -y -f concat -safe 0 -i /tmp/concat_list.txt \
  -c:v libx264 -preset medium -crf 20 -pix_fmt yuv420p \
  -movflags +faststart \
  "${OUT}"

# Add overall fade in/out
TOTAL_DUR=$((D_OPEN + D_SLIDE * 5 + D_END))
ffmpeg -y -i "${OUT}" \
  -vf "fade=t=in:st=0:d=0.5,fade=t=out:st=$((TOTAL_DUR-1)):d=1" \
  -c:v libx264 -preset medium -crf 20 -pix_fmt yuv420p \
  -movflags +faststart \
  "${OUT%.mp4}_final.mp4"

mv "${OUT%.mp4}_final.mp4" "${OUT}"

echo "=== Done! ==="
echo "Output: $(pwd)/${OUT}"
ls -lh "${OUT}"
