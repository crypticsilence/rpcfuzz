#!/bin/bash

echo
echo
if [[ -z "$2" ]]; then
  echo "[ rpcfuzz ] Crypticsilence 2020 "
elif [[ -n "$2" ]]; then
  echo >> $2.out
  echo >> $2.out
  echo "[ rpcfuzz ] Crypticsilence  2020 " | tee -a $2.out 2>/dev/null
  rm -f $2.err 2> /dev/null
fi

if [[ -z "$2" ]]; then
  echo "rpcfuzz - Usage:"
  echo "  $0 <ip> <command_file.txt> ['user'] ['password']"
  echo
  echo "    Note: Please single quote your user and password parameters."
  echo
  echo "  Tries all rpcclient commands found in 'command_file.txt' one by one and writes output to 'command_file.txt.out', errors in 'command_file.txt.err'"
  echo "  Does not overwrite, file will be appended to."
  echo "  Opens output file in 'less' when complete."
fi

USER=""
if [[ -n "$3" ]]; then
  USER=$3
fi
cat $2 | while read line; do
  if [[ -z "$3" ]]; then
    echo "Trying: rpcclient -c "$line" $1 >> $2.out" | tee -a $2.out
    rpcclient -U '' -N -c "$line" $1 | tee -a $2.out 2> $2.err
  fi
  if [[ -n "$3" ]] && [[ -z "$4" ]]; then
    echo "Trying: rpcclient -U $USER -c "$line" $1 >> $2.out" | tee -a $2.out
    rpcclient -U $USER -N -c "$line" $1 | tee -a $2.out 2> $2.err
  elif [[ -n "$4" ]]; then
    echo "Trying: rpcclient -U $USER%$4 -c "$line" $1  >> $2.out" | tee -a $2.out
    rpcclient -U $USER%$4 -c "$line" $1 | tee -a $2.out 2> $2.err
  fi
done
echo "Done scanning. "
if [[ -s $2.err ]]; then
  echo "[X] Errors found: "
  cat $2.err 2> /dev/null
fi
echo "Displaying output: "
less $2.out
echo "Exiting rpcfuzz!"
