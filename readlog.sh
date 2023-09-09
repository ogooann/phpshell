#!/bin/bash

# Define the path to the log file
log_file="/path/to/your/logfile.log"

# Check if the log file exists
if [ ! -f "$log_file" ]; then
    echo "Log file not found: $log_file"
    exit 1
fi

# Task 1: Which IP addresses make the most connection attempts?
echo "IP addresses with the most connection attempts:"
awk '{print $1}' "$log_file" | sort | uniq -c | sort -nr | head -n 10

# Task 2: Which IP addresses make the most successful connection attempts?
echo "IP addresses with the most successful connection attempts:"
grep "200 OK" "$log_file" | awk '{print $1}' | sort | uniq -c | sort -nr | head -n 10

# Task 3: Most common result codes and their IP sources
echo "Most common result codes and their IP sources:"
awk '{print $9, $1}' "$log_file" | sort | uniq -c | sort -nr | head -n 10

# Task 4: Most common result codes indicating failure and their IP sources
echo "Most common result codes indicating failure and their IP sources:"
grep -E "401 Unauthorized|404 Not Found" "$log_file" | awk '{print $9, $1}' | sort | uniq -c | sort -nr | head -n 10

# Task 5: IP number with the most bytes sent to them
echo "IP number with the most bytes sent to them:"
awk '{sum[$1] += $10} END {for (ip in sum) print sum[ip], ip}' "$log_file" | sort -nr | head -n 1
