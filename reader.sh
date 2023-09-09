#!/bin/bash

# Initialize variables with default values
limit=0
action=""
filename="/dev/stdin"

# Parse command-line arguments
while getopts "L:c2rFt:" opt; do
    case $opt in
        L)
            limit="$OPTARG"
            ;;
        c|2|r|F|t)
            action="$opt"
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
    esac
done

# Check if a filename is provided
if [ $OPTIND -le $# ]; then
    filename="${@: -1}"
fi

# Validate mandatory parameter
if [ -z "$action" ]; then
    echo "Mandatory parameter (-c, -2, -r, -F, -t) is missing." >&2
    exit 1
fi

# Task 1: Which IP address makes the most number of connection attempts?
if [ "$action" == "c" ]; then
    result=$(awk '{print $1}' "$filename" | sort | uniq -c | sort -nr | head -n "$limit")
    echo "$action: $result"
fi

# Task 2: Which IP address makes the most number of successful attempts?
if [ "$action" == "2" ]; then
    result=$(grep "200 OK" "$filename" | awk '{print $1}' | sort | uniq -c | sort -nr | head -n "$limit")
    echo "$action: $result"
fi

# Task 3: What are the most common result codes and where do they come from?
if [ "$action" == "r" ]; then
    result=$(awk '{print $9, $1}' "$filename" | sort | uniq -c | sort -nr | head -n "$limit")
    echo "$action:"
    echo "$result" | awk '{print $2, $1}'
fi

# Task 4: What are the most common result codes indicating failure?
if [ "$action" == "F" ]; then
    result=$(awk '$9 ~ /401|404|403/ {print $9, $1}' "$filename" | sort | uniq -c | sort -nr | head -n "$limit")
    echo "$action:"
    echo "$result" | awk '{print $2, $1}'
fi

# Task 5: Which IP number gets the most bytes sent to them?
if [ "$action" == "t" ]; then
    result=$(awk '{sum[$1] += $10} END {for (ip in sum) print sum[ip], ip}' "$filename" | sort -nr | head -n "$limit")
    echo "$action: $result"
fi
