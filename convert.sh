#! /usr/bin/env zsh

set -e
postdir="/Users/forest/Downloads/neocities-iwillneverbehappy/blog/"
templatefile="./template.html"
header="<div class=\"article\">\n<h2 id=\"<!-- ID -->\" style=\"margin-bottom:1px;\"><!-- TITLE -->\n<div class=\"when\"><!-- DATE --></div></h2>"
footer="</div>"
currblog="/Users/forest/Downloads/neocities-iwillneverbehappy/blog23.html"

if [[ $(pwd) == $postdir ]]
then
	continue
else
	cd $postdir
fi

newname=$(echo "$1" | cut -d"." -f 1)
echo $newname
if [[ ! -d "$newname.html" ]]; then
	touch "$newname.html"
fi

echo $header > "$newname.html"
pandoc "$1" >> "$newname.html"
echo $footer >> "$newname.html"

echo "Stay in draft mode or publish to main file? [y = publish, n = draft]"
read ans

if [[ $ans == n ]]; then
	exit 0
fi

echo "What would you like your post's ID to be?"
read id
echo "What would you like your post's title to be?"
read title

# This is BSD sed, so need to have the '' after the flag
sed -i '' 's/<!-- ID -->/'$id'/g' $newname.html || exit 1
sed -i '' 's/<!-- TITLE -->/'$title'/g' $newname.html || exit 1
sed -i '' 's/<!-- DATE -->/'$(echo $(date +%d.%m.%y-%H:%M:%S))'/g' $newname.html || exit 1

printf "%s\n" "/<!-- POST -->/a" "$(cat $newname.html)" . w | ed -s $currblog

exit 0

