package Test::WWW::Selenium::ExtJS::Layout::BorderLayout;

use Moose;                                       # Includes strict and warnings

# extends "Test::WWW::Selenium::ExtJS::Layout";

use Readonly;
Readonly my $TRUE   => 1;
Readonly my $FALSE  => 0;

# get items object where region == north 

1;  # Magic true value required at end of module
__END__


=head1 NAME

Test::WWW::Selenium::ExtJS::Layout::BorderLayout - Proxy class for Ext.layout.BorderLayout


=head1 SYNOPSIS

Look at L<Test::WWW::Selenium::ExtJS>.
  
  
=head1 DESCRIPTION

This is the proxy class for the Ext.layout.BorderLayout object and extends the 
L<Test::WWW::Selenium::ExtJS::Layout> object.
L<http://www.extjs.com/deploy/dev/docs/?class=Ext.layout.BorderLayout>


=head1 INTERFACE 


###
### rework from here
###


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

=head3 C<id>

Type: C<Str>.

Sets the id of the Ext component. This is usually used for windows, viewports
and other objects with fixed id.

If L<id> is not given, we need the L<expression> attribute.

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

=head3 C<wait_for_rendered>

Does a wait loop until the component is rendered.

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

