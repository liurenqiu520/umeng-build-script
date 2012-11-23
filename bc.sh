#! /bin/sh  -eu
  
build()
{
	export UMENG_CHANNEL=$1  
	cp AndroidManifest.xml.bk AndroidManifest.xml 
	ant -f build_channel.xml release-channel
}

usage()
{
cat << EOF
usage: $0 options

OPTIONS:
   -h      Show this message
   -t      Build with test channel 
   -a      Build All Channels
   -s	   Build single channel
EOF
}

chans=
while getopts “htas:” OPTION
do
     case $OPTION in
         h)
             usage
             exit 1
             ;;
         t)
	chans="test" 
             ;;
         a)
	chans="chan1;chan2" #渠道名 用「;」分隔
             ;;
	 s)
	chans="$OPTARG"
	    ;;
         ?)
             usage
             exit
             ;;
     esac
done
if [[ -z $chans ]]
then
     usage
     exit 1
fi
echo "build channels: $chans"
sleep 1

cp AndroidManifest.xml AndroidManifest.xml.bk
arrIN=(${chans//;/ })
for i in "${arrIN[@]}"; do
	echo "start build $i"
	sleep 2
	build $i
done
mv AndroidManifest.xml.bk AndroidManifest.xml
