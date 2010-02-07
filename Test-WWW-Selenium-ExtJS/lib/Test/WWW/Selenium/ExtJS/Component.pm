package Test::WWW::Selenium::ExtJS::Component;

use Test::WWW::Selenium::ExtJS;

use Moose;                                       # Includes strict and warnings

use Readonly;
Readonly my $TRUE           => 1;
Readonly my $FALSE          => 0;
Readonly my $ID_FUNCTION    => ".getId()";


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

# ext_id - id of the Ext component
has 'ext_id' => (
    isa         => 'Str', 
    is          => 'rw', 
    predicate   => 'has_ext_id',
);

# html_id - id of the HTML representation (DOM) of the Ext component
has 'html_id' => (
    isa         => 'Str', 
    is          => 'rw', 
    predicate   => 'has_html_id',
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

has '_available' => (
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

    # Build a expression from a given ext id
    if ($self->has_ext_id) {
        $self->expression( "Ext.getCmp('" . $self->ext_id . "')" );
        $self->html_id( $self->ext_id );
    }

    # If we only got a html_id then we will on the first call of get_expression
    # to find the ext_js id
};


# Returns the HTML ID of the Ext component, found with the proxy's JS expression. 
# This is overridden in some subclasses for where the expression to get 
# the ID varies.
sub get_html_id {
    my $self = shift;

    return $self->html_id
        if $self->has_html_id;

    return $self->extjs->get_eval( $self->get_expression() . $ID_FUNCTION );
}


# wait_for_component_search_by_id
sub wait_for_extjs_id_from_html_id {
    my $self = shift;

    # if this method is called on a component without an id throw an exception
    die "The html id of this component has not been defined."
        if ( not $self->has_html_id );

    # create javascript that find's a given dom id in all components
    my $js =
        "var component_id;
        if ( this && Ext && Ext.ComponentMgr ) {
            Ext.ComponentMgr.all.each( function(item,index,length) {     
                if ( item.el.id == '" . $self->html_id . "') {
                    component_id = item.getId();
                    return false;     
                } 
            });
        }
        return component_id;";

    # Wait until the has has been found
    my $id = $self->extjs->wait_until_pure_expression_resolves( $js );

    # Rewrite id and expression
    $self->ext_id ( $id );
    $self->expression( "Ext.getCmp('" . $self->ext_id . "')" );

    # Allow chaining
    return $self;
}


# Returns an XPath to the Ext component, which contains the ID provided 
# by get_html_id()
sub get_xpath {
    my $self = shift;

    return "//*[\@id='" . $self->get_html_id() . "']";
}


# Returns the absolute expression that resolves this proxy's Ext component.
sub get_expression {
    my $self = shift;

    # Search for ext_id if none is set
    if ($self->has_html_id && !$self->has_ext_id) {
        $self->wait_for_extjs_id_from_html_id();
    }

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
# else dies on timeout.
sub wait_eval_on_component_true {
    my $self = shift;
    my ($expression, $timeout) = @_;

    my $componentExpression = $self->get_expression() . $expression;

    return $self->extjs->wait_eval_true( $componentExpression, $timeout );
}


###
###   Convenience methods to evaluate properties of the Ext component
###


sub get_eval_component_string_property {
    my $self = shift;
    my ($property) = @_;

    return $self->get_eval_on_component( ".$property;" );
}


sub get_eval_component_property_exists {
    my $self = shift;
    my ($property) = @_;

    my $result = $self->get_eval_component_string_property( $property );

# TODO - check results
die $result;

    return ($result eq 'null');
}


sub get_eval_component_boolean_property {
    my $self = shift;
    my ($property) = @_;

    my $result = $self->get_eval_component_string_property( $property );

    return ( $result eq "true" ? $TRUE : $FALSE );
}


# TODO
#     protected int getEvalIntegerProperty(String name) { ... }
#     protected double getEvalDoubleProperty(String name) { ... }


###
###   Methods to synchronise with AJAX
###

# Checks if the component object is already available
sub wait_for_component {
    my $self = shift;

    # Shortcut if check has been done
    return $self
        if $self->_available;

    # Wait until component is resolvable
    my $componentExpression = $self->get_expression() . ";";
    $self->extjs->wait_until_expression_resolves( $componentExpression );

    # Store success
    $self->_available( $TRUE );

    # Return $self for chaining
    return $self;
}


# Checks if the component has already been rendered
sub wait_for_component_rendered {
    my $self = shift;

    # Shortcut if check has been done
    return $self
        if $self->_rendered;

    # Get basic expression for this object
    my $component_expression = $self->get_expression();

    # Build javascript expression
    my $expression = 
        '(( this && Ext && Ext.getCmp && Ext.ComponentMgr && ' .
        $component_expression . ' && ' .
        $component_expression . '.rendered ) ? true : false)';

    # Wait until the page has been loaded
    $self->extjs->wait_eval_true( $expression );

    # Store success
    $self->_rendered( $TRUE );

    # Return $self for chaining
    return $self;
}


# Returns the enabled state of the component
sub is_enabled {
    my $self = shift;

    return ( ! $self->get_eval_component_boolean_property( "disabled" ));
}


1; # Magic true value required at end of module
__END__


=head1 NAME

Test::WWW::Selenium::ExtJS::Component - Proxy class for Ext.Component


=head1 SYNOPSIS

Look at L<Test::WWW::Selenium::ExtJS>.
  
  
=head1 DESCRIPTION

This is the proxy class for the Ext.Component object. It is the base class for
all other gui widget classes as it is in the ExtJS framework.
L<http://www.extjs.com/deploy/dev/docs/?class=Ext.Component>


=head1 INTERFACE 

=head2 Attributes

=head3 C<parent>

Type: C<Test::WWW::Selenium::ExtJS::Component> object.

Proxy for the containing ExtJS component.

We need either the L<parent> or the L<extjs> attribute to connect to the 
selenium object.

=head3 C<extjs>

Type: C<Test::WWW::Selenium::ExtJS> object.

The central ExtJS object.

We need either the L<parent> or the L<extjs> attribute to connect to the 
selenium object.

=head3 C<expression>

Type: C<Str>.

The JavaScript expression that will be evaluated to access the ExtJS component
in selenium.

If L<expression> is not given, we need the L<id> attribute.

=head3 C<ext_id>

Type: C<Str>.

Sets the id of the Ext component. This is usually used for windows, viewports
and other objects with fixed id.

If L<ext_id> is not given, we need the L<expression> attribute.

=head3 C<html_id>

Type: C<Str>.

The id of the DOM object of the Ext component.

If not given, the L<html_id> is autogenerated (automatically requested) on first use.

=head3 C<xtype>

Type: C<Str>.

The XType of the Ext component, default is 'component'.

=head2 General methods

=head3 C<get_id>

Returns the ID of the Ext component, found with the proxy's JS expression. 

=head3 C<get_xpath>

Returns an XPath to the Ext component, which contains the ID provided 
by L<get_id>.

=head3 C<get_expression>

Returns the absolute expression that resolves this proxy's Ext component.

=head3 C<get_eval_on_component>

Evaluates expression on this component.

=head2 Component methods to synchronise with AJAX

=head3 C<wait_eval_on_component_true>

Waits until the expression for this component evals true, dies on timeout.

=head2 Convenience methods to evaluate properties

=head3 C<get_eval_component_string_property>

Gets a property from the Ext component as string.

=head3 C<get_eval_component_property_exists>

Returns true if the requested property exists in the Ext component.

=head3 C<get_eval_component_boolean_property>

Gets a property from the Ext component as boolean value.
If the property equals 'true' we return a true value.

=head2 Methods to synchronise with AJAX

=head3 C<wait_for_component>

Does a wait loop until the component is available.

=head3 C<wait_for_component_rendered>

Does a wait loop until the component is available and rendered.

=head3 C<is_enabled>

Returns true if the 'disabled' property of the component is B<not> set,
false otherwise.


=head1 DIAGNOSTICS

Look at L<Test::WWW::Selenium::ExtJS>.


=head1 CONFIGURATION AND ENVIRONMENT

Look at L<Test::WWW::Selenium::ExtJS>.


=head1 DEPENDENCIES

Look at L<Test::WWW::Selenium::ExtJS>.


=head1 INCOMPATIBILITIES

Look at L<Test::WWW::Selenium::ExtJS>.


=head1 BUGS AND LIMITATIONS

Look at L<Test::WWW::Selenium::ExtJS>.

Please report any bugs or feature requests to
L<http://github.com/mariominati/test-www-selenium-extjs/issues>,
or send an email to the author.


=head1 AUTHOR

Mario Minati  C<< <mario.minati@minati.de> >>


=head1 LICENCE AND COPYRIGHT

Copyright (c) 2009, Mario Minati C<< <mario.minati@minati.de> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.


=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.

