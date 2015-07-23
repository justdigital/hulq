#!/bin/sh
rm -rf xslt/*.xslt
rm -rf xslt/build/*.xslt
rm -rf xslt/partials/*.xslt
cp -R generated/* xslt/
