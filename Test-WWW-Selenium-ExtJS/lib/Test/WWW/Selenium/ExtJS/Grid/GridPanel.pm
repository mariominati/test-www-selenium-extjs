package Test::WWW::Selenium::ExtJS::Grid::GridPanel;

use Moose;                                       # Includes strict and warnings

extends "Test::WWW::Selenium::ExtJS::Panel";

use Readonly;
Readonly my $TRUE       => 1;
Readonly my $FALSE      => 0;


# xtype - set the default xtype of this Ext component
has '+xtype' => (
    default => 'grid',
);


sub get_column_count {
    my $self = shift;

    my $header_xpath =
        $self->get_xpath() .
        "//div[\@class='x-grid3-header']" . 
        "//tr[\@class='x-grid3-hd-row']" .
        "/td";

    return $self->extjs->selenium->get_xpath_count( $header_xpath );
}


sub get_invisible_column_count {
    my $self = shift;

    my $xpath =
        $self->get_xpath() .
        "//div[\@class='x-grid3-header']" . 
        "//tr[\@class='x-grid3-hd-row']" .
        "/td[contains(\@style, 'display: none')]";

    return $self->extjs->selenium->get_xpath_count( $xpath );
}


sub get_visible_column_count {
    my $self = shift;

    return $self->get_column_count() - $self->get_invisible_column_count();
}


sub has_numberer_column {
    my $self = shift;

    my $xpath =
        $self->get_xpath() .
        "//div[\@class='x-grid3-header']" . 
        "//tr[\@class='x-grid3-hd-row']" .
        "/td[contains(\@class, 'x-grid3-td-numberer')]";
 
    return 
        $self->extjs->selenium->get_xpath_count( $xpath ) > 0 
        ? $TRUE
        : $FALSE;
}


sub get_column_title {
    my $self = shift;
    my $index = shift;                                    # index starts with 1

    my $xpath =
        $self->get_xpath() .
        "//div[contains(\@class, 'x-grid3-header')]" . 
        "//tr[\@class='x-grid3-hd-row']" .
        "/td[$index]" .
        "//div[contains(\@class, 'x-grid3-hd-inner')]";

    return $self->extjs->selenium->get_text( $xpath );
}


sub get_row_count {
    my $self = shift;

    my $xpath =
        $self->get_xpath() .
        "//div[contains(\@class, 'x-grid3-scroller')]" . 
        "//div[contains(\@class, 'x-grid3-row')]";

    return $self->extjs->selenium->get_xpath_count( $xpath );
}


sub is_checkbox_column {
    my $self = shift;
    my $index = shift;                                    # index starts with 1

    my $xpath =
        $self->get_xpath() .
        "//div[contains(\@class, 'x-grid3-scroller')]" . 
        "//div[contains(\@class, 'x-grid3-row-first')]" .
        "//td[$index]";

    # get class attribute and cancel if we could not get it
    my $attribute = $self->extjs->selenium->get_attribute( $xpath.'/@class' );
    return $FALSE
        if not defined $attribute;

    # check for checkbox specific class
    return 
        ($attribute =~ m/x-grid3-check-col-td/)
        ? $TRUE
        : $FALSE;
}


sub get_value {
    my $self = shift;
    my $row = shift;                                      # index starts with 1
    my $column = shift;                                   # index starts with 1

    my $xpath =
        $self->get_xpath() .
        "//div[contains(\@class, 'x-grid3-scroller')]" . 
        "//div[contains(\@class, 'x-grid3-row')][$row]" .
        "//td[$column]" .
        "//div[contains(\@class, 'x-grid3-cell-inner')]";

    return $self->extjs->selenium->get_text( $xpath );
}


sub get_checkbox_value {
    my $self = shift;
    my $row = shift;                                      # index starts with 1
    my $column = shift;                                   # index starts with 1

    my $xpath =
        $self->get_xpath() .
        "//div[contains(\@class, 'x-grid3-scroller')]" . 
        "//div[contains(\@class, 'x-grid3-row')][$row]" .
        "//td[$column]" .
        "//div[contains(\@class, 'x-grid3-cell-inner')]" .
        "/div";

    # get class attribute and cancel if we could not get it
    my $attribute = $self->extjs->selenium->get_attribute( $xpath.'/@class' );
    return
        if not defined $attribute;

    # check for checkbox specific class
    return 
        ($attribute =~ m/x-grid3-check-col-on/)
        ? $TRUE
        : $FALSE;
}


sub is_column_hidden {
    my $self = shift;
    my $index = shift;                                    # index starts with 1

    my $xpath =
        $self->get_xpath() .
        "//div[\@class='x-grid3-header']" . 
        "//tr[\@class='x-grid3-hd-row']" .
        "//td[$index]";
#         "/td[contains(\@style, 'display: none')]";

    # get style attribute and cancel if we could not get it
    my $attribute = $self->extjs->selenium->get_attribute( $xpath.'/@style' );
    return $FALSE
        if not defined $attribute;

    # check for hidden style
    return 
        ($attribute =~ m/display: none/)
        ? $TRUE
        : $FALSE;
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

=head3 C<get_title>

Returns the title of the window.


=head1 DIAGNOSTICS

Look at L<Test::WWW::Selenium::ExtJS::Panel>.


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
