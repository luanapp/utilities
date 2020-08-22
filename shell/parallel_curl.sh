#!/bin/bash


##  The export is required since parallel create n sub shells
##  and these variables are not passed to them
export TMP_DIR=./tmp
CREATE_OUT=./out

parse_opts() {
  export BASE_URL=http://someurl

  if [ $# -eq 0 ]; then
    INPUT_FLE=input
    return
  fi

  while [ $# -gt 0 ]
  do
    case $1 in
      --input-file|-i)
        shift
        export INPUT_FILE=$1
        shift
        ;;
      --help|-h)
        shift
        show_usage
        exit 0;
        ;;
      *)
        echo >&2 "Invalid parameter $1" && show_usage
        break;;
    esac
  done
}

show_usage() {
  echo "Usage ./unavailability.sh [OPTION]"
  echo "When used with no [OPTION], the executed command is: ./parallel_curl.sh -i input"
  echo "Options:"
  cat <<EOF
-i. --input-file Input file with the merchant ids when creating or merchant-id,unavailability-id when removing unavailabilities
-h, --help This help document
EOF
}

check_dependencies() {
  [ -x "$(command -v apk)" ] && sudo apk add --no-cache curl jq parallel
  [ -x "$(command -v apt-get)" ] && sudo apt-get install curl jq parallel
  [ -x "$(command -v dnf)" ] && sudo dnf install curl jq parallel
  [ -x "$(command -v zypper)" ] && sudo zypper install curl jq parallel
}

create_tmp() {
  [ -d "$TMP_DIR" ] || mkdir $TMP_DIR
}

array_from_file() {
    array=()
    while IFS= read -r line
    do
        array+=("$line")
    done < "$1"
}

exec_curl() {
  curl -X POST \
    "$BASE_URL/some/url" \
    -H 'Content-Type: application/json' \
    -H 'cache-control: no-cache' \
    -d '{
  	  "foo": "bar",
	    "description": "Some old plain text."
    }' | jq '.id' | tr -d \" | xargs -i echo -e "$1,{}"  > "$TMP_DIR/$1" 
}

create_parallel_curl() {
  array_from_file ${INPUT_FILE:-./merchants}
  export -f exec_curl
  parallel --jobs 4 exec_curl {1} ::: ${array[@]}
}

merge_files() {
  for file in `ls -1 $TMP_DIR`; do
    cat "$TMP_DIR/$file" >> $OUT_FILE
  done
  rm -rf $TMP_DIR
}


parse_opts $@
check_dependencies
create_tmp
rm -rf $OUT_FILE
create_parallel_curl
merge_files

