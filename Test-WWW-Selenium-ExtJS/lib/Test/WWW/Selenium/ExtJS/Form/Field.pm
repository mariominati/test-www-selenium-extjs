package Test::WWW::Selenium::ExtJS::Form::Field;

use Moose;                                       # Includes strict and warnings

extends "Test::WWW::Selenium::ExtJS::BoxComponent";

use Readonly;
Readonly my $TRUE       => 1;
Readonly my $FALSE      => 0;


# name - name of the Field
has 'name' => (
    isa         => 'Str', 
    is          => 'ro', 
    predicate   => 'has_name',
);

# xtype - set the default xtype of this Ext component
has '+xtype' => (
    default => 'field',
);


# Build component from given parameters
sub BUILD {
    my ( $self, $params ) = @_;

    die "Missing parameter 'name'." 
        unless $self->has_name;

    # Set expression to find first field with given name
    $self->expression(
        ".findBy( function (component) {" .
        " return (component.isXType && component.isXType('" . $self->xtype . "'))" .
        " && (component.name && component.name == '" . $self->name . "')" .
        " })[0]"
    );
}


# Focus this field

sub focus {
    my $self = shift;

    $self->extjs->selenium->fire_event( $self->get_id, "focus" );

    return $self;
}


# Blur this field

sub blur {
    my $self = shift;

    $self->extjs->selenium->fire_event( $self->get_id, "blur" );

    return $self;
}


# Type text into this field

sub type {
    my $self = shift;
    my ($text) = @_;

    my $id = $self->get_id;

    $self->extjs->selenium->type_ok( $self->get_id, $text );

    return $self;
}


1;  # Magic true value required at end of module
__END__
