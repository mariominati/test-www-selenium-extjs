package Test::WWW::Selenium::ExtJS::Component;

use Moose;                                       # Includes strict and warnings

use WWW::Selenium;
use Readonly;
# use Carp;

Readonly my $TRUE       => 1;
Readonly my $FALSE      => 0;
Readonly my $ID_FUNCTION => ".getId()";


# parent - proxy for the container Ext component
has 'parent' => (
    isa         => 'Test::WWW::Selenium::ExtJS::Component', 
    is          => 'ro',
    predicate   => 'has_parent',
);

# extjs - central extjs testing object
has 'extjs' => (
    isa         => 'Test::WWW::Selenium::ExtJS', 
    is          => 'rw', 
    predicate   => 'has_extjs',
);

# expression - JavaScript that evaluates to the Ext component
has 'expression' => (
    isa         => 'Str', 
    is          => 'rw', 
    predicate   => 'has_expression',
);

# id - id of the Ext component
has 'id' => (
    isa         => 'Str', 
    is          => 'ro', 
    predicate   => 'has_id',
);

# xtype - The XType of the Ext component
has 'xtype' => (
    isa         => 'Str', 
    is          => 'ro', 
    default     => 'component',
);

has '_rendered' => (
    isa         => 'Bool',
    is          => 'rw', 
    default     => $FALSE,
);


# Build component from given parameters
sub BUILD {
    my ( $self, $params ) = @_;

    # Get the extjs object from the parent if given
    if ($self->has_parent && not $self->has_extjs) {
        $self->extjs( $self->parent->extjs );
    }

    # Build a expression from a given id
    if ($self->has_id) {
        $self->expression( "Ext.getCmp('" . $self->id . "')" );
#         $self->expression( "window.Ext.getCmp('" . $self->id . "')" );
    }

    # Check required parameters
#     die "Missing parameter" 
#         unless $self->has_extjs && $self->has_expression;
};


# Returns the ID of the Ext component, found with the proxy's JS expression. 
# This is overridden in some subclasses for where the expression to get 
# the ID varies.

sub get_id {
    my $self = shift;

    return $self->extjs->get_eval( $self->get_expression() . $ID_FUNCTION );
}


# Returns an XPath to the Ext component, which contains the ID provided 
# by get_id()

sub get_xpath {
    my $self = shift;

    return "//*[\@id='" . $self->get_id() . "']";
}


# Returns the absolute expression that resolves this proxy's Ext component.

sub get_expression {
    my $self = shift;

    return $self->has_parent 
        ? $self->parent->get_expression() . $self->expression 
        : $self->expression;
}


# Immediately evaluates expression on this component.

sub get_eval_on_component {
    my $self = shift;
    my $expression = shift;

    my $componentExpression = $self->get_expression() . $expression;

    return $self->extjs->get_eval( $componentExpression );
}


###
###   Component methods to synchronise with AJAX
###


# Returns as soon as the expression for this component evals true, 
# else throws exception on timeout.

sub wait_eval_on_component_true {
    my $self = shift;
    my ($expression, $timeout) = @_;

    my $componentExpression = $self->get_expression() . $expression;

    return $self->extjs->wait_eval_true( $componentExpression, $timeout );
}

# Working With Pop-Ups
# Assumes only 1 currently opened window with target _blank
# sub select_target_blank_window {
#     my ($self, $timeout) = @_;
#     my $window_name;
#     for (1 .. $timeout / 100) {
#        ($window_name) = grep {/selenium_blank\d+/} $self->get_all_window_names;
#        last if defined $window_name;
#        $self->pause(100);
#     }
#     croak "Timed out waiting to select blank target window" if ! defined $window_name;
#     return $self->select_window($window_name);
# }


###
###   Convenience methods to evaluate properties of the Ext component
###


sub get_eval_component_string_property {
    my $self = shift;
    my ($property) = @_;

    return $self->get_eval_on_component( ".$property" );
}


sub get_eval_component_property_exists {
    my $self = shift;
    my ($property) = @_;

    my $result = $self->get_eval_component_string_property( $property );

# TODO - check results
warn $result;
}

#     protected String getEvalStringProperty(String name) { ... }
#     protected boolean getEvalPropertyExists(String name) { ... }
#     protected boolean getEvalBooleanProperty(String name) { ... }
#     protected int getEvalIntegerProperty(String name) { ... }
#     protected double getEvalDoubleProperty(String name) { ... }


# Checks if the component has already been rendered

sub wait_for_rendered {
    my $self = shift;

    # Shortcut if check has been done
    return $self
        if $self->_rendered;

    # Wait until component has been rendered
    $self->wait_eval_on_component_true( ".rendered;" );

    # Store success
    $self->_rendered( $TRUE );

    # Return $self for chaining
    return $self;
}



1; # Magic true value required at end of module
__END__


=head1 NAME

Test::WWW::Selenium::ExtJS::Document::Component - Selenium tests for ExtJS components

