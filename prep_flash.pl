#!/usr/bin/env perl

use 5.014;
use utf8;

use Text::CSV qw(csv);
use List::Util qw(shuffle);

binmode STDOUT, ":utf8";

# We are going to parse our input csv file and then generate our decks

my $hicolor = "Blue";

sub highlight {
    my ($word, $o) = @_;
    my $r = $o =~ s|\b$word\b|<span style="color:$hicolor">$word</span>|r;
    my $tword = ucfirst($word);
    my $s = $r =~ s|^$tword\b|<span style="color:$hicolor">$tword</span>|r;
    return $s;
}

sub get_case {
    return "prepositional" if $_[0] eq "prep";
    return "accusitive" if $_[0] eq "acc";
    return "genitive" if $_[0] eq "gen";
    return "dative" if $_[0] eq "dat";
    return "instrumental" if $_[0] eq "inst";
}

my $h = csv( in => "russian_prepositions.csv",
	     encoding => "UTF-8",
	     headers => "auto" );

my @hf;
my @out;

# We are shuffling the list because we want the deck order to be
# randomized, so that not all of the same prepositions show up
# on the same day and time.
#
# Studies have shown that too much repetition of similar things
# leads them to be jumbled together.
#
# See http://www.victoria.ac.nz/lals/about/staff/publications/paul-nation/foreign-language_1125.pdf
for my $hr ( shuffle @{ $h } ) {
    my $front = highlight($hr->{word}, $hr->{ru_sentence});
    my $back = $hr->{word} . " : " . $hr->{english} . " : " . get_case($hr->{case}) . "<br>" . $hr->{en_sentence};
    my $slide = [$front, $back];

    push @out, $slide;
    push @hf, $slide if $hr->{advanced} eq "";
}

csv( in => \@out, out => "prep_all_flash.csv", encoding => "UTF-8" );
csv( in => \@hf, out => "prep_hf_flash.csv", encoding => "UTF-8" );
