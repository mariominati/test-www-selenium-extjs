package Test::WWW::Selenium::ExtJS::Button;

use Moose;                                       # Includes strict and warnings

extends "Test::WWW::Selenium::ExtJS::Component";

use Readonly;
Readonly my $TRUE       => 1;
Readonly my $FALSE      => 0;


# text - text of the Button
has 'text' => (
    isa         => 'Str', 
    is          => 'ro', 
    predicate   => 'has_text',
);

# xtype - set the default xtype of this Ext component
has '+xtype' => (
    default => 'button',
);


# Build component from given parameters
sub BUILD {
    my ( $self, $params ) = @_;

    die "Missing parameter 'text'." 
        unless $self->has_text;

    # Set expression to find first field with given name
# fix this
    $self->expression(
        ".findBy( function (component) {" .
        " return (component.isXType && component.isXType('" . $self->xtype . "'))" .
        " && (component.text && component.text == '" . $self->text . "')" .
        " })[0]"
    );
}


# Add specific methods here
sub click {
    my $self = shift;

#     log("click()");

    # Wait until component has been rendered
    $self->wait_eval_on_component_true( ".disabled == false;" );

    # Perform the click on the button
    $self->extjs->selenium->click_ok( $self->get_id );

    return $self;
}


1;  # Magic true value required at end of module
__END__
