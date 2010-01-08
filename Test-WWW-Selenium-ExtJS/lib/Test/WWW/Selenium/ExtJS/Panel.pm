package Test::WWW::Selenium::ExtJS::Panel;

use Test::WWW::Selenium::ExtJS::Panel::FooterToolbar;

use Moose;                                       # Includes strict and warnings

extends "Test::WWW::Selenium::ExtJS::Container";

use Readonly;
Readonly my $TRUE       => 1;
Readonly my $FALSE      => 0;


# xtype - set the default xtype of this Ext component
has '+xtype' => (
    default => 'panel',
);


# Gets the toolbar object or the footer toolbar
sub get_footer_toolbar {
    my $self = shift;

    my $toolbar = new Test::WWW::Selenium::ExtJS::Panel::FooterToolbar( parent => $self );

    return $toolbar;
}


1;  # Magic true value required at end of module
__END__
