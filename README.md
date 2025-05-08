# Log Analysis Toolkit - May 2015

This repository contains scripts and data files used for analyzing and visualizing web server logs for May 2015.

## Description

The project leverages **Bash scripting** to extract meaningful data from raw logs, and **Python** to generate visualizations and deeper insights.

## Components

### Python Scripts

* `app1.py`
* `app2.py`
* `app3.py`

These scripts:

* Read pre-extracted `.txt` data files.
* Generate visualizations such as failure trends, hourly request volume, and top user activity.
* Help interpret system performance, user behavior, and security anomalies.

### Bash Outputs

* `.txt` files (e.g., `requests_by_ip.txt`, `status_codes.txt`, `hourly_failures.txt`):

  * Extracted using Bash scripts.
  * Contain structured summaries of requests, status codes, IP activity, and more.
  * Serve as input data for Python-based visualization and analysis.

## Purpose

This toolkit provides a streamlined workflow for:

* Extracting key metrics from large web server logs.
* Visualizing trends in requests, errors, and user behavior.
* Identifying performance issues and potential security threats.

---

**Usage:**

1. Run the Bash scripts to extract data from logs.
2. Use the Python scripts to generate charts and insights.
3. Review visual outputs for anomaly detection and system tuning.

---

