#!/bin/bash
set -e

cd /home/user/0328Oden
FONT_BOLD="/usr/share/fonts/opentype/noto/NotoSansCJK-Bold.ttc"
FONT_REG="/usr/share/fonts/opentype/noto/NotoSansCJK-Regular.ttc"
W=1080
H=1920
FPS=30
OUT="oden_stand_spring.mp4"
BGM="Water_Falling_on_Stone.mp3"
NYANPEN="$(ls *.jpg | grep -v 内観)"

# BGM = 28.21s
# Music structure:
#   0-3s   : Strong opening, drops off
#   3-6s   : Build-up
#   6-11s  : Peak energy
#   11-16s : Quiet→rebuild
#   16-22s : Main section
#   22-28s : Fadeout/outro
#
# Video cuts matched to music:
#   0.0  - 3.5s  (3.5s) : 内観 + 店名        [力強いオープニング]
#   3.5  - 7.0s  (3.5s) : にゃんぺん          [ビルドアップ→ピーク]
#   7.0  - 11.0s (4.0s) : gp_18 鮮魚アップ   [ピーク]
#   11.0 - 16.0s (5.0s) : gp_14 おでん        [静→再ビルド]
#   16.0 - 22.0s (6.0s) : gp_41 全品俯瞰     [メインセクション]
#   22.0 - 28.21s(6.21s): 店舗情報エンド      [フェードアウト]

D1=3.5
D2=3.5
D3=4.0
D4=5.0
D5=6.0
D6=6.21

echo "=== カット1: 内観 + 店名 (0-3.5s) ==="
FRAMES1=$(python3 -c "print(int(${D1}*${FPS}))")
ffmpeg -y -loop 1 -i 内観_0010.jpg \
  -vf "scale=2160:3840:force_original_aspect_ratio=increase,crop=2160:3840,\
zoompan=z='1.15-0.15*on/${FRAMES1}':x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':d=${FRAMES1}:s=${W}x${H}:fps=${FPS},\
drawtext=fontfile=${FONT_BOLD}:text='おでん×スタンド三徳六味':fontsize=46:fontcolor=white:borderw=3:bordercolor=black@0.5:x=(w-text_w)/2:y=h*0.45:alpha='if(lt(t,0.8),t/0.8,if(gt(t,${D1}-0.5),(${D1}-t)/0.5,1))',\
drawtext=fontfile=${FONT_REG}:text='ESTフードホール':fontsize=34:fontcolor=white:borderw=2:bordercolor=black@0.4:x=(w-text_w)/2:y=h*0.52:alpha='if(lt(t,1.0),t/1.0,if(gt(t,${D1}-0.5),(${D1}-t)/0.5,1))',\
fade=t=in:st=0:d=0.8" \
  -c:v libx264 -pix_fmt yuv420p -t ${D1} /tmp/v4_clip_00.mp4

echo "=== カット2: にゃんぺん (3.5-7.0s) ==="
FRAMES2=$(python3 -c "print(int(${D2}*${FPS}))")
# 横長画像: ぼかし背景 + 中央フル表示
ffmpeg -y -loop 1 -i "$NYANPEN" -loop 1 -i "$NYANPEN" \
  -filter_complex "\
[0:v]scale=${W}:${H}:force_original_aspect_ratio=increase,crop=${W}:${H},boxblur=20:20,setsar=1[bg];\
[1:v]scale=${W}:-1:force_original_aspect_ratio=decrease,setsar=1[fg];\
[bg][fg]overlay=0:(H-h)/2:format=auto,\
zoompan=z='1.0+0.15*on/${FRAMES2}':x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':d=${FRAMES2}:s=${W}x${H}:fps=${FPS},\
drawtext=fontfile=${FONT_BOLD}:text='名物  にゃんぺん':fontsize=52:fontcolor=white:borderw=3:bordercolor=black@0.6:x=(w-text_w)/2:y=h*0.82:alpha='if(lt(t,0.5),t/0.5,if(gt(t,${D2}-0.5),(${D2}-t)/0.5,1))'" \
  -c:v libx264 -pix_fmt yuv420p -t ${D2} /tmp/v4_clip_01.mp4

echo "=== カット3: gp_18 鮮魚アップ (7.0-11.0s) ==="
FRAMES3=$(python3 -c "print(int(${D3}*${FPS}))")
ffmpeg -y -loop 1 -i gp_18.JPG \
  -vf "scale=2160:3840:force_original_aspect_ratio=increase,crop=2160:3840,\
zoompan=z='1.0+0.3*on/${FRAMES3}':x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':d=${FRAMES3}:s=${W}x${H}:fps=${FPS},\
drawtext=fontfile=${FONT_BOLD}:text='厳選した鮮魚の、お造り':fontsize=48:fontcolor=white:borderw=3:bordercolor=black@0.6:x=(w-text_w)/2:y=h*0.82:alpha='if(lt(t,0.5),t/0.5,if(gt(t,${D3}-0.5),(${D3}-t)/0.5,1))'" \
  -c:v libx264 -pix_fmt yuv420p -t ${D3} /tmp/v4_clip_02.mp4

echo "=== カット4: gp_14 おでんアップ (11.0-16.0s) ==="
FRAMES4=$(python3 -c "print(int(${D4}*${FPS}))")
ffmpeg -y -loop 1 -i gp_14.JPG \
  -vf "scale=2160:3840:force_original_aspect_ratio=increase,crop=2160:3840,\
zoompan=z='1.3-0.3*on/${FRAMES4}':x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':d=${FRAMES4}:s=${W}x${H}:fps=${FPS},\
drawtext=fontfile=${FONT_BOLD}:text='出汁で炊いた、春野菜おでん':fontsize=48:fontcolor=white:borderw=3:bordercolor=black@0.6:x=(w-text_w)/2:y=h*0.82:alpha='if(lt(t,0.5),t/0.5,if(gt(t,${D4}-0.5),(${D4}-t)/0.5,1))'" \
  -c:v libx264 -pix_fmt yuv420p -t ${D4} /tmp/v4_clip_03.mp4

echo "=== カット5: gp_41 全品俯瞰 (16.0-22.0s) ==="
FRAMES5=$(python3 -c "print(int(${D5}*${FPS}))")
ffmpeg -y -loop 1 -i gp_41.JPG \
  -vf "scale=2160:3840:force_original_aspect_ratio=increase,crop=2160:3840,\
zoompan=z='1.3-0.3*on/${FRAMES5}':x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':d=${FRAMES5}:s=${W}x${H}:fps=${FPS},\
drawtext=fontfile=${FONT_BOLD}:text='おでんだけじゃない、この品揃え。':fontsize=44:fontcolor=white:borderw=3:bordercolor=black@0.6:x=(w-text_w)/2:y=h*0.82:alpha='if(lt(t,0.5),t/0.5,if(gt(t,${D5}-0.5),(${D5}-t)/0.5,1))'" \
  -c:v libx264 -pix_fmt yuv420p -t ${D5} /tmp/v4_clip_04.mp4

echo "=== カット6: 店舗情報エンディング (22.0-28.21s) ==="
FRAMES6=$(python3 -c "print(int(${D6}*${FPS}))")
ffmpeg -y -loop 1 -i /tmp/spring_ending.png \
  -vf "scale=${W}:${H},\
zoompan=z='1.0+0.03*on/${FRAMES6}':x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':d=${FRAMES6}:s=${W}x${H}:fps=${FPS},\
fade=t=in:st=0:d=1,fade=t=out:st=$(python3 -c "print(${D6}-2)"):d=2" \
  -c:v libx264 -pix_fmt yuv420p -t ${D6} /tmp/v4_clip_05.mp4

echo "=== 結合 ==="
cat > /tmp/v4_concat.txt << 'EOF'
file '/tmp/v4_clip_00.mp4'
file '/tmp/v4_clip_01.mp4'
file '/tmp/v4_clip_02.mp4'
file '/tmp/v4_clip_03.mp4'
file '/tmp/v4_clip_04.mp4'
file '/tmp/v4_clip_05.mp4'
EOF

ffmpeg -y -f concat -safe 0 -i /tmp/v4_concat.txt \
  -c:v libx264 -preset medium -crf 20 -pix_fmt yuv420p \
  -movflags +faststart \
  /tmp/v4_video_only.mp4

echo "=== BGM合成 ==="
ffmpeg -y -i /tmp/v4_video_only.mp4 -i "${BGM}" \
  -map 0:v -map 1:a \
  -c:v copy -c:a aac -b:a 192k \
  -shortest -movflags +faststart \
  "${OUT}"

echo "=== 完了 ==="
echo "出力: $(pwd)/${OUT}"
ls -lh "${OUT}"
ffprobe -v quiet -show_entries format=duration -show_entries stream=codec_name,width,height -of default=noprint_wrappers=1 "${OUT}"
