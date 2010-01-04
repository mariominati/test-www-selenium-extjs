package Test::WWW::Selenium::ExtJS::Form::TextField;

use Moose;                                       # Includes strict and warnings

extends "Test::WWW::Selenium::ExtJS::Form::Field";

use Readonly;
Readonly my $TRUE       => 1;
Readonly my $FALSE      => 0;


# Build component from given parameters
sub BUILD {
    my ( $self, $params ) = @_;

# build params
}


# Add specific methods here


1;  # Magic true value required at end of module
__END__
