#! /usr/bin/env zsh

set -e
postdir="/Users/forest/Downloads/neocities-iwillneverbehappy/blog/"
templatefile="./template.html"

if [[ $(pwd) == $postdir ]]
then
	continue
else
	cd $postdir
fi

for file in ./*.md; do
	if [ -f "$file" ]; then
		NEW_NAME=$(echo "$file" | cut -d"." -f 1,2)
		touch "$NEW_NAME.html"
		pandoc --standalone --template $templatefile "$file" > "$NEW_NAME.html"
	fi
done

exit 0

