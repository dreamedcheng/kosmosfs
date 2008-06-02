#!/usr/bin/bash
#
# $Id: metabkup.sh 36 2007-11-12 02:43:36Z sriramsrao $
#
#
# This file is part of Kosmos File System (KFS).
#
# Licensed under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License. You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
# implied. See the License for the specific language governing
# permissions and limitations under the License.
#
# Script to copy the metaserver checkpoint files to a remote node.
# The same script can also be used to restore the checkpoint files
# from remote path to local.
# 

# process any command-line arguments
# TEMP=`getopt -o d:b:R:h -l dir:,backup:,recover:help -n metabkup.sh -- "$@"`
# eval set -- "$TEMP"

set -- `getopt d:b:R:h $*`

recover=0
# while true
for i in $*
do
	case "$i" in
	-d|--dir) cpdir=$2;;
	-b|--backup) backup_dir=$2;;
	-R|--recover) recover=1;;
	-h|--help) echo "usage: $0 [-d cpdir] [-b backup] {-recover}"; exit ;;
	--) break ;;
	esac
done

if [ ! -d $cpdir ];
    then
    echo "$cpdir is non-existent"
    exit -1
fi

if [ $recover -eq 0 ];
    then
    rsync -avz --delete $cpdir $backup_dir
else
    # Restore the checkpoint files from remote node
    rsync -avz $backup_dir $cpdir
fi    
