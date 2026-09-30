FROM ubuntu:latest
​ENV DEBIAN_FRONTEND=noninteractive
​RUN apt-get update && apt-get install -y 
ffmpeg 
curl 
python3 
ca-certificates 
&& rm -rf /var/lib/apt/lists/*
​RUN curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp && chmod a+rx /usr/local/bin/yt-dlp
​WORKDIR /app
​RUN echo '#!/bin/bash\n
echo "Downloading video..."\n
yt-dlp -o "video.mp4" "https://www.mediafire.com/file/yol3ekou9uousft/YouCut_20260930_110104013.mp4/file"\n
echo "Starting Live Stream..."\n
while true; do\n
ffmpeg -re -stream_loop -1 -i video.mp4 -c:v libx264 -preset ultrafast -b:v 2500k -maxrate 2500k -bufsize 5000k -pix_fmt yuv420p -g 60 -c:a aac -b:a 128k -ar 44100 -f flv "rtmp://a.rtmp.youtube.com/live2/${YOUTUBE_STREAM_KEY}" || true\n
sleep 5\n
done' > start.sh && chmod +x start.sh
​CMD ["./start.sh"]
