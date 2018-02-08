#!/bin/bash

#分页语音读书工具，使用方式:
#./rr.sh [filepath] [page]
# filepath 是指定文本的路径
# page 是指定的读书页数

declare -i page=1
declare -i perPage=50

if [ -n "$2" ];then
page=$2
fi

declare -i pages=`wc -l $1 | awk '{print $1}'`
let pages=1+pages/perPage

while ((page<=pages));do
    declare -i from=page*perPage
    lines=`head -n $from $1 | tail -n $perPage`
    echo $page $lines
    say -r 300 "$lines"
    let page++
done 
