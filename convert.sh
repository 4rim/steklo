#! /usr/bin/env zsh

pwd
cd dummy

for file in ./*.md; do
	if [ -f "$file" ]; then
		pandoc --standalone --template /Users/forest/projects/steklo/dummy/template.html "$file"
		echo "$file"

		cat
	fi
done

