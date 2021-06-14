#!/bin/bash

LANG=C
sum=0
acsum=0
feedline=73

p1="Name"
p2="Actual"
p3="RSS"
i=$feedline
printf "%30s %20s %20s\n" $p1 $p2 $p3
while [ $i -gt 1 ]; do printf "-"; i=$(($i-1)); done
printf "\n"
for item in $(virsh list | grep running | awk '{print $2}')
do
    virsh dommemstat $item  > /tmp/vm_stat
    act=$(grep actual /tmp/vm_stat | awk '{print $NF}')
    rss=$(grep rss /tmp/vm_stat | awk '{print $NF}')
    #echo "VM :: $item \t $act \t $rss"
    printf "%30s %20d %20d" $item $act $rss
    rm -rf /tmp/vm_stat
    echo ""
    size=$(virsh dommemstat $item | grep rss | awk '{print $NF}')
    acsize=$(virsh dommemstat $item | grep actual | awk '{print $NF}')
    sum=$(($sum + $size))
    acsum=$(($acsum + $acsize))
done
share=$((sum/1024/1024))
rest=$((sum/1024%1024))
i=$feedline
while [ $i -gt 1 ]; do printf "-"; i=$(($i-1)); done
printf "\n"
empty=""
printf "%50s" $empty
printf "RSS Total : %d.%d GB\n" $share $rest
share=$((acsum/1024/1024))
rest=$((acsum/1024%1024))
printf "%50s" ""
printf "ACT Total : %d.%d GB\n" $share $rest
