FROM ubuntu:latest
​ENV DEBIAN_FRONTEND=noninteractive
​RUN apt-get update && apt-get install -y 
ffmpeg 
python3 
python3-pip 
curl 
&& rm -rf /var/lib/apt/lists/*
​RUN pip3 install --break-system-packages yt-dlp requests beautifulsoup4 || pip3 install yt-dlp requests beautifulsoup4
​WORKDIR /app
​RUN echo 'import requests, sys\nfrom bs4 import BeautifulSoup\nurl = "https://www.mediafire.com/file/yol3ekou9uousft/YouCut_20260930_110104013.mp4/file"\nheaders = {"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64)"}\ntry:\n    r = requests.get(url, headers=headers)\n    soup = BeautifulSoup(r.text, "html.parser")\n    btn = soup.find("a", {"id": "downloadButton"})\n    if btn and "href" in btn.attrs:\n        print(btn["href"])\n    else:\n        print("")\nexcept Exception as e:\n    print("")' > get_link.py
​RUN echo '#!/bin/bash\n
echo "Fetching video download link..."\n
DIRECT_URL=$(python3 get_link.py)\n
if [ -z "DIRECT_URL" ]; then\n\
DIRECT_URL=(yt-dlp -g "https://www.mediafire.com/file/yol3ekou9uousft/YouCut_20260930_110104013.mp4/file")\n
fi\n
echo "Downloading video..."\n
curl -L -A "Mozilla/5.0" "DIRECT_URL" -o video.mp4\n\
echo "Starting Live Stream..."\n\
while true; do\n\
ffmpeg -re -stream_loop -1 -i video.mp4 -c:v libx264 -preset ultrafast -b:v 2500k -maxrate 2500k -bufsize 5000k -pix_fmt yuv420p -g 60 -c:a aac -b:a 128k -ar 44100 -f flv "rtmp://a.rtmp.youtube.com/live2/{YOUTUBE_STREAM_KEY}" || true\n
sleep 5\n
done' > start.sh && chmod +x start.sh
​CMD ["./start.sh"]
