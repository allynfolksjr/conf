#!/bin/bash
# Crontab entry for automatically syncing the public repository with my master trunk.
# cd ~/uw_scripts is so that git runs from the proper directory.
# Since we're ssh'ing into our own account, it won't ask for authcreds.
# `wwwhome` will execute and give you the current absolute path for your web publishing.
#  Since your web path changes, this is better than hardcoding it in.
cd ~/uw_scripts && git push ssh://ovid/`wwwhome`/uw_scripts.git master
