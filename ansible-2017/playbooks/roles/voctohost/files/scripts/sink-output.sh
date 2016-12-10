#!/bin/sh

confdir="`dirname "$0"`/../config/"
. ${confdir}/defaults.sh
. ${confdir}/config.sh

ffmpeg -y -nostdin \
	-i tcp://localhost:11000 \
	-threads:0 0 \
	-aspect 16:9 \
	-c:v libx264 \
	-maxrate:v:0 2000k -bufsize:v:0 8192k \
	-pix_fmt:0 yuv420p -profile:v:0 main -b:v 512k \
	-preset:v:0 ultrafast \
	\
	-ac 2 -c:a libfdk_aac -b:a 128k -ar 44100 \
	-map 0:v \
	-map 0:a \
	\
	-y -flags +global_header -bsf:a aac_adtstoasc -f tee "${RECORDING_DIRECTORY}/${ROOM}.`date +%s`.ts|[f=flv]${STREAM_DESTINATION}"
