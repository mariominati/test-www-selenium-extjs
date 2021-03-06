package Test::WWW::Selenium::ExtJS::Panel;

use Test::WWW::Selenium::ExtJS::Panel::TopToolbar;
use Test::WWW::Selenium::ExtJS::Panel::BottomToolbar;
use Test::WWW::Selenium::ExtJS::Panel::FooterToolbar;

use Moose;                                       # Includes strict and warnings

extends "Test::WWW::Selenium::ExtJS::Container";

use Readonly;
Readonly my $TRUE       => 1;
Readonly my $FALSE      => 0;


# xtype - set the default xtype of this Ext component
has '+xtype' => (
    default => 'panel',
);


# Returns the toolbar object for the top toolbar
sub get_top_toolbar {
    my $self = shift;

    return new Test::WWW::Selenium::ExtJS::Panel::TopToolbar( parent => $self );
}

# Returns the toolbar object for the bottom toolbar
sub get_bottom_toolbar {
    my $self = shift;

    return new Test::WWW::Selenium::ExtJS::Panel::BottomToolbar( parent => $self );
}

# Returns the toolbar object for the footer toolbar
sub get_footer_toolbar {
    my $self = shift;

    return new Test::WWW::Selenium::ExtJS::Panel::FooterToolbar( parent => $self );
}

# Returns the number of item objects in this panel

sub get_eval_items_count {
    my $self = shift;

    return $self->get_eval_integer_property( "items.items.length" );
}

# Gets the expression for a specific item of the panel

sub get_item_by_index_expression {
    my $self = shift;
    my ($index) = @_;

    return $self->get_expression . ".items.items[$index]";
}


1;  # Magic true value required at end of module
__END__


=head1 NAME

Test::WWW::Selenium::ExtJS::Panel - Proxy class for Ext.Panel


=head1 SYNOPSIS

Look at L<Test::WWW::Selenium::ExtJS>.
  
  
=head1 DESCRIPTION

This is the proxy class for the Ext.Panel object and extends the 
L<Test::WWW::Selenium::ExtJS::Container> object.
L<http://www.extjs.com/deploy/dev/docs/?class=Ext.Container>


=head1 INTERFACE 

=head2 Attributes

The attributes of the base class are described at 
L<Test::WWW::Selenium::ExtJS::Container>.

=head3 C<xtype>

Type: C<Str>.

The XType of the Ext component, default is 'panel'.

=head2 General methods

The methods of the base class are described at 
L<Test::WWW::Selenium::ExtJS::Container>.

=head3 C<get_top_toolbar>

Returns the toolbar object for the top toolbar. 

=head3 C<get_bottom_toolbar>

Returns the toolbar object for the bottom toolbar. 

=head3 C<get_footer_toolbar>

Returns the toolbar object for the footer toolbar. 

=head2 Convenience methods to evaluate properties

=head3 C<get_eval_items_count>

Returns the number of items in this panel.

=head3 C<get_item_by_index_expression>

Gets the expression for the n-th item of this panel.


=head1 DIAGNOSTICS

Look at L<Test::WWW::Selenium::ExtJS::Container>.


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
