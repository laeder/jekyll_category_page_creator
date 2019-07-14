#!/usr/bin/env perl

use 5.014;
use strict;

my $dh;
my $dir = "_posts/";

# Open the directory
opendir my $dh, $dir or die "Could not open '$dir' for reading: $!\n";

my @files = readdir $dh;
my @posts;

# Put all files except . and .. in an array
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

# Read the files
foreach my $post (@posts) {
    my $filename = $dir . $post;
    my $started = 0;

    open(my $fh, '<:encoding(UTF-8)', $filename)
      or die "Could not open file '$filename' $!";
     
    while (my $row = <$fh>) {
        chomp $row;

        # --- starts and ends the frontmatter
        if ($row =~ m/^--- *$/) {
            if ($started) { last; }
            $started++;
        }

        # categories
        if ($row =~ m/^category: *\[([A-Za-z, -]+)\] */) {
            my @cats = split /, */, $1;
            foreach my $cat (@cats) {
                $categories{$cat}++;
            }
        }

        #tags
        if ($row =~ m/^tags: *\[([A-Za-z, -]+)\] */) {
            my @tags = split /, */, $1;
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
    say $cat;

    my $filename = "categories/" . lc $cat . ".html";
    print " - " . $filename;
    if (-e $filename) {
        say " - File exists";
    }
    else {
        say " - File does not exist";
        open(my $fh, '>', $filename);
        print $fh "---\n";
        print $fh "layout: category\n";
        print $fh "permalink: /categories/$cat/\n";
        print $fh "category: $cat\n";
        print $fh "title: $cat\n";
        print $fh "---\n";
        close $fh;
        say " - Created";
    }
}
say " ";
say "Tags:";
while ((my $tag) = each (%tags)) {
    say $tag;
    my $filename = "tags/" . lc $tag . ".html";
    $filename =~ s/ /_/g;
    print " - " . $filename;
    if (-e $filename) {
        say " - File exists";
    }
    else {
        say " - File does not exist";
        open(my $fh, '>', $filename);
        print $fh "---\n";
        print $fh "layout: tag\n";
        print $fh "permalink: /tags/" . $tag =~ s/ /_/r . "/\n";
        print $fh "tag: $tag\n";
        print $fh "title: $tag\n";
        print $fh "---\n";
        close $fh;
        say " - Created";
    }
}

say " ";
say "done\n";
