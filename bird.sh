# blogdir="/Users/forest/Downloads/neocities-iwillneverbehappy/"
blogdir="/home/arim/downloads/neocities-iwillneverbehappy/"
blogurl="https://marmeru.xyz/"
tmp=$blogdir".tmp.txt"
xmlfile=$blogdir"feed.xml"
birdnest=$blogdir"bird-nest.html"
birdnestdir=$blogdir"bird-nest/"
header="<!DOCTYPE html>
<html lang=\"en-US\">
	<head>
		<meta charset=\"UTF-8\">
		<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n
		<title><!-- TITLE --></title>\n
		<link href=\"../newstyle.css\" rel=\"stylesheet\" type=\"text/css\" media=\"all\">\n
	</head>
	<body>
		<header>
			<nav>
				<div class=\"left\">
			<a href=\"./index.html\">index</a> |
			<strong><a href=\"./blog24.html\">blog</a></strong> |
			<a href=\"./art.html\">art</a> |
			<a href=\"./about.html\">about</a> |
			<a href=\"../bird-nest.html\">misc</a>
				</div>
			</nav>
		</header>

		<div class=\"main\">\n
			<h2><!-- TITLE -->
			<div class=\"when\"><!-- DATE --></div></h2>\n

			<div class=\"article\">"

	  footer="
		</div>
		</div>

		<footer>If there are any egregious factual errors in this write-up, please <a href=\"mailto:threetrees@disroot.org\">email me</a> and I'll fix them. Or hey, feel free to bring up non-errata&#8212;I'm open to discussing CS, UNIX, systems programming, and basically anything with anyone.</footer>
	</body>
<html>"

# Required for zsh \n newline recognition
set -e

cd $birdnestdir
pwd

currdate="$(date '+%a, %d %b %Y %H:%M:%S %z')"
shortdate="$(date '+%d/%m/%Y')"

urlname=$(echo "$1" | cut -d"." -f 1)
newname=$birdnestdir$(echo "$1" | cut -d"." -f 1)
echo $newname

echo "What would you like your post's title to be?"
read title

# For HTML conversion
echo $header > $newname.html
pandoc "$birdnestdir$1" >> $newname.html
echo $footer >> $newname.html

entry="
	<li><a href=\"./$urlname.html\">$title</a> - ($shortdate)</li>"

# Had to use awk instead of sed due to getting stuck on passing
# shell variables into sed. Well, if it works it works?
(awk -v r="$title" '{gsub(/<!-- TITLE -->/,r)}1' $newname.html > tmp && mv tmp $newname.html) || (echo "Error with replacing <!-- TITLE -->" && exit 1)

(awk -v r="$currdate" '{gsub(/<!-- DATE -->/,r)}1' $newname.html > tmp && mv tmp $newname.html) || (echo "Error with replacing <!-- DATE -->" && exit 1)

(printf "%s\n" "/<!-- ENTRY -->/a" "$(echo $entry)" . w | ed -s $birdnest) || (echo "Can't find ENTRY anchor" && exit 1)

# For RSS, feed.xml
touch $tmp

echo '
		<item>
			<title>'$title'</title>
			<pubDate>'$currdate'</pubDate>
			<link>'$blogurl''$urlname'</link>
			<description><![CDATA['$(cat $newname.html)']]></description>
		</item>' > $tmp

(printf "%s\n" "/<!-- ITEM -->/a" "$(cat $tmp)" . w | ed -s $xmlfile) || (echo "Can't find ITEM anchor" && exit 1)

rm -i $tmp

echo "Would you like to upload this post to Neocities (y/n)?"
read uploadans

if [[ $uploadans == "y" ]]; then
	neocities upload $newname.html &&
	neocities upload $xmlfile &&
	neocities upload $birdnest
fi

exit
