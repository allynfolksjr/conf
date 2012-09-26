#!/bin/bash
# Searches for the NetID in the student and staff directory 

studentdir -full -E $1 && staffdir -full -E $1
