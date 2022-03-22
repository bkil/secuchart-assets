#!/bin/sh
set -e

mkdir -p .public

cp -at .public *
mv .public public

cd public

find . -type f |
cut -c 3- |
sort |
tee sitemap.txt |
{
  cat <<EOF
<!DOCTYPE html>
<html>
<head>
  <meta charset=utf-8>
  <title>SecuChart-assets</title>
  <link rel='shortcut icon' type=image/x-icon href=data:image/x-icon;,>
<body>
<a href='https://bkil.gitlab.io/secuchart/#screenshots'>SecuChart</a>
EOF

while read F; do
  IMG="<br><img src='$F'>"

  echo "$F" |
  grep -qE "(\.(txt|md|html|sh)|^LICENSE)$" &&
    IMG=""

  cat << EOF
<br>
 <p id='$F'><a href='#$F'>$F</a></p>
 $IMG
EOF
done

cat << EOF
</html>
EOF
} > index.html

find . -type f -regex ".*\.\((html\|txt\)|^LICENSE)$" -exec gzip -9 -f -k {} \;
find . -type f -regex ".*\.\((html\|txt\)|^LICENSE)$" -exec brotli -f -k {} \;
