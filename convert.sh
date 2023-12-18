#! /usr/bin/env zsh

set -e
POST_DIR="blog"
TEMPLATE="./template.html"

cd $POST_DIR

for file in ./*.md; do
	if [ -f "$file" ]; then
		NEW_NAME=$(echo "$file" | cut -d"." -f 1,2)
		touch "$NEW_NAME.html" || exit
		pandoc --standalone --template $TEMPLATE "$file" > "$NEW_NAME.html"
	fi
done

exit 0

