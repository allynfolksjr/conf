#!/bin/bash
# I have a special PuTTy instance set up that will use a bright red background and automatically run this script when ran. Mainly so I don't randomly execute rm -rf's on someone's account without checking who I'm logged in as first. :)
echo Enter User
read USER
ssu - $USER
