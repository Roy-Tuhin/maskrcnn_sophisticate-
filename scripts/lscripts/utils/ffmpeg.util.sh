ffmpeg -framerate 29 -i MAH04240.mp4-%d.png -c:v libx264 -r 30 MAH04240-maskrcnn-viz.mp4
ffmpeg -framerate 29 -i %d_MAH04240.mp4.png -c:v libx264 -r 30 MAH04240-maskrcnn-viz.mp4