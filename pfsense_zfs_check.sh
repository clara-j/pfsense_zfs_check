#!/bin/sh


#Modify this line if you want to change the allowed utilization for the pool
max_capacity=50


healthy_state="all pools are healthy"

_V=0
while getopts "v" OPTION
do
  case $OPTION in
    v) _V=1
       ;;
  esac
done


#Check health status of drive
pool_status=`zpool status -x`

if [ $_V -eq 1  ]; then
    echo "--------------------------"
    echo "------  Pool Status  -----"
    echo "--------------------------"
    zpool status
fi


if [ "$pool_status" = "$healthy_state"  ]; then
    echo "------  All pools are OK -"
    echo ""
    echo "------  Starting Scrubs  -"

    #Trigger Scrub again for drives
    zpool list -H |  while read line; do
        pool=`echo "$line" | cut -f1`
        echo "Triggering scrub for: $pool"
        #zpool scrub "$pool"
    done

else
    echo "!! There is an error with one of the pools  !!"

    #Send email warning
    echo "$pool_status" | /usr/local/bin/php /usr/local/bin/mail.php -s"`hostname`: pfSense zpool warning - Error"
fi

echo ""
echo ""
if [ $_V -eq 1  ]; then
    echo "--------------------------"
    echo "------  Checking Space  --"
    echo "--------------------------"
fi


#Check space
/sbin/zpool list -H -o capacity | while read line; do
    capacity=`echo "$line"| cut -d'%' -f1`
    echo "Current capacity for pool is: $capacity"
    if [ "$capacity" -ge "$max_capacity" ]; then
        echo "Drive capacity greater than max"
        echo "Drive capacity at: ${capacity}%"| /usr/local/bin/php /usr/local/bin/mail.php -s"`hostname`: pfSense zpool warning - Capacity reached"
    else
        echo "Drive capcity below max"
    fi
done
