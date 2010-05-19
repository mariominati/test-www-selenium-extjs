package Test::WWW::Selenium::ExtJS::ux::GroupTabPanel;

use Moose;                                       # Includes strict and warnings

extends "Test::WWW::Selenium::ExtJS::TabPanel";

use Readonly;
Readonly my $TRUE       => 1;
Readonly my $FALSE      => 0;


# xtype - set the default xtype of this Ext component
has '+xtype' => (
    default => 'grouptabpanel',
);


# In GroupTabPanel each *group* has its own card, 
# Each group card contains another card layout for the tabs of the group.

# The GroupTabPanel consists of two elements: body and header, 
# The body contains the cards from CardLayout, 
# The header contains the labels.


# Returns the number of tab groups in this group panel

sub get_eval_groups_count {
    my $self = shift;

    # Get layout of the panel
    my $layout = $self->get_layout();

    # Get card count
    my $card_count = $layout->get_eval_cards_count();

    return $card_count;
}


# Returns the index of the active group

sub get_eval_active_group_index {
    my $self = shift;

    # Expression to access the grouptabpanel items array
    my $items_expression = $self->get_expression() . ".layout.container.items.items";
    my $activeGroup_expression = $self->get_expression() . ".activeGroup";

    # Create javascript code for analysing grouptabpanel items
    my $js = 
        "var retVal = -1, activeGroup = $activeGroup_expression;".
        "Ext.each( " . $items_expression . ", ". 
        "    function( item, index ) {".
        "        if (item == activeGroup) { ".
        "            retVal = index; ".
        "        } ".
        "    } ".
        "); ".
        "return retVal; ";
# warn $js;
 
    # Execute javascript code
    my $active_group = $self->extjs->get_pure_eval( $js );

    return $active_group;
}


# Returns the name of the given group

sub get_eval_groupname_by_index {
    my $self = shift;
    my $index = shift;

    return $self->get_eval_string_property(
        "layout.container.items.items[" . $index . "].groupName"
    );
}


# Returns the index for the given group name

sub get_eval_group_index_by_name {
    my $self = shift;
    my $name = shift;

    # Expression to access the grouptabpanel items array
    my $items_expression = $self->get_expression() . ".layout.container.items.items";

    # Create javascript code for analysing toolbar items
    my $js = 
        "var retVal = -1;".
        "Ext.each( " . $items_expression . ", ". 
        "    function( item, index ) {".
        "        if (item.groupName == '$name') { ".
        "            retVal = index; ".
        "        } ".
        "    } ".
        "); ".
        "return retVal; ";
# warn $js;
 
    # Execute javascript code
    my $group_index = $self->extjs->get_pure_eval( $js );
# warn $group_index;

    return $group_index;
}


# Returns true if a group with the given name exists

sub get_eval_group_exists {
    my $self = shift;
    my $name = shift;

    my $index = $self->get_eval_group_index_by_name( $name );

    return ($index == -1) ? $FALSE : $TRUE;
}


# Returns true if a group with the given name is the active group

sub get_eval_group_is_active {
    my $self = shift;
    my $name = shift;

    my $index = $self->get_eval_group_index_by_name( $name );
    my $active = $self->get_eval_active_group_index();

    return ($index != -1 && $index == $active) ? $TRUE : $FALSE;
}


# Returns the number of tabs in the given group

sub get_eval_tab_count_for_group {
    my $self = shift;
    my $id = shift;

    # Get group index if a groupname is given
    if ($id !~ /^[+-]?\d+$/) {
        $id = $self->get_eval_group_index_by_name( $id );
    }

    # Build group expression
    my $group_expression = 
        $self->get_expression() . 
        ".layout.container.items.items[" . $id . "]";

    # Get tab count for group
    my $tab_count = $self->get_eval_integer_property( 
        "layout.container.items.items[" . $id . "]" .
        ".items.items.length" 
    );
# warn $tab_count;
    return $tab_count;
}


# Gets the index of a tab in a given group. The tab is defined by it's title.

sub get_eval_tab_title_index_for_group {
    my $self = shift;
    my $title = shift;
    my $group = shift;

    # Get group index if a groupname is given
    if ($group !~ /^[+-]?\d+$/) {
        $group = $self->get_eval_group_index_by_name( $group );
    }

    # Expression to access the grouptabpanel items array
    my $tab_items_expression = 
        $self->get_expression() . 
        ".layout.container.items.items[" . $group . "]" .
        ".items.items";

    # Create javascript code for analysing toolbar items
    my $js = 
        "var retVal = -1;".
        "Ext.each( " . $tab_items_expression . ", ". 
        "    function( item, index ) {".
        "        if (item.title == '$title') { ".
        "            retVal = index; ".
        "        } ".
        "    } ".
        "); ".
        "return retVal; ";
# warn $js;
 
    # Execute javascript code
    my $tab_index = $self->extjs->get_pure_eval( $js );
# warn $tab_index;

    return $tab_index;
}


# Checks if a tab, defined by a given title, exists in a given group.

sub get_eval_tab_title_exists_for_group {
    my $self = shift;
    my $title = shift;
    my $group = shift;

    my $index = $self->get_eval_tab_title_index_for_group( $title, $group );

    return ($index == -1) ? $FALSE : $TRUE;
}


# Returns an XPath to the header of the tab. The header is placed in a separate 
# div of the grouptabpanel, so we need to write a special access method.

sub get_eval_tab_header_xpath_by_tab_and_group {
    my $self = shift;
    my $tab_id = shift;
    my $group_id = shift;

    # Get group index if a groupname is given
    if ($group_id !~ /^[+-]?\d+$/) {
        $group_id = $self->get_eval_group_index_by_name( $group_id );
    }

    my $tab_item_expression = 
        $self->get_expression() . 
        ".layout.container.items.items[" . $group_id . "]" .
        ".items.items[" . $tab_id . "]";

    my $html_id = 
        $self->extjs->get_eval( $tab_item_expression . ".tabEl.id" );
# warn $html_id;

    return 
        "//*[\@id='" . $html_id . "']";
}


# Get the tab title

sub get_tab_title_by_tab_and_group {
    my $self = shift;
    my $tab_id = shift;
    my $group_id = shift;

#     $self->wait_for_component_rendered;

    # Get xpath
    my $xpath = 
        $self->get_eval_tab_header_xpath_by_tab_and_group( $tab_id, $group_id );

    # Get HTML content
    return $self->extjs->selenium->get_text ( 
        $xpath . 
        "//a[contains(\@class, 'x-grouptabs-text')]" 
    );
}


# Returns the expression to access a tab panel object.

sub get_tab_panel_expression_by_tab_and_group {
    my $self = shift;
    my $tab_id = shift;
    my $group_id = shift;

    # Get group index if a groupname is given
    if ($group_id !~ /^[+-]?\d+$/) {
        $group_id = $self->get_eval_group_index_by_name( $group_id );
    }

    my $tab_expression = 
        $self->get_expression() . 
        ".layout.container.items.items[" . $group_id . "]" .
        ".items.items[" . $tab_id . "]";
# warn $tab_expression;

    return $tab_expression;
}


1;  # Magic true value required at end of module
__END__


=head1 NAME

Test::WWW::Selenium::ExtJS::Window - Proxy class for Ext.Window


=head1 SYNOPSIS

Look at L<Test::WWW::Selenium::ExtJS>.
  
  
=head1 DESCRIPTION

This is the proxy class for the Ext.Window object and extends the 
L<Test::WWW::Selenium::ExtJS::Panel> object.
L<http://www.extjs.com/deploy/dev/docs/?class=Ext.Window>


=head1 INTERFACE 

=head2 Attributes

The attributes of the base class are described at 
L<Test::WWW::Selenium::ExtJS::Panel>.

=head3 C<xtype>

Type: C<Str>.

The XType of the Ext component, default is 'window'.

=head2 General methods

The methods of the base class are described at 
L<Test::WWW::Selenium::ExtJS::Panel>.

=head3 C<get_eval_groups_count>

Returns the number of tab groups in this group panel.

=head3 C<get_eval_active_group_index>

Returns the index of the active group, starting by 0.

=head3 C<get_eval_groupname_by_index>

Returns the name of the given group.

=head3 C<get_eval_group_index_by_name>

Returns the index for the given group name.

=head3 C<get_eval_group_exists>

Returns true if a group with the given name exists.

=head3 C<get_eval_group_is_active>

Returns true if a group with the given name is the active group.

=head3 C<get_eval_tab_count_for_group>

Returns the number of tabs in the given group.
The function expects the index or name of the group.

=head3 C<get_eval_tab_title_index_for_group>

Gets the index of a tab in a given group. The tab is defined by it's title.

=head3 C<get_eval_tab_title_exists_for_group>

Checks if a tab, defined by a given title, exists in a given group.

=head3 C<get_eval_tab_header_xpath_by_tab_and_group>

Returns an XPath to the header of the tab.

=head3 C<get_tab_title_by_tab_and_group>

Get the tab title.

=head3 C<get_tab_panel_expression_by_tab_and_group>

Returns the expression to access a tab panel object.


=head1 DIAGNOSTICS

The errors of the base class are described at 
L<Test::WWW::Selenium::ExtJS::TabPanel>.


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
