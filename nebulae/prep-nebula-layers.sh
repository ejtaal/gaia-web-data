#!/bin/bash

for neb in $(find . -mindepth 1 -type d -printf "%T@ %p\n" | sort -rn | awk '{ print $2 }'); do
	echo "[[ $neb ]]"
	input="$neb/in.jpg"
	output="$neb/out.jpg"
	bmap="$neb/bmap.jpg"
	dmap="$neb/dmap.jpg"
	amap="$neb/amap.jpg"

	if [ ! -f "$input" ]; then
		# Assume we just dropped a jpg/png in there
		FILE="$(ls -1 $neb/* | egrep -i '.(png|jpg|jpeg)' | tail -1)"
		if [ -f "$FILE" ]; then
			echo "Found $FILE , hope that's ok?"
			sleep 5
			cp -vf "$FILE" "$input"
		else
			echo "No file found, skipping, may need to fix?"
			sleep 2
			continue
		fi
	fi

	if [ -s "$output" -a "$output" -nt "$0" ]; then
		echo "$output exists and seems new enough"
	else
		convert -verbose "$input" \
			\( -clone 0 -statistic median 10x10 \) \
			\( -clone 0 -fuzz 10% -fill black +opaque white -fill white +opaque black -negate \) \
			-compose over -composite \
			-modulate 100,120 \
			-resize 1000x1000 \
			-bordercolor black -border 2 \
				"$output"
	fi

	if [ -s "$bmap" -a "$bmap" -nt "$0" ]; then
		echo "$bmap exists and seems new enough"
	else
		convert -verbose "$output" \
			-modulate 100,120 \
			-gaussian-blur 0x10 \
			"$bmap"
	fi
			# -modulate 100,120 \

	if [ -s "$dmap" -a "$dmap" -nt "$0" ]; then
		echo "$dmap exists and seems new enough"
	else
		convert -verbose "$output" \
			-modulate 100,120 \
			-gaussian-blur 0x30 \
			-colorspace HSB  -channel B -separate \
			"$dmap"
	fi
			# -modulate 100,200 \
			# -brightness-contrast 20x40 \
			# -set colorspace Gray \
			# -gaussian-blur 0x30 \

	if [ -s "$amap" -a "$amap" -nt "$0" ]; then
		echo "$amap exists and seems new enough"
	else
		convert -verbose "$output" \
			-gaussian-blur 0x100 \
			-colorspace HSB  -channel B -separate \
			-morphology erode octagon \
			"$amap"
			# -modulate 100,200 \
			# -set colorspace Gray \
			# -brightness-contrast -10x10 \
	fi
done
exit 1

input="$1"
output="test.png"
output="out.jpg"




:||"
	-resize 50x50 \
\( -clone 0 -fuzz 10% -fill white +opaque black -fill black +opaque white -negate \) \

# https://stackoverflow.com/questions/56265704/replace-repaint-all-pixels-with-one-color-in-image-with-interpolated-from-neighb
# This is really good at removing all small stars but leaves bigger ones
\( -clone 0 -statistic median 10x10 \) \
\( -clone 0 -fuzz 10% -fill black +opaque white -fill white +opaque black -negate \) \
-compose over -composite \
	
Works ok, but leaves big stars:
	-fill black -fuzz 3% \
	-opaque white \
  -morphology Smooth Diamond \



	-resize 100x100 \
	-opaque gray \
	comment
	#-resize
	"
