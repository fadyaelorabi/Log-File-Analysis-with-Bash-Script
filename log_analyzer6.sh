#!/bin/bash

logfile="$1"
month_year="$2"

if [[ ! -f "$logfile" ]]; then
  echo "❌ Log file not found: $logfile"
  exit 1
fi

echo "📅 Analyzing logs for: $month_year"
tmp_log=$(mktemp)

# Filter logs for the given month and year
grep "$month_year" "$logfile" > "$tmp_log"

# Request Counts
total_requests=$(wc -l < "$tmp_log")
total_get=$(grep -c '"GET' "$tmp_log")
total_post=$(grep -c '"POST' "$tmp_log")

echo ""
echo "📊 Total Requests: $total_requests"
echo "📈 Total GET requests: $total_get"
echo "📬 Total POST requests: $total_post"

# Unique IP Addresses
unique_ips=$(awk '{print $1}' "$tmp_log" | sort | uniq | wc -l)

echo ""
echo "👥 Unique IPs: $unique_ips"

# Request per IP
echo ""
echo "📊 Requests per IP (GET/POST):"
awk '
{
    ip = $1
    method = $6
    gsub(/"/, "", method)
    if (method == "GET") get[ip]++
    else if (method == "POST") post[ip]++
}
END {
    n = 0
    for (ip in get) n++
    for (ip in post) if (!(ip in get)) n++

    total_get = 0
    total_post = 0
    for (ip in get) total_get += get[ip]
    for (ip in post) total_post += post[ip]

    avg_get = (n > 0) ? total_get / n : 0
    avg_post = (n > 0) ? total_post / n : 0

    printf "📈 Average GET requests per unique IP: %.2f\n", avg_get
    printf "📬 Average POST requests per unique IP: %.2f\n", avg_post
}' "$tmp_log"

# Request by Hour
echo ""
echo "⏰ Requests by Hour:"
awk -F'[:[]' '{print $3":00"}' "$tmp_log" | sort | uniq -c | sort -nr | awk '{print $2, ":", $1}'

# Request Trends (Top 5 Hours with most requests)
echo ""
echo "📊 Request Trends (Top 5 Hours):"
awk -F'[:[]' '{print $3":00"}' "$tmp_log" | sort | uniq -c | sort -nr | head -5

# Status Codes Breakdown (200, 404, 500, etc.)
echo ""
echo "📉 Status Codes Breakdown:"
awk '{print $9}' "$tmp_log" | sort | uniq -c | sort -nr | awk '{print $2, ":", $1}'

# Most Active User by Method (GET/POST)
echo ""
echo "🏆 Most Active User by Method (GET):"
awk '
{
    ip = $1
    method = $6
    gsub(/"/, "", method)
    if (method == "GET") get[ip]++
}
END {
    max_get = 0
    for (ip in get) {
        if (get[ip] > max_get) {
            max_get = get[ip]
            active_ip = ip
        }
    }
    printf "Most Active IP for GET requests: %s with %d GET requests\n", active_ip, max_get
}' "$tmp_log"

echo ""
echo "🏆 Most Active User by Method (POST):"
awk '
{
    ip = $1
    method = $6
    gsub(/"/, "", method)
    if (method == "POST") post[ip]++
}
END {
    max_post = 0
    for (ip in post) {
        if (post[ip] > max_post) {
            max_post = post[ip]
            active_ip = ip
        }
    }
    printf "Most Active IP for POST requests: %s with %d POST requests\n", active_ip, max_post
}' "$tmp_log"

# Patterns in Failure Requests (Identify if failures occur at specific hours/days)
echo ""
echo "🔴 Patterns in Failure Requests:"
awk '
{
    status_code = $9
    # Extract the date and time from the fourth field (e.g., [May/2015:10:05:03 +0000])
    date = $4
    # Remove the square brackets from the date field
    gsub(/\[|\]/, "", date)
    # Extract the date and hour in the correct format (e.g., May/2015:10)
    hour = substr(date, 1, 14)  # Now correctly extracts the full date and hour (May/2015:10)
    if (status_code ~ /^[45]/) failures[hour]++  # Count failures for 4xx or 5xx status codes
}
END {
    for (hour in failures) {
        print "Failures on " hour ": " failures[hour]  # Print the count of failures per hour
    }
}' "$tmp_log" | sort -nr

#############################################################################################
awk '
{
    ip = $1  # The first field contains the IP address
    method = $6  # The sixth field contains the HTTP method (GET, POST, etc.)
    
    # Remove the leading double quote from the HTTP method (e.g., "GET becomes GET)
    gsub(/"/, "", method)
    
    # Count GET and POST requests per IP
    if (method == "GET") {
        get_requests[ip]++
    } else if (method == "POST") {
        post_requests[ip]++
    }
}
END {
    # Print the results to a file
    for (ip in get_requests) {
        print ip, "GET:", get_requests[ip], "POST:", post_requests[ip] > "ip_requests.txt"
    }
}
' "$tmp_log"

#To count how many GET and POST requests were made by each unique IP address
#saved in ip_requests.txt
##########################################################################################

