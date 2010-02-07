use Test::More;

use HTTP::Request;
use LWP::UserAgent;
use Test::WWW::Selenium;
use Test::WWW::Selenium::ExtJS;
use Test::WWW::Selenium::ExtJS::Window;

use Readonly;
Readonly my $EXTJS => 'http://www.extjs.com/deploy/dev/examples/window/hello.html';


# Check if connection to internet is availble
my $request = HTTP::Request->new( GET => $EXTJS );
my $ua = LWP::UserAgent->new;
my $response = $ua->request( $request );

plan( skip_all => "Could not connect to ExtJS example web; skipping" ) 
    if ($response->code != 200);


# Find selenium server
my $sel;
eval {
    # create Selenium instance
    $sel = Test::WWW::Selenium->new ( 
        host        => "localhost", 
        port        => 4444, 
        browser     => "*firefox", 
        browser_url => 'http://www.google.com/',
    );
    $sel->open_ok ( $EXTJS );
};

plan ( skip_all => "Selenium could not be started - Is a selenium server running and Firefox available?; skipping" ) 
    if $@;


# Prepare ExtJS proxies
my $extjs = new Test::WWW::Selenium::ExtJS ( 
    selenium                    => $sel, 
    js_preserve_window_objects  => [qw( swfobject )],
    maximize_window             => 1,
);

# Click button to open example window
$sel->click_ok ( 'show-btn' );

# Create window proxy
my $window = new Test::WWW::Selenium::ExtJS::Window ( 
    extjs   => $extjs, 
    html_id => 'hello-win' 
);

# Test window title
is ( $window->get_title, 'Hello Dialog', 'window title' );

# Keep window visible for 3 secs
# $sel->pause ( 3000 );

# End testing
done_testing();
