package Test::WWW::Selenium::ExtJS::Toolbar;

use Moose;                                       # Includes strict and warnings

extends "Test::WWW::Selenium::ExtJS::Container";

use Readonly;
Readonly my $TRUE       => 1;
Readonly my $FALSE      => 0;


# xtype - set the default xtype of this Ext component
has '+xtype' => (
    default => 'toolbar',
);


# Build component from given parameters
sub BUILD {
    my ( $self, $params ) = @_;

    # This is just a base class, so we don't set an expression
    # Using this component directly means setting the expression string 
    # your self.
}


# Add specific methods here


1;  # Magic true value required at end of module
__END__
