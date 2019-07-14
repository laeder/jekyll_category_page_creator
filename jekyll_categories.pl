#!/usr/bin/env perl

use 5.014;
use strict;

my $dh;
my $dir = "_posts/";

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
    my $filename = "categories/" . lc $cat . ".html";

    # The category file does not exist
    unless (-e $filename) {
        say "  $cat";
        print " - " . $filename;
        say "  - File does not exist";

        # Open the file for writing and write the frontmatter
        open(my $fh, '>', $filename);
        print $fh "---\n";
        print $fh "layout: category\n";
        print $fh "permalink: /categories/$cat/\n";
        print $fh "category: $cat\n";
        print $fh "title: $cat\n";
        print $fh "---\n";
        close $fh;
        say "  - Created\n";
    }
}

say "\nTags:";
while ((my $tag) = each (%tags)) {
    my $filename = "tags/" . lc $tag . ".html";
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
        print $fh "permalink: /tags/" . $tag =~ s/ /_/r . "/\n";
        print $fh "tag: $tag\n";
        print $fh "title: $tag\n";
        print $fh "---\n";
        close $fh;
        say "  - Created\n";
    }
}

say "\nDone!\n";
