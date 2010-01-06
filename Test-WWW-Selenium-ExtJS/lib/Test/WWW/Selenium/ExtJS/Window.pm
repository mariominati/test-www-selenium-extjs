package Test::WWW::Selenium::ExtJS::Window;

use Moose;                                       # Includes strict and warnings

extends "Test::WWW::Selenium::ExtJS::Panel";

use Readonly;
Readonly my $TRUE       => 1;
Readonly my $FALSE      => 0;


# xtype - set the default xtype of this Ext component
has '+xtype' => (
    default => 'window',
);


# Wait until the window is present

sub wait_eval_window_rendered {
    my $self = shift;

    $self->wait_eval_on_component_true( ".rendered;" );
}


# Check window title

sub get_title {
    my $self = shift;

    $self->wait_for_rendered;
#     $self->wait_eval_window_rendered;              # Wait until component ready

    return $self->get_eval_on_component( ".title;" );
}


1;  # Magic true value required at end of module
__END__
