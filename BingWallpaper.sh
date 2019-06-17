#!/bin/sh
localDir="/Users/$USER/Pictures/BingWallpaper"
#filenameRegex=".*"$(date "+%Y-%m-%d")".*jpg"
log="$localDir/log.log"
# today: 0, yesterday: 1, tomorrow: -1
daysBefore=0
filenameRegex=".*"$(date -v"-${daysBefore}d" "+%Y-%m-%d")".*jpg"
bingDailyUrl="http://www.bing.com/HPImageArchive.aspx?format=xml&idx=$daysBefore&n=1&mkt=zh-CN"

findResult=$(find $localDir -regex $filenameRegex)
if [ ! -n "$findResult" ]; then
    baseUrl="cn.bing.com"
    #imgurl=$(expr "$(curl -L $bingDailyUrl | grep hprichbg)" : '.*url: "/az/hprichbg\(.*\)"};g_img')
    imgurl=$(expr "$(curl -L $bingDailyUrl)" : ".*<url>\(.*\)</url>")
    filename=$(expr "$imgurl" : ".*id=OHR.\(.*\)&amp;rf")
    localpath="$localDir/$(date -v"-${daysBefore}d" "+%Y-%m-%d")-$filename"
    echo $localpath
    curl -o $localpath $baseUrl$imgurl
    osascript -e "                              \
        tell application \"System Events\" to   \
            tell desktop 1 to                   \
                set picture to \"$localpath\""
    osascript -e "display notification \"$filename Downloaded\" with title \"BingWallpaper\""
    copyright=$(expr "$(curl -L $bingDailyUrl)" : ".*<copyright>\(.*\)</copyright>")
    echo "$(date +"%Y-%m-%d %H:%M:%S") Downloaded $filename" >> $log
    echo "$copyright" >> $log
else
    echo "$(date +"%Y-%m-%d %H:%M:%S") Exist" >> $log
    exit 0
fi
