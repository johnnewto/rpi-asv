#!/bin/bash
# Stream Raspberry Pi camera to QGroundControl using GStreamer
# scan wifi networks, star link is close and strong so it should switch to it
sudo wpa_cli -i wlan0 scan
sleep 1
# list wifi networks
sudo wpa_cli -i wlan0 list_networks

gst-launch-1.0 \
  libcamerasrc ! \
  capsfilter caps=video/x-raw,format=NV12,framerate=10/1 ! \
  v4l2convert ! \
  capsfilter caps=video/x-raw,width=640,height=480 ! \
  v4l2h264enc extra-controls="controls,video_bitrate_mode=0,video_bitrate=500000,h264_i_frame_period=10,h264_profile=4" ! \
  'video/x-h264,level=(string)4' ! \
  h264parse  config-interval=1 ! \
  rtph264pay ! \
  udpsink host=100.64.169.127 port=5600 sync=0