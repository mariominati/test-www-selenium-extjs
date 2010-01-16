package Test::WWW::Selenium::ExtJS::Viewport;

# use Test::WWW::Selenium::ExtJS::Panel::FooterToolbar;

use Moose;                                       # Includes strict and warnings

extends "Test::WWW::Selenium::ExtJS::Container";

use Readonly;
Readonly my $TRUE       => 1;
Readonly my $FALSE      => 0;


# xtype - set the default xtype of this Ext component
has '+xtype' => (
    default => 'viewport',
);


# On loading the page (after login) we have to wait that the new page is being
# loaded, Ext is being initialized and the viewport loaded
sub wait_for_viewport_available {
    my $self = shift;

    # Get basic expression for this object
    my $component_expression = $self->get_expression();

    # Build javascript expression
    my $expression = 
        '(( this && Ext && Ext.getCmp && Ext.ComponentMgr && ' .
        $component_expression . ' && ' .
        $component_expression . '.rendered ) ? true : false)';

    # Wait until the page has been loaded
    $self->extjs->wait_eval_true( $expression );

    # Allow chaining
    return $self;
}

# Gets the toolbar object or the footer toolbar
# sub get_north_panel {
#     my $self = shift;
# 
#     my $toolbar = new Test::WWW::Selenium::ExtJS::Panel::FooterToolbar( parent => $self );
# 
#     return $toolbar;
# }


1;  # Magic true value required at end of module
__END__
