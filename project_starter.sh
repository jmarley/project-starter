#!/bin/bash

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

#TODO test script below
COUNTER=0
while [ $COUNTER -lt $3 ]; do
  #make directory e.g., cluster/hostname01/images
  mkdir -p $1/$2/cluster/${4}0${3}/images
  mkdir -p $1/$2/cluster/${4}0${3}/iso

  #copy basic user data file over to directory
  cp /home/jmarley/projects/project\ starter/user-data \
  $1/$2/cluster/${4}0${COUNTER}

  #copy basic meta data file over to directory
  cp /home/jmarley/projects/project\ starter/meta-data \
  $1/$2/cluster/${4}0${COUNTER}

  #TODO update loop to add records to base script files
  let COUNTER=COUNTER+1
done

#copy bounce script
cp /home/jmarley/projects/project\ starter/bounce_servers.sh  $1/$2/workspace/scripts/bounce_cluster.sh
cp /home/jmarley/projects/project\ starter/server_tabs \$1/$2/workspace/scripts
cp /home/jmarley/projects/project\ starter/shutdown_servers.sh $1/$2/workspace/scripts
cp /home/jmarley/projects/project\ starter/start_servers.sh  $1/$2/workspace/scripts
cp /home/jmarley/projects/project\ starter/ssh_alias $1/$2/workspace/scripts
ssh_alias  start_servers.sh
