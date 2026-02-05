#!/usr/bin/env python3

import os
import sys
import xml.etree.ElementTree as ET

OUTPUT_FILE = "/tmp/result-open-diff.txt"


def get_ports_data(filename):
    data_map = {}

    if not os.path.exists(filename):
        print(f"[RESULTS_DIFF] error, file {filename} not found.")
        return data_map

    try:
        tree = ET.parse(filename)
        root = tree.getroot()
    except Exception as e:
        print(f"[RESULTS_DIFF] error, file {filename} parsing XML failed. Details: {e}")
        return data_map

    for host in root.findall("host"):
        address = host.find("address")
        if address is None: continue
        ip = address.get("addr")
        ports = host.find("ports")
        if ports is None: continue
        for port in ports.findall("port"):
            state_el = port.find("state")
            if state_el is None: continue
            state = state_el.get("state")
            port_id = port.get("portid")
            protocol = port.get("protocol")
            if state in ["open"]:
                key = f"{ip}:{port_id}:{protocol}"
                formatted_line = f"{ip:<16} | {port_id:<6} | {protocol.upper():<5} | {state}"
                data_map[key] = formatted_line

    return data_map


if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("[RESULTS_DIFF] error, arguments missing. Usage: python3 results_diff.py <OLD.xml> <NEW.xml>")
        sys.exit(1)

    old_file = sys.argv[1]
    new_file = sys.argv[2]
    old_ports = get_ports_data(old_file)
    new_ports = get_ports_data(new_file)
    old_keys = set(old_ports.keys())
    new_keys = set(new_ports.keys())
    diff_keys = new_keys - old_keys

    with open(OUTPUT_FILE, "w", encoding="utf-8") as f:
        if diff_keys:

            def log(text):
                print(text)
                f.write(text + "\n")

            header = f"{'IP':<16} | {'PORT':<6} | {'PROTO':<5} | {'STATE'}"
            log(header)
            log("-" * 51)

            for key in sorted(diff_keys):
                log(new_ports[key])
