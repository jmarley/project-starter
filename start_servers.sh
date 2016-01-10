server01=
server02=

virsh start ${server01}
virsh start ${server02}

sleep 45

konsole --tabs-from-file server_tabs > /dev/null
