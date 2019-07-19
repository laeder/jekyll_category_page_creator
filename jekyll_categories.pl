#!/usr/bin/env perl

use 5.014;
use strict;

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

my $dh;

# Open the directory
opendir my $dh, $dir or die "Could not open '$dir' for reading: $!\n";

# Read the directory and put the filenames in the @files array
my @files = readdir $dh;
my @posts;

# Put all files except . and .. in the @posts array
foreach my $file (@files) {
    if ($file eq '.' or $file eq '..') {
        next;
    }
    push @posts, $file;
}

closedir $dh;

# A hash is better since I don't want duplicates
my %categories;
my %tags;
my $cat_search = qr/^categor(y|ies): *(\[?[A-Za-z0-9, -]+\]?) */;
my $tag_search = qr/^tags: *(\[?[A-Za-z, -]+\]?) */;
my $reg_name = qr/\[(.*)\]/;

# Read the files
foreach my $post (@posts) {
    my $filename = $dir . $post;
    my $started = 0;

    # Open the file for reading
    open(my $fh, '<:encoding(UTF-8)', $filename) or die "Could not open file '$filename' $!";
     
    # For every row
    while (my $row = <$fh>) {
        chomp $row;

        # --- starts and ends the frontmatter
        if ($row =~ m/^--- *$/) {
            if ($started) { last; }
            $started++;
        }

        # categories
        if ($row =~ m/$cat_search/) {
            my @cats;
            if ($2 =~ m/$reg_name/) {
                @cats = split /, */, $1;
            }
            else {
                @cats = split / +/, $2;
            }

            foreach my $cat (@cats) {
                $categories{$cat}++;
            }
        }

        #tags
        if ($row =~ m/$tag_search/) {
            my @tags;
            if ($1 =~ m/$reg_name/) {
                @tags = split /, */, $1;
            }
            else {
                @tags = split / +/, $1;
            }
            foreach my $tag (@tags) {
                $tags{$tag}++;
            }
        }
    }

    close $fh;
}

# create category files
say "Categories:";
while ((my $cat) = each (%categories)) {
    my $filename = $cat_dir . lc $cat . ".html";
    $filename =~ s/ /_/g;

    # The category file does not exist
    unless (-e $filename) {
        say "  $cat";
        print " - " . $filename;
        say "  - File does not exist";

        # Open the file for writing and write the frontmatter
        open(my $fh, '>', $filename);
        print $fh "---\n";
        print $fh "layout: category\n";
        print $fh "permalink: $cat_per/" . $cat =~ s/ /_/r . "/\n";
        print $fh "category: $cat\n";
        print $fh "title: $cat\n";
        print $fh "---\n";
        close $fh;
        say "  - Created\n";
    }
}

say "\nTags:";
while ((my $tag) = each (%tags)) {
    my $filename = $tag_dir . lc $tag . ".html";
    $filename =~ s/ /_/g;

    # The tag file does not exist
    unless (-e $filename) {
        say "  $tag";
        print "  - " . $filename;
        say " - File does not exist";
        
        # Open the file for writing and write the frontmatter
        open(my $fh, '>', $filename);
        print $fh "---\n";
        print $fh "layout: tag\n";
        print $fh "permalink: $tag_per/" . $tag =~ s/ /_/r . "/\n";
        print $fh "tag: $tag\n";
        print $fh "title: $tag\n";
        print $fh "---\n";
        close $fh;
        say "  - Created\n";
    }
}

say "\nDone!\n";
