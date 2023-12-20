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
	if [[ -f "$file" ]]; then
		newname=$(echo "$file" | cut -d"." -f 1,2)
		if [[ ! -d "$newname.html" ]]; then
			touch "$newname.html"
		fi

		# Add check to see if original file has been modified since. 
		pandoc --standalone --template $templatefile "$file" > "$newname.html"
	fi
done

exit 0

