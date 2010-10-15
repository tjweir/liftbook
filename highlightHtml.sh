#!/bin/bash

mkdir -p master/scripts master/css
cp highlighter/*.css master/css
cp highlighter/*.js master/scripts

for fl in master/node*.html; do
    sed -i -e 's:</HEAD>:<script type="text/javascript" src="scripts/shCore.js"></script><script type="text/javascript" src="scripts/shBrushXml.js"></script><script type="text/javascript" src="scripts/shBrushScala.js"></script><link href="css/shCore.css" rel="stylesheet" type="text/css" /><link href="css/shThemeDefault.css" rel="stylesheet" type="text/css" /></HEAD>:' -e 's:</BODY>:<script type="text/javascript">SyntaxHighlighter.all()</script></BODY>:' $fl
done