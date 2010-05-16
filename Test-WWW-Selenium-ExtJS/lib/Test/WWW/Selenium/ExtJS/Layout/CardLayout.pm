package Test::WWW::Selenium::ExtJS::Layout::CardLayout;

use Moose;                                       # Includes strict and warnings

extends "Test::WWW::Selenium::ExtJS::Layout";

use Readonly;
Readonly my $TRUE   => 1;
Readonly my $FALSE  => 0;


sub get_eval_cards_count{
    my $self = shift;

    return $self->get_eval_integer_property( "layout.container.items.items.length" );
}


sub get_eval_active_index {
    my $self = shift;

    # Expression to access the toolbar items array
    my $items_expression = $self->get_expression() . ".layout.container.items.items";
    my $activeItem_expression = $self->get_expression() . ".layout.activeItem";

    # Create javascript code for analysing toolbar items
    my $js = 
        "var retVal = -1, activeItem = $activeItem_expression;".
        "Ext.each( " . $items_expression . ", ". 
        "    function( item, index ) {".
        "        if (item == activeItem) { ".
        "            retVal = index; ".
        "        } ".
        "    } ".
        "); ".
        "return retVal; ";
# warn $js;
 
    # Execute javascript code
    my $active_index = $self->extjs->get_pure_eval( $js );

    return $active_index;
}


sub get_card_expression_by_index {
    my $self = shift;
    my $index = shift;

    return $self->get_expression() . ".layout.container.items.items[" . $index . "]";
}


1;  # Magic true value required at end of module
__END__


=head1 NAME

Test::WWW::Selenium::ExtJS::Layout::CardLayout - Proxy class for Ext.layout.CardLayout


=head1 SYNOPSIS

Look at L<Test::WWW::Selenium::ExtJS>.
  
  
=head1 DESCRIPTION

This is the proxy class for the Ext.layout.CardLayout object and extends the 
L<Test::WWW::Selenium::ExtJS::Layout> object.
L<http://www.extjs.com/deploy/dev/docs/?class=Ext.layout.CardLayout>


=head1 INTERFACE 

The attributes of the base class are described at 
L<Test::WWW::Selenium::ExtJS::Expression>.


=head2 General methods

The methods of the base class are described at 
L<Test::WWW::Selenium::ExtJS::Expression>.


=head3 C<get_eval_cards_count>

Returns the number of cards of this layout. 

=head3 C<get_eval_active_index>

Returns the index of the current active layout card, counting starts by 0. 

=head3 C<get_card_expression_by_index>

Returns the expression to access the component/panel of the card layout given 
by index, counting starts by 0. 


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

