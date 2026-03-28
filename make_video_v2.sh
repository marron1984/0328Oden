#!/bin/bash
set -e

cd /home/user/0328Oden
FONT_BOLD="/usr/share/fonts/opentype/noto/NotoSansCJK-Bold.ttc"
FONT_REG="/usr/share/fonts/opentype/noto/NotoSansCJK-Regular.ttc"
W=1080
H=1920
FPS=30
OUT="oden_stand_summer.mp4"

D_OPEN=4
D_SLIDE=5
D_END=6

echo "=== カット1: 春の桜オープニング ==="
ffmpeg -y -loop 1 -i /tmp/spring_opening.png \
  -vf "scale=${W}:${H},zoompan=z='1.0+0.08*on/$((D_OPEN*FPS))':x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':d=$((D_OPEN*FPS)):s=${W}x${H}:fps=${FPS},drawtext=fontfile=${FONT_BOLD}:text='夏、はじめました。':fontsize=72:fontcolor=white:borderw=2:bordercolor=black@0.3:x=(w-text_w)/2:y=(h-text_h)/2:alpha='if(lt(t,0.8),t/0.8,if(gt(t,3.2),(4-t)/0.8,1))',fade=t=in:st=0:d=1" \
  -c:v libx264 -pix_fmt yuv420p -t ${D_OPEN} /tmp/v2_clip_00.mp4

echo "=== カット2: 鮮魚アップ gp_18 ==="
ffmpeg -y -loop 1 -i gp_18.JPG \
  -vf "scale=2160:3840:force_original_aspect_ratio=increase,crop=2160:3840,zoompan=z='1.0+0.3*on/$((D_SLIDE*FPS))':x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':d=$((D_SLIDE*FPS)):s=${W}x${H}:fps=${FPS},drawtext=fontfile=${FONT_BOLD}:text='朝獲れ鮮魚の、お造り':fontsize=48:fontcolor=white:borderw=3:bordercolor=black@0.6:x=(w-text_w)/2:y=h*0.82:alpha='if(lt(t,0.5),t/0.5,if(gt(t,4.5),(5-t)/0.5,1))'" \
  -c:v libx264 -pix_fmt yuv420p -t ${D_SLIDE} /tmp/v2_clip_01.mp4

echo "=== カット3: 鮮魚引き gp_17 ==="
ffmpeg -y -loop 1 -i gp_17.JPG \
  -vf "scale=2160:3840:force_original_aspect_ratio=increase,crop=2160:3840,zoompan=z='1.15':x='iw/2-(iw/zoom/2)':y='ih*0.25-ih*0.1*on/$((D_SLIDE*FPS))':d=$((D_SLIDE*FPS)):s=${W}x${H}:fps=${FPS},drawtext=fontfile=${FONT_BOLD}:text='今日のおすすめ、揃ってます':fontsize=48:fontcolor=white:borderw=3:bordercolor=black@0.6:x=(w-text_w)/2:y=h*0.82:alpha='if(lt(t,0.5),t/0.5,if(gt(t,4.5),(5-t)/0.5,1))'" \
  -c:v libx264 -pix_fmt yuv420p -t ${D_SLIDE} /tmp/v2_clip_02.mp4

echo "=== カット4: おでんアップ gp_14 ==="
ffmpeg -y -loop 1 -i gp_14.JPG \
  -vf "scale=2160:3840:force_original_aspect_ratio=increase,crop=2160:3840,zoompan=z='1.3-0.3*on/$((D_SLIDE*FPS))':x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':d=$((D_SLIDE*FPS)):s=${W}x${H}:fps=${FPS},drawtext=fontfile=${FONT_BOLD}:text='出汁で炊いた、夏野菜おでん':fontsize=48:fontcolor=white:borderw=3:bordercolor=black@0.6:x=(w-text_w)/2:y=h*0.82:alpha='if(lt(t,0.5),t/0.5,if(gt(t,4.5),(5-t)/0.5,1))'" \
  -c:v libx264 -pix_fmt yuv420p -t ${D_SLIDE} /tmp/v2_clip_03.mp4

echo "=== カット5: おでん引き gp_13 ==="
ffmpeg -y -loop 1 -i gp_13.JPG \
  -vf "scale=2160:3840:force_original_aspect_ratio=increase,crop=2160:3840,zoompan=z='1.15':x='iw/2-(iw/zoom/2)':y='ih*0.05+ih*0.1*on/$((D_SLIDE*FPS))':d=$((D_SLIDE*FPS)):s=${W}x${H}:fps=${FPS},drawtext=fontfile=${FONT_BOLD}:text='ひんやり冷菜も、じんわりおでんも':fontsize=44:fontcolor=white:borderw=3:bordercolor=black@0.6:x=(w-text_w)/2:y=h*0.82:alpha='if(lt(t,0.5),t/0.5,if(gt(t,4.5),(5-t)/0.5,1))'" \
  -c:v libx264 -pix_fmt yuv420p -t ${D_SLIDE} /tmp/v2_clip_04.mp4

echo "=== カット6: 全品俯瞰 gp_41 ==="
ffmpeg -y -loop 1 -i gp_41.JPG \
  -vf "scale=2160:3840:force_original_aspect_ratio=increase,crop=2160:3840,zoompan=z='1.3-0.3*on/$((D_SLIDE*FPS))':x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':d=$((D_SLIDE*FPS)):s=${W}x${H}:fps=${FPS},drawtext=fontfile=${FONT_BOLD}:text='おでんだけじゃない、この品揃え。':fontsize=44:fontcolor=white:borderw=3:bordercolor=black@0.6:x=(w-text_w)/2:y=h*0.82:alpha='if(lt(t,0.5),t/0.5,if(gt(t,4.5),(5-t)/0.5,1))'" \
  -c:v libx264 -pix_fmt yuv420p -t ${D_SLIDE} /tmp/v2_clip_05.mp4

echo "=== カット7: 店舗情報エンディング ==="
ffmpeg -y -loop 1 -i /tmp/spring_ending.png \
  -vf "scale=${W}:${H},zoompan=z='1.0+0.05*on/$((D_END*FPS))':x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':d=$((D_END*FPS)):s=${W}x${H}:fps=${FPS},fade=t=in:st=0:d=1,fade=t=out:st=$((D_END-1)):d=1" \
  -c:v libx264 -pix_fmt yuv420p -t ${D_END} /tmp/v2_clip_06.mp4

echo "=== 結合 ==="
cat > /tmp/v2_concat.txt << 'EOF'
file '/tmp/v2_clip_00.mp4'
file '/tmp/v2_clip_01.mp4'
file '/tmp/v2_clip_02.mp4'
file '/tmp/v2_clip_03.mp4'
file '/tmp/v2_clip_04.mp4'
file '/tmp/v2_clip_05.mp4'
file '/tmp/v2_clip_06.mp4'
EOF

ffmpeg -y -f concat -safe 0 -i /tmp/v2_concat.txt \
  -c:v libx264 -preset medium -crf 20 -pix_fmt yuv420p \
  -movflags +faststart \
  "${OUT}"

echo "=== 完了 ==="
echo "出力: $(pwd)/${OUT}"
ls -lh "${OUT}"
ffprobe -v quiet -show_entries format=duration -show_entries stream=width,height -of default=noprint_wrappers=1 "${OUT}"
