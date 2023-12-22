#! /usr/bin/env zsh

set -e

birdpath="/Users/forest/projects/steklo/bird.sh"
sitedir="/Users/forest/Downloads/neocities-iwillneverbehappy/"
birddir=$sitedir"bird-nest"
blogdir=$sitedir"blog"
templatefile="./template.html"
header="<div class=\"article\">\n<h2 id=\"<!-- ID -->\" style=\"margin-bottom:1px;\"><!-- TITLE -->\n<div class=\"when\"><!-- DATE --></div></h2>"
footer="</div>"
currblog=$sitedir"/blog23.html"
xmlfile=$sitedir"/feed.xml"
tmp=$blogdir".tmp.txt"
blogurl="https://iwillneverbehappy.neocities.org/blog23#";

currdate="$(date '+%a, %d %b %Y %H:%M:%S')"
currday="$(date '+%d')"

if [[ $(pwd) == $blogdir ]]
then
 	continue
elif
	[[ $(pwd) == $birddir ]]
	then
		cd $birddir && source $birdpath $1
else
	echo "Where are we?" && exit 1
fi

newname=$(echo "$1" | cut -d"." -f 1)
echo $newname
if [[ ! -d "$newname.html" ]]; then
	touch "$newname.html"
fi

echo $header > "$postdir$newname.html"
pandoc "$1" >> "$postdir$newname.html"
echo $footer >> "$postdir$newname.html"

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
sed -i '' 's/<!-- ID -->/'$id'/g' $postdir$newname.html || (echo "Can't find ID anchor" && exit 1)
sed -i '' 's/<!-- TITLE -->/'$title'/g' $postdir$newname.html || (echo "Can't find TITLE anchor" && exit 1)
sed -i '' 's/<!-- DATE -->/'$currdate'/g' $postdir$newname.html || (echo "Can't find DATE anchor" && exit 1)

(printf "%s\n" "/<!-- POST -->/a" "$(cat $postdir$newname.html)" . w | ed -s $currblog) || (echo "Can't find POST anchor" && exit 1)

# For RSS, feed.xml
touch $tmp

echo '
		<item>
			<title>'$title'</title>
			<pubDate>'$currdate'</pubDate>
			<link>'$blogurl$id'</link>
			<description><![CDATA['$(cat $postdir$newname.html)']]></description>
		</item>' > $tmp

(printf "%s\n" "/<!-- ITEM -->/a" "$(cat $tmp)" . w | ed -s $xmlfile) || (echo "Can't find ITEM anchor" && exit 1)

rm -i $tmp

# For sidebar
touch $tmp

# 5 tabs. lol
echo '
					<li><a href="#'$id'">'$title'</a> '$currday'</li>' > $tmp

(printf "%s\n" "/<!-- SIDE -->/a" "$(cat $tmp)" . w | ed -s $currblog) || (echo "Can't find SIDE anchor" && exit 1)
rm -i $tmp

echo "Do you wish to publish to Neocities? [y/n]"
read pub

if [[ $pub == "y" ]]; then
	neocities upload $currblog $xmlfile
fi

exit 0

