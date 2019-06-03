#!/bin/sh
localDir="/$HOME/Pictures/BingWallpaper"
log="$localDir/log.log"
# today: 0, yesterday: 1, tomorrow: -1
n=0
filenameRegex=".*"$(date -d "$n days ago" "+%Y-%m-%d")".*jpg"
bingDailyUrl="http://www.bing.com/HPImageArchive.aspx?format=xml&idx=$n&n=1&mkt=zh-CN"

findResult=$(find $localDir -regex $filenameRegex)
if [ ! -n "$findResult" ]; then
    baseUrl="cn.bing.com"
    #imgurl=$(expr "$(curl -L $bingDailyUrl | grep hprichbg)" : '.*url: "/az/hprichbg\(.*\)"};g_img')
    imgurl=$(expr "$(curl -L $bingDailyUrl)" : ".*<url>\(.*\)</url>")
    filename=$(expr "$imgurl" : ".*id=OHR.\(.*\)&amp;rf")
    localpath="$localDir/$(date -d "$n days ago" "+%Y-%m-%d")-$filename"
    curl -o $localpath $baseUrl$imgurl
    echo "$baseUrl$imgurl"
    gsettings set org.gnome.desktop.background picture-uri "file://$localpath"
    copyright=$(expr "$(curl -L $bingDailyUrl)" : ".*<copyright>\(.*\)</copyright>")
    echo "$(date +"%Y-%m-%d %H:%M:%S") Downloaded $filename" >> $log
    echo "$copyright" >> $log
else
    echo "$(date +"%Y-%m-%d %H:%M:%S") Exist" >> $log
    exit 0
fi
