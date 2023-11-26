#!/bin/bash

# v4l2-ctl --set-edid=file=/home/user/1080P60EDID.txt --fix-edid-checksums
v4l2-ctl --set-edid=file=/home/user/live-screen/1080P50EDID.txt --fix-edid-checksums

v4l2-ctl --query-dv-timings

v4l2-ctl --set-dv-bt-timings query

v4l2-ctl -V

v4l2-ctl -v pixelformat=UYVY

# gst-launch-1.0 v4l2src ! "video/x-raw,framerate=30/1,format=UYVY" ! v4l2h264enc extra-controls="controls,h264_profile=4,h264_level=10,video_bitrate=256000;" ! video/x-h264,profile=high ! h264parse ! queue ! matroskamux ! filesink location=foo.mkv

# v4l2-ctl -d /dev/video0 --set-fmt-video=pixelformat=YUYV --stream-mmap --stream-count=50 --stream-to=video.yuv

# better quality per mb, bad performance:
# ffmpeg -f v4l2 -framerate 50 -video_size 1920x1080 -i /dev/video0 -c:v libx264 -t 10 -fps_mode vfr -b:v 10M output.mp4

# works good:
# ffmpeg -f v4l2 -framerate 50 -video_size 1920x1080 -i /dev/video0 -c:v h264_v4l2m2m -fps_mode vfr -t 10  -b:v 10M output.mp4



# ffmpeg -f v4l2 -framerate 50 -video_size 1920x1080 -i /dev/video0  -hls_list_size 30 -hls_flags delete_segments+append_list+omit_endlist -hls_list_size 1 -c:v h264_v4l2m2m -fps_mode cfr -f hls ~/out.m3u8


# stream
# ffmpeg -f v4l2 -framerate 50 -video_size 1920x1080 -i /dev/video0 -fps_mode vfr -c:v h264_v4l2m2m  -b:v 10M   -hls_list_size 10 -hls_flags delete_segments+append_list+omit_endlist -f hls ./stream/out.m3u8 
# ffmpeg -f v4l2 -framerate 50 -video_size 1920x1080 -i /dev/video0  -force_key_frames "expr:gte(t,n_forced*10)" -strict -2 -fps_mode vfr -c:v h264_v4l2m2m  -b:v 10M   -hls_list_size 10 -hls_flags delete_segments+append_list+omit_endlist -f hls ./stream/out.m3u8 



# ffmpeg -f v4l2 -framerate 50 -video_size 1920x1080 -i /dev/video0      -fps_mode vfr -c:v h264_v4l2m2m  -b:v 10M       -force_key_frames "expr:gte(t,n_forced*10)" -strict -2 -f segment -segment_list_type m3u8 -segment_list_size 5 -segment_time 1.0 -segment_time_delta 0.1 -segment_list stream/out.m3u8  stream/out%02d.ts 


ffmpeg -f v4l2 -framerate 50 -video_size 1920x1080 -i /dev/video0      -fps_mode vfr -c:v h264_v4l2m2m  -b:v 10M   -f segment -segment_list_type m3u8 -segment_list_size 15 -segment_time 0.5 -segment_time_delta 0.0 -segment_list stream/out.m3u8  stream/out%02d.ts 


