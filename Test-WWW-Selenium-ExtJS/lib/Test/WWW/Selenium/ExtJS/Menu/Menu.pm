package Test::WWW::Selenium::ExtJS::Menu::Menu;

use Moose;                                       # Includes strict and warnings

extends "Test::WWW::Selenium::ExtJS::Container";

use Readonly;
Readonly my $TRUE       => 1;
Readonly my $FALSE      => 0;


# xtype - set the default xtype of this Ext component
has '+xtype' => (
    default => 'menu',
);


# Returns the number of shown menu item (lines are counted)
sub count_menu_baseitems {
    my $self = shift;

    my $xpath =
        $self->get_xpath() .
        "//ul[contains(\@class, 'x-menu-list')]" . 
        "/li[contains(\@class, 'x-menu-list-item')]";

    return $self->extjs->selenium->get_xpath_count( $xpath );
}


# Returns the number of separator lines
sub count_menu_separator_lines {
    my $self = shift;

    my $xpath =
        $self->get_xpath() .
        "//ul[contains(\@class, 'x-menu-list')]" . 
        "/li[contains(\@class, 'x-menu-sep-li')]";

    return $self->extjs->selenium->get_xpath_count( $xpath );
}


# Returns the number of disabled items
sub count_menu_disabled_items {
    my $self = shift;

    my $xpath =
        $self->get_xpath() .
        "//ul[contains(\@class, 'x-menu-list')]" . 
        "/li[contains(\@class, 'x-item-disabled')]";

    return $self->extjs->selenium->get_xpath_count( $xpath );
}


# Returns the number of submenu items
sub count_menu_submenu_items {
    my $self = shift;

    my $xpath =
        $self->get_xpath() .
        "//ul[contains(\@class, 'x-menu-list')]" . 
        "/li[contains(\@class, 'x-menu-list-item')]" .
        "/a[contains(\@class, 'x-menu-item-arrow')]";

    return $self->extjs->selenium->get_xpath_count( $xpath );
}


# Hides the menu
sub hide {
    my $self = shift;

    return $self->get_eval( ".hide();" );
}


sub mouseover_item {
    my $self = shift;
    my $item_text = shift;

    my $xpath =
        $self->get_xpath() .
        "//ul[contains(\@class, 'x-menu-list')]" . 
        "/li[contains(\@class, 'x-menu-list-item')]" .
        "//span[contains(text(), '$item_text')]";


    # Perform the mouseover on the item
    $self->extjs->selenium->mouse_over_ok( $xpath );

    return $self;
}


sub click_item {
    my $self = shift;
    my $item_text = shift;

    my $xpath =
        $self->get_xpath() .
        "//ul[contains(\@class, 'x-menu-list')]" . 
        "/li[contains(\@class, 'x-menu-list-item')]" .
        "//span[contains(text(), '$item_text')]";

    # Perform the click on the item
    $self->extjs->selenium->click_ok( $xpath );

    return $self;
}


sub mouseover_click_item {
    my $self = shift;
    my $item_text = shift;

    $self->mouseover_item( $item_text );
    $self->click_item( $item_text );

    return $self;
}


sub open_submenu {
    my $self = shift;
    my $menu_text = shift;

    # Open (show) sub menu by mouse overing it
    $self->mouseover_item( $menu_text );

    # Get the id of the menu item object
    my $xpath =
        $self->get_xpath() .
        "//ul[contains(\@class, 'x-menu-list')]" . 
        "/li[contains(\@class, 'x-menu-list-item')]" .
        "//span[contains(text(), '$menu_text')]" .
        "/..";
    my $id = $self->extjs->selenium->get_attribute( $xpath.'/@id' );

    # Create a new menu object for the submenu
    my $sub_menu = new Test::WWW::Selenium::ExtJS::Menu::Menu( 
        extjs       => $self->extjs, 
        expression  => "Ext.getCmp('" . $id . "').menu" 
    );

    return $sub_menu;
}


1;  # Magic true value required at end of module
__END__


=head1 NAME

Test::WWW::Selenium::ExtJS::Menu::Menu - Proxy class for Ext.menu.Menu


=head1 SYNOPSIS

Look at L<Test::WWW::Selenium::ExtJS>.
  
  
=head1 DESCRIPTION

This is the proxy class for the Ext.menu.Menu object and extends the 
L<Test::WWW::Selenium::ExtJS::Container> object.
L<http://www.extjs.com/deploy/dev/docs/?class=Ext.Container>


=head1 INTERFACE 

=head2 Attributes

The attributes of the base class are described at 
L<Test::WWW::Selenium::ExtJS::Container>.

=head3 C<xtype>

Type: C<Str>.

The XType of the Ext component, default is 'menu'.

=head2 General methods

The methods of the base class are described at 
L<Test::WWW::Selenium::ExtJS::Container>.

=head3 C<hide>

Hides the menu.

=head2 Convenience methods to evaluate properties

=head3 C<count_menu_baseitems>

Returns the number of shown menu item.
Separation lines are counted, too,

=head3 C<count_menu_separator_lines>

Returns the number of separator lines. 

=head3 C<count_menu_disabled_items>

Returns the number of disabled items. 

=head3 C<count_menu_submenu_items>

Returns the number of submenu items.


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
