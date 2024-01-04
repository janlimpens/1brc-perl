#! /usr/bin/env perl

# First naive attempt at this problem. Runs in around 35m on my machine (an Intel NUC).

use Modern::Perl '2015';
use List::Util qw/min max sum/;
###
use utf8;
binmode(STDOUT, ':encoding(UTF-8)');
binmode(STDIN, ':encoding(UTF-8)');
my $Data;
while (<>) {
    chomp;
    my ( $city, $temp ) = split(/;/, $_ );
    if ($Data->{$city}) {
    $Data->{$city}[0] = $temp if $temp < $Data->{$city}[0];  # min
    $Data->{$city}[1] = $Data->{$city}[1]*$Data->{$city}[3]/($Data->{$city}[3]+1) + $temp/($Data->{$city}[3]+1); # avg
    $Data->{$city}[2] = $temp if $temp > $Data->{$city}[2];  # max
    $Data->{$city}[3]++;
		   
	    
    } else {
	# I used an array reference here, in the hopes it would be slightly faster. Using a hashref instead would be more readable
	#                   min,  avg,   max, count
	$Data->{$city} = [$temp,$temp, $temp, 1];
    } 
}

my @results;
for my $city (sort {$a cmp $b} keys %$Data){
    push @results, "$city=".join('/', map {sprintf("%.1f", $_)} (@{$Data->{$city}}[0,1,2]));
   
}
say '{'.join(', ',@results).'}';
