package Test::WWW::Selenium::ExtJS::Form::TextField;

use Moose;                                       # Includes strict and warnings

extends "Test::WWW::Selenium::ExtJS::Form::Field";

use Readonly;
Readonly my $TRUE   => 1;
Readonly my $FALSE  => 0;


# xtype - set the default xtype of this Ext component
has '+xtype' => (
    default => 'textfield',
);


# Build component from given parameters
sub BUILD {
    my ( $self, $params ) = @_;

# build params
}


# Add specific methods here
sub type_value {
    my $self = shift;
    my ( $value ) = @_;

    # Return for chaining
    return $self->wait_for_rendered->focus->type( $value );
}

1;  # Magic true value required at end of module
__END__
