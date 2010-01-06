package Test::WWW::Selenium::ExtJS::BoxComponent;

use Moose;                                       # Includes strict and warnings

extends "Test::WWW::Selenium::ExtJS::Component";

use Readonly;
Readonly my $TRUE       => 1;
Readonly my $FALSE      => 0;


# xtype - set the default xtype of this Ext component
has '+xtype' => (
    default => 'box',
);


# Add specific methods here


1;  # Magic true value required at end of module
__END__
