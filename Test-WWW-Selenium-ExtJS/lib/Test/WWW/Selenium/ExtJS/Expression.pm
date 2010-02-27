package Test::WWW::Selenium::ExtJS::Expression;

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


# Build component from given parameters
sub BUILD {
    my ( $self, $params ) = @_;

    # Get the extjs object from the parent if given
    if ($self->has_parent && not $self->has_extjs) {
        $self->extjs( $self->parent->extjs );
    }
};


# Returns the absolute expression that resolves this proxy's Ext component.
sub get_expression {
    my $self = shift;

    return $self->has_parent 
        ? $self->parent->get_expression() . $self->expression 
        : $self->expression;
}


1; # Magic true value required at end of module
__END__


=head1 NAME

Test::WWW::Selenium::ExtJS::Expression - Base class for Ext.Component and Ext.Layout


=head1 SYNOPSIS

Look at L<Test::WWW::Selenium::ExtJS>.
  
  
=head1 DESCRIPTION

This is the common base class for the component and layout object and provides
functionallity to build and store the javascript expressions to access the Ext 
and DOM objects.


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


=head2 General methods

=head3 C<get_expression>

Returns the absolute expression that resolves this proxy's Ext component.


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

