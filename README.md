# jekyll_category_page_creator

Perl script that creates category and tag pages for Jekyll

In the beginning of the file are some variables you have to fill in to make it
work like you want it to.

``` perl
### Here we set a few variables ##########

# Where are posts?
my $dir = "_posts/";

# Where to store category files?
my $cat_dir = "categories/";

# Where to store tag files?
my $tag_dir = "tags/";

# Permalink for categories?
my $cat_per = "/categories"; # will look like /categories/Jekyll

# Permalink for tags?
my $tag_per = "/tags"; # will look like /tags/css

##########################################
```

1. $dir is where you store your posts. That is usually in `` _posts ``
2. $cat_dir is the directory where you want to store you category files. The is
   no default for that, just choose what makes most sense to you.
3. $tag_dir is where you want to store your tag files.
4. $cat_per is the how you want your permalink to look like for categories. It
   doesn's have to be the same as the physical categori. `` /cat `` will make a
   permalink that looks like this: `` /cat/Jekyll `` for a Jekyll category.
5. $tag_per has the same logic as $cat_per.

In the front matter you can use **category** or **categories** and you can use
space separated lists or YAML lists like this:

``` yaml
category: [Jekyll, CSS]
categories: [Jekyll, CSS]
category: Jekyll CSS
```

Tags can also be YAML lists or space separated lists.

``` yaml
tags: [css, vim]
tags: css vim
```

Run the file from your Jekyll directory. You can clone the repository and run
the file there or copy it to your `` .local/bin `` and just run the filename.

``` bash
$ ../jekyll_category_page_creater/jekyll_categories.pl
$ jekyll_categories.pl
```
