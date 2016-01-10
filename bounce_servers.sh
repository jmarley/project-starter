#!/bin/bash

server01=
server02=
server03=

# destroy servers
virsh destroy ${server01}
virsh destroy ${server02}
virsh destroy ${server03}

# start servers
virsh start ${server01}
virsh start ${server02}
virsh start ${server03}
