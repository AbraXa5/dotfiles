#! /usr/bin/env bash

# Enable git segment
export DRACULA_DISPLAY_GIT=1

# Enable 24ht time segment
export DRACULA_DISPLAY_TIME=1
export DRACULA_TIME_FORMAT="%b %d, %H:%M |"
# export DRACULA_TIME_FORMAT="%-H:%M"

# Disable SSH user and hostname
export DRACULA_DISPLAY_CONTEXT=0

# Print only basename from pwd
exportDRACULA_DISPLAY_FULL_CWD=0

# Customize prompt
export DRACULA_ARROW_ICON="❯ "
export DRACULA_DISPLAY_NEW_LINE=1
