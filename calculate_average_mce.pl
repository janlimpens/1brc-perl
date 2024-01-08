use strict;
use warnings;
use v5.38;
use MCE::Loop;

MCE::Loop->init( max_workers => 8, use_slurpio => 1 );

my $file = $ARGV[0];
my $start = time();

my @result = mce_loop_f {
    my ($mce, $slurp_ref, $chunk_id) = @_;
    my %data;
    open my $MEM_FH, '<', $slurp_ref;
    binmode $MEM_FH, ':raw';
    while (<$MEM_FH>) {
        chomp;
        my ( $city, $temp ) = split( /;/, $_, 2);
        if ( my $d = $data{$city} )
        {
            if ($temp < $d->{min}) {
                $d->{min} = $temp
            } elsif ($temp > $d->{max}) {
                $d->{max} = $temp
            }
        }
        else
        {
            $data{$city} = { min => $temp, max => $temp };
        }
        my $sum = $data{$city}->{sum} // 0;
        $data{$city}->{sum} = $sum + $temp;

        my $n = $data{$city}->{n} // 0;
        $data{$city}->{n} = $n + 1;
    }
    close $MEM_FH;
    MCE->gather(\%data);
} $file;

my %final_data;

# Merge the results
for my $result (@result) {
    while (my ($city, $data) = each %$result) {
        if (my $d = $final_data{$city}) {
            if ($data->{min} < $d->{min}) {
                $d->{min} = $data->{min};
            }
            if ($data->{max} > $d->{max}) {
                $d->{max} = $data->{max};
            }
        } else {
            $final_data{$city} = $data;
        }
    }
}

# Print the final results
print "{ ";

for my $city ( sort keys %final_data ) {
    my $data = delete $final_data{$city};
    my $avg = $data->{sum} / $data->{n};
    print "{ $city: $data->{min}/$avg/$data->{max} }";
    print ", " if %final_data;
}

print " }\n";

my $end = time();
my $run_time = $end - $start;

print "Processed in $run_time seconds\n";

1;
