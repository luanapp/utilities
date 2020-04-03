#!/usr/bin/env bash


[ -z "$1" ] || [ ! -f $1 ] && echo "File $1 not found. Exiting..." && exit 1

# Account number
$ACC_NUM=

select_queue() {
  QUEUES=($(< queues))
  ARR_SIZE=$(expr ${#QUEUES[@]} - 1)

  while [ -z $QUEUE ]; do
    tput sc
    echo "Select queue:"
    for i in $(seq 0 $ARR_SIZE)
    do
      echo "$(expr $i + 1): ${QUEUES[i]}"
    done

    echo -ne "Select: " && read opt
    QUEUE=${QUEUES[$(expr $opt - 1)]}
    tput rc; tput ed;
  done
}

select_queue
echo "Selected queue: $QUEUE"
aws sqs send-message --queue-url "https://sqs.sa-east-1.amazonaws.com/$ACC_NUM/$QUEUE" --message-body ' '"$(cat $1)"' '
