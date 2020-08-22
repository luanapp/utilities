#!/usr/bin/env bash

OPT=~/opt
VERSION=1.8
JAVA_FOLDER=$OPT

parse_opts() {
  if [ $# -eq 1 ]; then OPT=$1 && return; fi

  while [ $# -gt 0 ]
  do
    case $1 in
      --opt|-o)
        shift
        OPT=$1
        shift
        ;;
      *)
        echo >&2 "Invalid parameter $1" && show_usage
        break;;
    esac
  done
}

show_usage() {
  echo "TODO"
}

select_version() {
  VERSIONS=($(find $OPT -maxdepth 1 -type d -name "*jdk*" | tr -d '-' | grep -oP '(?<=jdk)([0-9]\.[0-9]|[0-9]{2})[0-9._]*'))
  ARR_SIZE=$(expr ${#VERSIONS[@]} - 1)

  echo "Select java version:"
  for i in $(seq 0 $ARR_SIZE)
  do
    echo "$(expr $i + 1): JKD version ${VERSIONS[i]}"
  done

  echo -ne "Select: " && read opt
  VERSION=${VERSIONS[$(expr $opt - 1)]}
}

select_folder() {
  echo -e "\nSelected version: $VERSION"
  JAVA_FOLDER=$(find $OPT -maxdepth 1 -type d -name "*jdk*" | grep -P "jdk.?$VERSION")
}

create_symlink() {
  rm -rf $OPT/java
  ln -s $JAVA_FOLDER $OPT/java
}

parse_opts $@
select_version
select_folder
create_symlink
