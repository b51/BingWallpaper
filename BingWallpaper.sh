#!/bin/bash
localDir="$HOME/Pictures/BingWallpaper"
log="$localDir/log.log"
# today: 0, yesterday: 1, tomorrow: -1
daysBefore=0
filenameRegex=".*"$(date -d"-${daysBefore} days ago" "+%Y-%m-%d")".*jpg"
bingDailyUrl="http://www.bing.com/HPImageArchive.aspx?format=xml&idx=$daysBefore&n=1&mkt=zh-CN"

findResult=$(find $localDir -regex $filenameRegex)
if [ ! -n "$findResult" ]; then
    baseUrl="cn.bing.com"
    imgurl=$(expr "$(curl -L $bingDailyUrl)" : ".*<url>\(.*\)</url>")
    imgurl=${imgurl/1920x1080/UHD}
    filename=$(expr "$imgurl" : ".*id=OHR.\(.*\)&amp;rf")
    localpath="$localDir/$(date -d "$daysBefore days ago" "+%Y-%m-%d")-$filename"
    echo $localpath
    curl -o $localpath $baseUrl$imgurl
    gsettings set org.gnome.desktop.background picture-uri "file://$localpath"
    copyright=$(expr "$(curl -L $bingDailyUrl)" : ".*<copyright>\(.*\)</copyright>")
    echo "$(date +"%Y-%m-%d %H:%M:%S") Downloaded $filename" >> $log
    echo "$copyright" >> $log
else
    echo "$(date +"%Y-%m-%d %H:%M:%S") Exist" >> $log
    exit 0
fi
