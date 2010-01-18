#!perl -T

use Test::More;

# sub Pod::Coverage::TRACE_ALL () { 1 }

eval "use Test::Pod::Coverage 1.04";
plan skip_all => "Test::Pod::Coverage 1.04 required for testing POD coverage" if $@;

my $trustme = { trustme => [qr/^(BUILD)$/] };

all_pod_coverage_ok( $trustme );

done_testing();
