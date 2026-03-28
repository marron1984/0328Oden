#!/bin/bash
set -e

cd /home/user/0328Oden
FONT_BOLD="/usr/share/fonts/opentype/noto/NotoSansCJK-Bold.ttc"
FONT_REG="/usr/share/fonts/opentype/noto/NotoSansCJK-Regular.ttc"
W=1080
H=1920
FPS=30
OUT="oden_stand_spring.mp4"
BGM="Pink_Petals_on_a_Plate (1).mp3"

# BGM duration = 30.77s
# Structure matched to music energy:
#   0.0 -  3.5s (3.5s) : Opening title     [quiet intro]
#   3.5 -  8.0s (4.5s) : gp_18 sashimi     [build-up, beat@4.25]
#   8.0 - 12.5s (4.5s) : gp_14 oden        [main section, beat@8.75]
#  12.5 - 17.0s (4.5s) : gp_17 sashimi     [main section, beat@14.5]
#  17.0 - 21.0s (4.0s) : gp_13 oden        [main section, beat@17.75]
#  21.0 - 24.0s (3.0s) : gp_41 all dishes  [main→outro transition]
#  24.0 - 30.77s(6.77s): Ending card        [quiet outro]

D1=3.5    # opening
D2=4.5    # gp_18
D3=4.5    # gp_14
D4=4.5    # gp_17
D5=4.0    # gp_13
D6=3.0    # gp_41
D7=6.77   # ending

echo "=== カット1: 春の桜オープニング (0-3.5s / イントロ) ==="
FRAMES1=$(python3 -c "print(int(${D1}*${FPS}))")
ffmpeg -y -loop 1 -i /tmp/spring_opening.png \
  -vf "scale=${W}:${H},zoompan=z='1.0+0.08*on/${FRAMES1}':x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':d=${FRAMES1}:s=${W}x${H}:fps=${FPS},drawtext=fontfile=${FONT_BOLD}:text='春、はじめました。':fontsize=72:fontcolor=white:borderw=2:bordercolor=black@0.3:x=(w-text_w)/2:y=(h-text_h)/2:alpha='if(lt(t,0.8),t/0.8,if(gt(t,${D1}-0.5),(${D1}-t)/0.5,1))',fade=t=in:st=0:d=1" \
  -c:v libx264 -pix_fmt yuv420p -t ${D1} /tmp/v3_clip_00.mp4

echo "=== カット2: gp_18 鮮魚アップ (3.5-8.0s / ビルドアップ) ==="
FRAMES2=$(python3 -c "print(int(${D2}*${FPS}))")
ffmpeg -y -loop 1 -i gp_18.JPG \
  -vf "scale=2160:3840:force_original_aspect_ratio=increase,crop=2160:3840,zoompan=z='1.0+0.3*on/${FRAMES2}':x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':d=${FRAMES2}:s=${W}x${H}:fps=${FPS},drawtext=fontfile=${FONT_BOLD}:text='朝獲れ鮮魚の、お造り':fontsize=48:fontcolor=white:borderw=3:bordercolor=black@0.6:x=(w-text_w)/2:y=h*0.82:alpha='if(lt(t,0.5),t/0.5,if(gt(t,${D2}-0.5),(${D2}-t)/0.5,1))'" \
  -c:v libx264 -pix_fmt yuv420p -t ${D2} /tmp/v3_clip_01.mp4

echo "=== カット3: gp_14 おでんアップ (8.0-12.5s / メイン前半) ==="
FRAMES3=$(python3 -c "print(int(${D3}*${FPS}))")
ffmpeg -y -loop 1 -i gp_14.JPG \
  -vf "scale=2160:3840:force_original_aspect_ratio=increase,crop=2160:3840,zoompan=z='1.3-0.3*on/${FRAMES3}':x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':d=${FRAMES3}:s=${W}x${H}:fps=${FPS},drawtext=fontfile=${FONT_BOLD}:text='出汁で炊いた、春野菜おでん':fontsize=48:fontcolor=white:borderw=3:bordercolor=black@0.6:x=(w-text_w)/2:y=h*0.82:alpha='if(lt(t,0.5),t/0.5,if(gt(t,${D3}-0.5),(${D3}-t)/0.5,1))'" \
  -c:v libx264 -pix_fmt yuv420p -t ${D3} /tmp/v3_clip_02.mp4

echo "=== カット4: gp_17 鮮魚タイトズーム (12.5-17.0s / メイン中盤) ==="
FRAMES4=$(python3 -c "print(int(${D4}*${FPS}))")
ffmpeg -y -loop 1 -i gp_17.JPG \
  -vf "scale=2160:3840:force_original_aspect_ratio=increase,crop=2160:3840,zoompan=z='1.2-0.1*on/${FRAMES4}':x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':d=${FRAMES4}:s=${W}x${H}:fps=${FPS},drawtext=fontfile=${FONT_BOLD}:text='今日のおすすめ、揃ってます':fontsize=48:fontcolor=white:borderw=3:bordercolor=black@0.6:x=(w-text_w)/2:y=h*0.82:alpha='if(lt(t,0.5),t/0.5,if(gt(t,${D4}-0.5),(${D4}-t)/0.5,1))'" \
  -c:v libx264 -pix_fmt yuv420p -t ${D4} /tmp/v3_clip_03.mp4

echo "=== カット5: gp_13 おでん引き (17.0-21.0s / メイン後半) ==="
FRAMES5=$(python3 -c "print(int(${D5}*${FPS}))")
ffmpeg -y -loop 1 -i gp_13.JPG \
  -vf "scale=2160:3840:force_original_aspect_ratio=increase,crop=2160:3840,zoompan=z='1.15':x='iw/2-(iw/zoom/2)':y='ih*0.05+ih*0.1*on/${FRAMES5}':d=${FRAMES5}:s=${W}x${H}:fps=${FPS},drawtext=fontfile=${FONT_BOLD}:text='ひんやり冷菜も、じんわりおでんも':fontsize=44:fontcolor=white:borderw=3:bordercolor=black@0.6:x=(w-text_w)/2:y=h*0.82:alpha='if(lt(t,0.5),t/0.5,if(gt(t,${D5}-0.5),(${D5}-t)/0.5,1))'" \
  -c:v libx264 -pix_fmt yuv420p -t ${D5} /tmp/v3_clip_04.mp4

echo "=== カット6: gp_41 全品俯瞰 (21.0-24.0s / メイン→アウトロ) ==="
FRAMES6=$(python3 -c "print(int(${D6}*${FPS}))")
ffmpeg -y -loop 1 -i gp_41.JPG \
  -vf "scale=2160:3840:force_original_aspect_ratio=increase,crop=2160:3840,zoompan=z='1.3-0.3*on/${FRAMES6}':x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':d=${FRAMES6}:s=${W}x${H}:fps=${FPS},drawtext=fontfile=${FONT_BOLD}:text='おでんだけじゃない、この品揃え。':fontsize=44:fontcolor=white:borderw=3:bordercolor=black@0.6:x=(w-text_w)/2:y=h*0.82:alpha='if(lt(t,0.5),t/0.5,if(gt(t,${D6}-0.5),(${D6}-t)/0.5,1))'" \
  -c:v libx264 -pix_fmt yuv420p -t ${D6} /tmp/v3_clip_05.mp4

echo "=== カット7: 店舗情報エンディング (24.0-30.77s / アウトロ) ==="
FRAMES7=$(python3 -c "print(int(${D7}*${FPS}))")
ffmpeg -y -loop 1 -i /tmp/spring_ending.png \
  -vf "scale=${W}:${H},zoompan=z='1.0+0.05*on/${FRAMES7}':x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':d=${FRAMES7}:s=${W}x${H}:fps=${FPS},fade=t=in:st=0:d=1,fade=t=out:st=$(python3 -c "print(${D7}-1.5)"):d=1.5" \
  -c:v libx264 -pix_fmt yuv420p -t ${D7} /tmp/v3_clip_06.mp4

echo "=== 結合（映像のみ）==="
cat > /tmp/v3_concat.txt << 'EOF'
file '/tmp/v3_clip_00.mp4'
file '/tmp/v3_clip_01.mp4'
file '/tmp/v3_clip_02.mp4'
file '/tmp/v3_clip_03.mp4'
file '/tmp/v3_clip_04.mp4'
file '/tmp/v3_clip_05.mp4'
file '/tmp/v3_clip_06.mp4'
EOF

ffmpeg -y -f concat -safe 0 -i /tmp/v3_concat.txt \
  -c:v libx264 -preset medium -crf 20 -pix_fmt yuv420p \
  -movflags +faststart \
  /tmp/v3_video_only.mp4

echo "=== BGM合成 ==="
ffmpeg -y -i /tmp/v3_video_only.mp4 -i "${BGM}" \
  -map 0:v -map 1:a \
  -c:v copy -c:a aac -b:a 192k \
  -shortest -movflags +faststart \
  "${OUT}"

echo "=== 完了 ==="
echo "出力: $(pwd)/${OUT}"
ls -lh "${OUT}"
ffprobe -v quiet -show_entries format=duration -show_entries stream=codec_name,width,height -of default=noprint_wrappers=1 "${OUT}"
