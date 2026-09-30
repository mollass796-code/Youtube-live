FROM ubuntu:latest
RUN apt-get update && apt-get install -y ffmpeg python3 python3-pip curl
WORKDIR /app

RUN echo 'import requests\nfrom bs4 import BeautifulSoup\npage_url = "https://www.mediafire.com/file/yol3ekou9uousft/YouCut_20260930_110104013.mp4/file"\nheaders = {"User-Agent": "Mozilla/5.0"}\nresponse = requests.get(page_url, headers=headers)\nsoup = BeautifulSoup(response.text, "html.parser")\ndownload_btn = soup.find("a", {"id": "downloadButton"})\nprint(download_btn["href"] if download_btn else "")' > get_link.py

RUN echo '#!/bin/bash\nDIRECT_URL=$(python3 get_link.py)\ncurl -L "$DIRECT_URL" -o video.mp4\nwhile true; do\n  ffmpeg -re -stream_loop -1 -i video.mp4 -c:v libx264 -preset ultrafast -b:v 2500k -maxrate 2500k -bufsize 5000k -pix_fmt yuv420p -g 60 -c:a aac -b:a 128k -ar 44100 -f flv "rtmp://a.rtmp.youtube.com/live2/${YOUTUBE_STREAM_KEY}" || true\n  sleep 5\ndone' > start.sh && chmod +x start.sh

CMD ["./start.sh"]
