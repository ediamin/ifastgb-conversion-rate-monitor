#!/bin/bash

# Load configuration
CONFIG_FILE="config.json"

# Read base and term currencies from config or environment variables
BASE_CURRENCY=${BASE_CURRENCY:-$(jq -r '.baseCurrency' "$CONFIG_FILE")}
TERM_CURRENCY=${TERM_CURRENCY:-$(jq -r '.termCurrency' "$CONFIG_FILE")}
API_URL=$(jq -r '.apiUrl' "$CONFIG_FILE")

# Generate output filename with current month
CURRENT_MONTH=$(date +"%Y-%m")
OUTPUT_FILE="data/conversion-rates-${CURRENT_MONTH}.csv"

# Create data directory if it doesn't exist
mkdir -p data

echo "Fetching conversion rates for ${BASE_CURRENCY} to ${TERM_CURRENCY}..."

# Construct API URL with parameters
FULL_URL="${API_URL}?baseCurrency=${BASE_CURRENCY}&termCurrency=${TERM_CURRENCY}"

# Fetch data from API using curl with proper error handling
RESPONSE=$(curl -s -f -w "\n%{http_code}" "$FULL_URL" 2>&1)
CURL_EXIT_CODE=$?

# Check if curl command failed
if [ $CURL_EXIT_CODE -ne 0 ]; then
  echo "✗ Error: Network request failed (curl exit code: $CURL_EXIT_CODE)"
  exit 1
fi

HTTP_CODE=$(echo "$RESPONSE" | tail -n 1)
BODY=$(echo "$RESPONSE" | sed '$d')

# Check HTTP status code
if [ "$HTTP_CODE" -lt 200 ] || [ "$HTTP_CODE" -ge 300 ]; then
  echo "✗ Error fetching conversion rates: HTTP status $HTTP_CODE"
  exit 1
fi

# Extract normalRate from JSON response using jq
# The API is expected to return a JSON object with a 'normalRate' field
NORMAL_RATE=$(echo "$BODY" | jq -r '.normalRate // empty')

if [ -z "$NORMAL_RATE" ] || [ "$NORMAL_RATE" = "null" ]; then
  echo "✗ Error: Could not extract normalRate from response"
  echo "Response: $BODY"
  exit 1
fi

# Get current date and time in ISO 8601 format
DATETIME=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Create CSV header if file doesn't exist
if [ ! -f "$OUTPUT_FILE" ]; then
  echo "datetime,baseCurrency,termCurrency,normalRate" > "$OUTPUT_FILE"
  echo "Created new CSV file: $OUTPUT_FILE"
fi

# Append data to CSV
echo "${DATETIME},${BASE_CURRENCY},${TERM_CURRENCY},${NORMAL_RATE}" >> "$OUTPUT_FILE"

echo "✓ Successfully fetched and saved conversion rate to $OUTPUT_FILE"
echo "✓ Rate: ${BASE_CURRENCY} to ${TERM_CURRENCY} = ${NORMAL_RATE}"
