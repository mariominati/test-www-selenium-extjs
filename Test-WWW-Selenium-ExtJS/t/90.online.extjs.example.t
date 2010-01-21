use Test::More;

use HTTP::Request;
use LWP::UserAgent;

use Readonly;
Readonly my $EXTJS => 'http://www.extjs.com/deploy/dev/examples/window/hello.html';


# Check if connection to internet is availble
my $request = HTTP::Request->new( GET => $EXTJS );
my $ua = LWP::UserAgent->new;
my $response = $ua->request( $request );


plan( skip_all => "Could not connect to ExtJS example web; skipping" ) 
    if ($response->code != 200);

ok( 1 );

done_testing();