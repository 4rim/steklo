# steklo

Small C program that helps me with managing my website's posts.

steklo is a Romanization of стекло, which means "glass" in Russian. The
motivation behind the name was that I wanted to preserve "transparency" of
blog-post-making as much as possible; that is, I should be able to know
_exactly_ what this program is doing, which isn't hard because it's quite
small.

## Dependencies

[pandoc](https://pandoc.org/releases.html), any of the recent releases
should do. Pandoc is a Haskell library and command-line tool that enables
quick translation from one markup format to another. It is used here to 
convert Markdown to HTML files.

## Few notes for myself

Ultimately what steklo does is let me write all my posts in Markdown and
minimize my contact with any HTML manipulation, because that stuff is _tedious_.

steklo assumes that you have sort of a specific set up: a directory where all
your blogposts are contained as markdown files, an HTML page in the
parent directory that contains all your blogposts in one large file, and an
RSS .xml file also in the parent directory.

```
~/my-site/
    |   blog.html
    |   rss.xml
    |
    \---/posts/
        |   post1.md
        |   post2.md
        |   post3.md
```

Just create a directory for your blog posts, edit the variables in the shell
script to match your file/directory names, and  write a post in a Markdown
file. Then enter `stek <directory name>` into the terminal, where the name
of the directory is whichever one holds all your Markdown blog posts.

The shell program invoked by `stek` will first convert the given Markdown file
into HTML. The HTML generate will not be a standalone document, but rather a
fragment that will then be combined with the main HTML document in your home
directory.

Then, the shell script will ask you for a few things for the RSS item entry,
namely the post id (a unique identifier of the post for the sake of linking),
title, and then description.

After it runs, you should have a new RSS item entry and your new post should be
contained in your blog HTML file. All of this done without you having to dig
into the headache-inducing `<div>` and `<span>` soup---neat!
