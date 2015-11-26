#!/bin/sh

echo "docs.openobservatory.net" > public/CNAME
ghp-import -p -n public
