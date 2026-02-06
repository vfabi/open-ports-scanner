#!/bin/sh

TIMESTAMP=$(date +%Y%m%d%H%M)
RESULT_FILE="/tmp/result-$TIMESTAMP.xml"
RESULT_FILE_OPEN="/tmp/result-open.txt"
RESULT_FILE_OPEN_DIFF="/tmp/result-open-diff.txt"
DATA_FOLDER="/app/data"
NMAP_CMD="nmap -sS -sU -Pn -T4 --min-rate 1000 -v -oX $RESULT_FILE"


if [ -z "$NMAP_TARGETS" ]; then
    echo "[ERROR] no NMAP_TARGETS variable specified."
    exit 1
fi

if [ "$SEND_REPORT_TELEGRAM" == "true" ] || [ "$SEND_DIFF_REPORT_TELEGRAM" == "true" ]; then
    if [ -z "$TELEGRAM_BOT_TOKEN" ] || [ -z "$TELEGRAM_CHAT_ID" ]; then
        echo "[ERROR] send report to Telegram enabled, but not specified TELEGRAM_BOT_TOKEN or TELEGRAM_CHAT_ID variable"
        exit 1
    fi
fi


if [ -n "$NMAP_PORTS" ]; then
    NMAP_CMD="$NMAP_CMD -p $NMAP_PORTS"
fi
NMAP_TARGETS_FIXED=$(echo "$NMAP_TARGETS" | tr ',' ' ')
NMAP_CMD="$NMAP_CMD $NMAP_TARGETS_FIXED"


results_report () {
    # Parse Nmap results xml file and prepare open ports report as file ($RESULT_FILE) and to stdout.
    # Report file can be send to Telegram (SEND_REPORT_TELEGRAM="true").
    echo -e "\n---------------------------------------------------"
    echo "[RESULTS_REPORT] scan results (open ports) report:"
    echo "---------------------------------------------------"
    python3 results_parser.py $RESULT_FILE
    echo "---------------------------------------------------"
    if [ "$SEND_REPORT_TELEGRAM" == "true" ]; then
        curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" -d chat_id="$TELEGRAM_CHAT_ID" -d parse_mode="HTML" --data-urlencode "text=<b>$APP_NAME ($APP_VERSION) 🟢 INFO</b>"$'\n\n'"<b>Message:</b> Open ports report"$'\n'"<pre>$(cat $RESULT_FILE_OPEN)</pre>"
        echo -e "\n---------------------------------------------------"
    fi
}

results_diff_report () {
    # Parse Nmap 2 results xml files (old and current) and prepare new open ports report as file ($RESULT_FILE_OPEN_DIFF) and to stdout.
    # Report file can be send to Telegram (SEND_DIFF_REPORT_TELEGRAM="true").
    echo -e "\n---------------------------------------------------"
    echo "[RESULTS_DIFF_REPORT] changes (new open ports) report:"
    echo "---------------------------------------------------"
    PREVIOUS_RESULT_FILE=$(ls $DATA_FOLDER | grep xml)
    python3 results_diff.py $DATA_FOLDER/$PREVIOUS_RESULT_FILE $RESULT_FILE
    if [ -s "$RESULT_FILE_OPEN_DIFF" ]; then
        echo "---------------------------------------------------"
        if [ "$SEND_DIFF_REPORT_TELEGRAM" == "true" ]; then
            curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" -d chat_id="$TELEGRAM_CHAT_ID" -d parse_mode="HTML" --data-urlencode "text=<b>$APP_NAME ($APP_VERSION) 🟠 WARNING</b>"$'\n\n'"<b>Message:</b> Open ports changes (new open ports) report"$'\n'"<pre>$(cat $RESULT_FILE_OPEN_DIFF)</pre>"
            echo -e "\n---------------------------------------------------"
        fi
    fi
}

files_cleanup () {
    echo -e "\n---------------------------------------------------"
    echo "[FILES_CLEANUP] remove previous results file"
    echo "---------------------------------------------------"
    cd $DATA_FOLDER
    rm -rf *.xml
    rm -rf *.txt
    cp $RESULT_FILE $DATA_FOLDER
    cp $RESULT_FILE_OPEN $DATA_FOLDER
}


echo "---------------------------------------------------"
echo "[NMAP] run Nmap port scanning"
echo "[NMAP] $NMAP_CMD"
echo "---------------------------------------------------"
$NMAP_CMD "$@"
NMAP_EXIT_CODE=$?
echo "---------------------------------------------------"

if [ $NMAP_EXIT_CODE -eq 0 ]; then
    results_report
    results_diff_report
    files_cleanup
else
    echo "[ERROR] Nmap port scanning finished unsuccessfully. Exit code: $NMAP_EXIT_CODE)"
    exit $NMAP_EXIT_CODE
fi
