#!/bin/sh
localDir="/Users/$USER/Pictures/BingWallpaper"
filenameRegex=".*"$(date "+%Y-%m-%d")".*jpg"
#filenameRegex=$(date)".*txt"
log="$localDir/log.log"
# today: 0, yesterday: 1, tomorrow: -1
date=0
bingDailyUrl="http://www.bing.com/HPImageArchive.aspx?format=xml&idx=$date&n=1&mkt=zh-CN"

findResult=$(find $localDir -regex $filenameRegex)
if [ ! -n "$findResult" ]; then
    baseUrl="cn.bing.com"
    #imgurl=$(expr "$(curl -L $bingDailyUrl | grep hprichbg)" : '.*url: "/az/hprichbg\(.*\)"};g_img')
    imgurl=$(expr "$(curl -L $bingDailyUrl)" : ".*<url>\(.*\)</url>")
    filename=$(expr "$imgurl" : ".*id=OHR.\(.*\)&amp;rf")
    localpath="$localDir/$(date "+%Y-%m-%d")-$filename"
    curl -o $localpath $baseUrl$imgurl
    echo "$baseUrl$imgurl"
    osascript -e "                              \
        tell application \"System Events\" to   \
            tell desktop 1 to                   \
                set picture to \"$localpath\""
    osascript -e "display notification \"$filename Downloaded\" with title \"BingWallpaper\""
    echo "$(date +"%Y-%m-%d %H:%M:%S") Downloaded $filename" >> $log
else
    echo "$(date +"%Y-%m-%d %H:%M:%S") Exist" >> $log
    exit 0
fi
