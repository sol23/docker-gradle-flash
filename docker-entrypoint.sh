#!/bin/bash
/usr/bin/Xvfb :99 -ac -screen 0 1024x768x16 &
exec "$@"