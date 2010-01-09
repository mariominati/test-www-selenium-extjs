package Test::WWW::Selenium::ExtJS::Panel::BottomToolbar;

use Moose;                                       # Includes strict and warnings

extends "Test::WWW::Selenium::ExtJS::Toolbar";

use Readonly;
Readonly my $TRUE   => 1;
Readonly my $FALSE  => 0;


# Build component from given parameters
sub BUILD {
    my ( $self, $params ) = @_;

    # Set expression to find the footer toobar of a panel
    $self->expression(
        ".bbar"
    );
}


# Add specific methods here


1;  # Magic true value required at end of module
__END__
