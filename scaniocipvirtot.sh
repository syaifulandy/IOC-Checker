#!/bin/bash

INPUT_FILE="listipcek.txt"
APIKEY_FILE="apikey.txt"
OUTPUT_FILE="vt_ip_output.csv"

# =========================
# Check required files
# =========================
if [ ! -f "$INPUT_FILE" ]; then
    echo "❌ File $INPUT_FILE tidak ditemukan!"
    exit 1
fi

if [ ! -f "$APIKEY_FILE" ]; then
    echo "❌ File $APIKEY_FILE tidak ditemukan!"
    exit 1
fi

API_KEY=$(cat "$APIKEY_FILE" | tr -d ' \n')

if [ -z "$API_KEY" ]; then
    echo "❌ API Key kosong!"
    exit 1
fi

# =========================
# CSV Header
# =========================
echo "IP;country;organization;total malicious/suspicious;Source malicious/suspicious" > "$OUTPUT_FILE"

# =========================
# Loop each IP
# =========================
while read -r ip; do
    [[ -z "$ip" ]] && continue

    echo "[*] Checking $ip..."

    RESPONSE=$(curl -s --request GET \
        --url "https://www.virustotal.com/api/v3/ip_addresses/$ip" \
        --header "accept: application/json" \
        --header "x-apikey: $API_KEY")

    # -------------------------
    # Extract country + org
    # -------------------------
    COUNTRY=$(echo "$RESPONSE" | jq -r '.data.attributes.country // "UNKNOWN"')
    ORG=$(echo "$RESPONSE" | jq -r '.data.attributes.as_owner // "UNKNOWN"')

    # -------------------------
    # Extract malicious + suspicious totals
    # -------------------------
    MALICIOUS=$(echo "$RESPONSE" | jq -r '.data.attributes.last_analysis_stats.malicious // 0')
    SUSPICIOUS=$(echo "$RESPONSE" | jq -r '.data.attributes.last_analysis_stats.suspicious // 0')

    TOTAL=$((MALICIOUS + SUSPICIOUS))

    # -------------------------
    # Extract vendor sources (malicious/suspicious)
    # -------------------------
    SOURCES=$(echo "$RESPONSE" | jq -r '
      .data.attributes.last_analysis_results
      | to_entries[]
      | select(.value.category=="malicious" or .value.category=="suspicious")
      | .key
    ' | paste -sd "," -)

    SOURCES=${SOURCES:-NONE}

    # -------------------------
    # Append to CSV
    # -------------------------
    echo "$ip;$COUNTRY;$ORG;$TOTAL;$SOURCES" >> "$OUTPUT_FILE"

done < "$INPUT_FILE"

echo ""
echo "✅ Done. Output saved to $OUTPUT_FILE"
