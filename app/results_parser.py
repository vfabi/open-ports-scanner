#!/usr/bin/env python3

import os
import sys
import xml.etree.ElementTree as ET

OUTPUT_FILE = "/tmp/result-open.txt"


def parse_nmap_xml(filename):
    if not os.path.exists(filename):
        print(f"[RESULTS_PARSER] error, results file '{filename}' not found.")
        return

    try:
        tree = ET.parse(filename)
        root = tree.getroot()
    except ET.ParseError:
        print("[RESULTS_PARSER] error, results file XML read failed.")
        return

    try:
        with open(OUTPUT_FILE, "w", encoding="utf-8") as f:

            def log(text):
                print(text)
                f.write(text + "\n")

            header = f"{'IP':<16} | {'PORT':<6} | {'PROTO':<5} | {'STATE'}"
            log(header)
            log("-" * 51)
            found_ports = False

            for host in root.findall("host"):
                address = host.find("address")
                if address is None: continue
                ip = address.get("addr")
                ports_section = host.find("ports")
                if ports_section is None: continue
                for port in ports_section.findall("port"):
                    state_el = port.find("state")
                    if state_el is None: continue
                    state = state_el.get("state")
                    port_id = port.get("portid")
                    protocol = port.get("protocol")
                    # if state in ['open', 'open|filtered']:  # open|filtered - for UDP
                    if state in ["open"]:
                        row = f"{ip:<16} | {port_id:<6} | {protocol.upper():<5} | {state}"
                        log(row)
                        found_ports = True
            if not found_ports:
                log("[RESULTS_PARSER] no open ports found.")
    except IOError as e:
        print(f"[RESULTS_PARSER] error, writing to {OUTPUT_FILE} file failed: {e}")


if __name__ == "__main__":
    if len(sys.argv) > 1:
        xml_file = sys.argv[1]
        parse_nmap_xml(xml_file)
    else:
        print("[RESULTS_PARSER] error, arguments missing. Usage: python3 results_parser.py <FILE.xml>")
