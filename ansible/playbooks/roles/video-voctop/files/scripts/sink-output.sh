#!/bin/sh

confdir="`dirname "$0"`/../config/"
. ${confdir}/defaults.sh
. ${confdir}/config.sh

ffmpeg -v error -y -nostdin \
	-probesize 10M \
	-analyzeduration 10M \
	-i tcp://localhost:11000 \
	-threads:0 0 \
	-aspect 16:9 \
	-c:v libx264 \
	-g 45 \
	-maxrate:v:0 2000k -bufsize:v:0 8192k \
	-pix_fmt:0 yuv420p -profile:v:0 main -b:v 512k \
	-preset:v:0 veryfast \
	\
	-ac 2 -strict -2 -c:a aac -b:a 128k -ar 48000 \
	-map 0:v \
	-map 0:a \
	-y -f mpegts - | /usr/local/bin/sproxy
