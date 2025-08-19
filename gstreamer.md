# Stream video from a Raspberry Pi camera to QGroundControl (QGC) using GStreamer

### Install Gstreamer 
```bash
# install a missing dependency
sudo apt-get install libx264-dev libjpeg-dev
# install the remaining plugins

sudo apt-get update
sudo apt-get install libgstreamer1.0-dev \
     libgstreamer-plugins-base1.0-dev \
     libgstreamer-plugins-bad1.0-dev \
     gstreamer1.0-plugins-ugly \
     gstreamer1.0-tools \
     gstreamer1.0-gl \
     gstreamer1.0-gtk3 \
     gstreamer1.0-plugins-base \
     gstreamer1.0-plugins-good \
     gstreamer1.0-plugins-bad \
     gstreamer1.0-libav

```sh
gst-launch-1.0 --version
```
You should see output similar to this, confirming the installation:
```bash
gst-launch-1.0 version 1.18.4
GStreamer 1.18.4
http://packages.qa.debian.org/gstreamer1.0
```
y
Test a Simple Pipeline:
Test if videoconvert works with a basic pipeline to confirm installation:
```bash
gst-launch-1.0 videotestsrc ! videoconvert ! autovideosink
```
If you see a test video, the installation is successful.

Another test using the camera
```bash
gst-launch-1.0 libcamerasrc ! video/x-raw, width=640, height=480, framerate=30/1 ! videoconvert ! videoscale ! clockoverlay time-format="%D %H:%M:%S" ! autovideosink
```

### To stream video from a Raspberry Pi camera to QGroundControl (QGC) using GStreamer
For Raspberry Pi OS Bullseye with libcamera use the following pipeline to stream H.264 video over UDP to QGC:
``` sh
gst-launch-1.0 libcamerasrc ! capsfilter caps=video/x-raw,format=NV12,framerate=10/1 ! v4l2convert ! capsfilter caps=video/x-raw,width=1280,height=1080 ! v4l2h264enc extra-controls="controls,video_bitrate_mode=0,video_bitrate=5000000,h264_i_frame_period=10,h264_profile=4" ! 'video/x-h264,level=(string)4' ! h264parse ! rtph264pay ! udpsink host=john-PC port=5600 sync=0
```

QGroundControl can then connect to the stream 

