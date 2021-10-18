#!/bin/bash
Help()
{
   # Display Help
   echo "This script converts any input supported by ffmpeg into a gif with a high quality pallet."
   echo
   echo "Syntax: HD_GifGen.sh [-h] /Path/To/Video"
   echo "options:"
   echo "h     Print this Help."
   echo
}

while getopts ":h" option; do
   case $option in
      h) # display Help
         Help
         exit;;
   esac
done

InFile=$1

eval $(ffprobe -v quiet -show_format -of flat=s=_ -show_entries stream=height,width,nb_frames,duration,codec_name $1);
DurationInSeconds=${streams_stream_0_duration}
fps=$(awk '{print $1/$2}' <<<"${streams_stream_0_nb_frames} $DurationInSeconds")

if (( $fps > 50 ));
then
    ffmpeg -i $1 -c:v gif -filter_complex "[0:v] fps=50,split [a][b];[a] palettegen=reserve_transparent=off [p];[b][p] paletteuse" "$1_conv.gif"
else
    ffmpeg -i $1 -c:v gif -filter_complex "split [a][b];[a] palettegen=reserve_transparent=off [p];[b][p] paletteuse" "$1_conv.gif"
fi