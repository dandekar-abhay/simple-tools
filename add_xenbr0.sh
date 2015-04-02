#!/bin/bash


# This is untested on all platforms but working on RHEL script
# And will not work over the network
# Can be executed via a screen session holding a TTY connection

echo "Enter the interface you wish to add to xenbr0"
read IFACE

echo "Interface details are : "
ipconfig $IFACE

echo "Enter the IP you wish to assign to xenbr0 ( Ideally, you should use the same as the interface entered above )"
read IP_ADDRESS

echo "Enter the netmask : (Default should be 255.255.255.0)  "
read NETMASK

echo "Enter the gateway IP addr"
read GATEWAY


ifconfig $IFACE 0.0.0.0
brctl addbr xenbr0
brctl addif xenbr0 $IFACE
#ifconfig xenbr0 <YOUR_ETH0_IP_HERE> netmask 255.255.255.0 up
ifconfig xenbr0 $IP_ADDRESS netmask $NETMASK up
#route add default gw <YOUR_GW_IP_HERE> xenbr0
route add default gw $GATEWAY xenbr0

route -n

exit

# Test pinging 8.8.8.8

ping -c 1 8.8.8.8
if [ $? -eq 0 ] ; then
        echo "Bridge added successfully"
else
        echo "Brigde might be added but unable to ping internet"
fi

