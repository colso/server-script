#!/bin/bash

LANG=C
sum=0
feedline=75

printf "%30s %10s %10s %10s %10s\n" "Name" "Maxcon" "Maxlive" "Curcon" "Curlive"
i=$feedline
while [ $i -gt 1 ]; do printf "-"; i=$(($i-1)); done
printf "\n"
for item in $('virsh list --name')
do

    virsh vcpucount $item  > /tmp/vmcpustat
    vmc=$(grep "maximum      config" /tmp/vmcpustat | awk '{print $NF}')
    vml=$(grep "maximum      live" /tmp/vmcpustat | awk '{print $NF}')
    vcc=$(grep "current      config" /tmp/vmcpustat | awk '{print $NF}')
    vcl=$(grep "current      live" /tmp/vmcpustat | awk '{print $NF}')
    printf "%30s %10d %10d %10d %10d\n" $item $vmc $vml $vcc $vcl
    count=$(virsh vcpucount $item | grep current | grep live | awk '{print $NF}')
    sum=$(($sum + $count))
done

i=$feedline
while [ $i -gt 1 ]; do printf "-"; i=$(($i-1)); done
printf "\n"
printf "%64s" ""
printf "Total : %d\n" $sum
