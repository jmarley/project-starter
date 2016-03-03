#!/bin/bash

#TODO checkout trello board.
# path of new project
if [ -z $1 ]; then
  echo "please add a path";
  exit ;
fi

# Verify it exists
if [ ! -d $1 ]; then
  echo "please add a path that exists";
  exit ;
fi

# add project name
if [ -z $2 ]; then
  echo "please add a project name";
  exit;
fi

# verify project name doesn't already exist
if [ -d $1"/"$2 ]; then
  echo "This path already exists, please pick another name";
  exit ;
fi

# get cluster size
if [ -z $3 ]; then
  echo "Please enter 1 or more servers in cluster";
  exit;
fi

# get Hostname
if [ -z $4 ]; then
  echo "Please enter a hostname for your servers: minion"
  echo "We will build the cluster with minion01...minion0n"
  exit;
fi

# verify cluster has not already been created
if [ -d $1"/"$2"/" ]; then
  echo "This path already exists, please pick another name";
  exit ;
fi

# Make project directories
mkdir -p $1/$2/documents
mkdir -p $1/$2/workspace
mkdir -p $1/$2/expenses
mkdir -p $1/$2/cluster
mkdir -p $1/$2/scripts

# Create Readme
cp /home/jmarley/projects/project\ starter/README-template.adoc $1/$2/README.adoc

# create bounce server script
/bin/cat <<EOF >> $1/$2/scripts/bounce_cluster.sh
#!/bin/bash
# bounce server
EOF
chmod +x $1/$2/scripts/bounce_cluster.sh

# create shutdown server script
/bin/cat <<EOF >> $1/$2/scripts/shutdown_cluster.sh
#!/bin/bash
# shutdown server
EOF
chmod +x $1/$2/scripts/shutdown_cluster.sh

# create start server script
/bin/cat <<EOF >> $1/$2/scripts/start_cluster.sh
#!/bin/bash
# start server
EOF
chmod +x $1/$2/scripts/shutdown_cluster.sh

# create ssh alias commands
/bin/cat <<EOF >> $1/$2/scripts/$2_ssh_alias
#!/bin/bash

# username for ssh key
username=

# ssh key directory
ssh_key=

# ssh alias server
EOF
chmod +x $1/$2/scripts/shutdown_cluster.sh

COUNTER=1
while [ $COUNTER -le $3 ]; do
  #make directory e.g., cluster/hostname01/images
  mkdir -p $1/$2/cluster/${4}0${COUNTER}/images
  mkdir -p $1/$2/cluster/${4}0${COUNTER}/iso

  #copy basic user data file over to directory
  cp /home/jmarley/projects/project\ starter/user-data \
  $1/$2/cluster/${4}0${COUNTER}

  #copy basic meta data file over to directory
  cp /home/jmarley/projects/project\ starter/meta-data \
  $1/$2/cluster/${4}0${COUNTER}/

  #add the hostname of the server to the meta-data file
  sed -i "s/<hostname>/${4}0${COUNTER}/" $1/$2/cluster/${4}0${COUNTER}/meta-data

  #add the hostname of the server to the meta-data file
  sed -i "s/<instance-id>/$2-${4}0${COUNTER}/" $1/$2/cluster/${4}0${COUNTER}/meta-data

  # add server bounce commands
  /bin/cat <<EOF >> $1/$2/scripts/bounce_cluster.sh
virsh destroy ${4}0${COUNTER}
sleep 5
virsh start ${4}0${COUNTER}
EOF

  # add server shutdown commands
  /bin/cat <<EOF >> $1/$2/scripts/shutdown_cluster.sh
virsh shutdown ${4}0${COUNTER}
EOF

  # add server start commands
  /bin/cat <<EOF >> $1/$2/scripts/start_cluster.sh
virsh start ${4}0${COUNTER}
EOF

  # create ssh alias commands
  /bin/cat <<EOF >> $1/$2/scripts/$2_ssh_alias
${4}0${COUNTER}_ip=
# example
# alias ${4}0${COUNTER}="ssh -i ${ssh_key} ${user_name}@${4}0${COUNTER}_ip"'
EOF

  let COUNTER=COUNTER+1
done

#copy bounce script
#cp /home/jmarley/projects/project\ starter/server_tabs $1/$2/scripts
