package Test::WWW::Selenium::ExtJS::Button;

use Moose;                                       # Includes strict and warnings

extends "Test::WWW::Selenium::ExtJS::Component";

use Readonly;
Readonly my $TRUE   => 1;
Readonly my $FALSE  => 0;


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
    $self->expression(
        ".findBy( function (component) {" .
        " return (component.isXType && component.isXType('" . 
            $self->xtype . "'))" .
        " && (component.text && component.text == '" . $self->text . "')" .
        " })[0]"
    );
}


# Executes a click on the button
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


=head1 NAME

Test::WWW::Selenium::ExtJS::Button - Proxy class for Ext.Button


=head1 SYNOPSIS

Look at L<Test::WWW::Selenium::ExtJS>.
  
  
=head1 DESCRIPTION

This is the proxy class for the Ext.Button object and extends the 
L<Test::WWW::Selenium::ExtJS::Component> object.
L<http://www.extjs.com/deploy/dev/docs/?class=Ext.Button>


=head1 INTERFACE 

=head2 Attributes

The attributes of the base class are described at 
L<Test::WWW::Selenium::ExtJS::Component>.

=head3 C<xtype>

Type: C<Str>.

The XType of the Ext component, default is 'button'.

=head3 C<text>

Type: C<Str>, B<Required>.

The text of the button.

=head2 General methods

The methods of the base class are described at 
L<Test::WWW::Selenium::ExtJS::Component>.

=head3 C<click>

Executes a click on the button.

The click is executed via seleniums click_ok method, so it counts as test.


=head1 DIAGNOSTICS

Look at L<Test::WWW::Selenium::ExtJS::Component>.

=over

=item C<< Missing parameter 'text'. >>

The attribute L<text> is required.

=back

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
