use Test::More;

use HTTP::Request;
use LWP::UserAgent;
use Test::WWW::Selenium;
use Test::WWW::Selenium::ExtJS;

use Readonly;
Readonly my $EXTJS => 'http://www.extjs.com/deploy/dev/examples/window/hello.html';


# Check if connection to internet is availble
my $request = HTTP::Request->new( GET => $EXTJS );
my $ua = LWP::UserAgent->new;
my $response = $ua->request( $request );


plan( skip_all => "Could not connect to ExtJS example web; skipping" ) 
    if ($response->code != 200);

my $sel;
eval {
    # create Selenium instance
    $sel = Test::WWW::Selenium->new( 
        host        => "localhost", 
        port        => 4444, 
        browser     => "*firefox", 
        browser_url => 'http://www.google.com/',
    );
    $sel->open_ok ( '$EXTJS' );
};

plan( skip_all => "Selenium could not be started - Is a selenium server installed and Firefox available?; skipping" ) 
    if $@;

# Prepare ExtJS proxies
my $extjs = new Test::WWW::Selenium::ExtJS( 
    selenium                    => $sel, 
    js_preserve_window_objects  => [qw( Glue swfobject )],
#     resize_window               => [1000, 600],
    maximize_window             => 1,
);

done_testing();
