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


# Types the given text into the form field
sub type_value {
    my $self = shift;
    my ( $value ) = @_;

    # Return for chaining
    return $self->wait_for_component_rendered->focus->type( $value );
}

1;  # Magic true value required at end of module
__END__


=head1 NAME

Test::WWW::Selenium::ExtJS::Form::TextField - Proxy class for Ext.form.TextField


=head1 SYNOPSIS

Look at L<Test::WWW::Selenium::ExtJS>.
  
  
=head1 DESCRIPTION

This is the proxy class for the Ext.form.TextField object and extends the 
L<Test::WWW::Selenium::ExtJS::Form::Field> object.
L<http://www.extjs.com/deploy/dev/docs/?class=Ext.form.TextField>


=head1 INTERFACE 

=head2 Attributes

The attributes of the base class are described at 
L<Test::WWW::Selenium::ExtJS::Form::Field>.

=head3 C<xtype>

Type: C<Str>.

The XType of the Ext component, default is 'textfield'.

=head2 General methods

The methods of the base class are described at 
L<Test::WWW::Selenium::ExtJS::Form::Field>.

=head3 C<type_value>

Types the given text in the field after it is ready.

The typing is executed via seleniums type_ok method, it counts as test.


=head1 DIAGNOSTICS

Look at L<Test::WWW::Selenium::ExtJS::Form::Field>.


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
