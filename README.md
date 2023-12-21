# steklo

Small C program that helps me with managing my website's posts.

steklo is a Romanization of стекло, which means "glass" in Russian.

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

Just create a directory for your blog posts, write a post in a Markdown file,
and then enter `stek <directory name>` into the terminal. The shell program
that it invokes will first convert the given Markdown file into HTML. It will
not be a standalone HTML document, but rather a fragment that will then be
combined with the main HTML document in your home directory.

Then, the shell script will ask you for a few things for the RSS item entry,
namely the post id (a unique identifier of the post for the sake of linking),
title, and then description.

After it runs, you should have a new RSS item entry and your post itself
should be contained in your blog HTML file. All of this done without you
having to dig into the headache-inducing `<div>` and `<span>` soup---neat!
