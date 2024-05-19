#!/bin/sh
python -m venv .venv
.venv/bin/pip install -r requirements.txt
.venv/bin/python update_tool_versions.py
mv syft_versions.bzl ../syft/private/versions.bzl
