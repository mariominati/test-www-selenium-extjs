package Test::WWW::Selenium::ExtJS::Container;

use Moose;                                       # Includes strict and warnings

extends "Test::WWW::Selenium::ExtJS::BoxComponent";

use Carp qw/ croak /;

use Readonly;
Readonly my $TRUE   => 1;
Readonly my $FALSE  => 0;

# map layout names to proxy class names
# Be aware of the order of this list. We must define the most specific classes
# first as the parent classes will fullfill the instanceof check for it's 
# derived classes too.
Readonly my $LAYOUT_PROXIES => [
    { card    =>  'CardLayout' },
    { anchor  =>  'AnchorLayout' },
    { border  =>  'BorderLayout' },
    { box     =>  'BoxLayout' }, 
    { column  =>  'ColumnLayout' }, 
    { fit     =>  'FitLayout' }, 
    { menu    =>  'MenuLayout' }, 
    { table   =>  'TableLayout' }, 
    { toolbar =>  'ToolbarLayout' },
];


# xtype - set the default xtype of this Ext component
has '+xtype' => (
    default => 'container',
);

# layout - stores the layout object of this component
has 'layout' => (
    isa         => 'Str',
    is          => 'rw', 
);

# returns the name of the layout
sub get_layoutname {
    my $self = shift;

    # get the predefined layout name
    my $layout = $self->layout;

    # autodetect layout if not given
    $layout = $self->_autodetect_layout
        if not (defined $layout && length $layout);

    return $layout;
}


# returns the layout proxy object
sub get_layout {
    my $self = shift;

    # get the layout name
    my $layout = $self->get_layoutname();

    # autodetect layout if not given
    $layout = $self->_autodetect_layout
        if not (defined $layout && length $layout);

    # get proxy class name from layout name
    my ($layout_proxy_name) = 
        map { (values %$_)[0] } 
        grep { (keys %$_)[0] eq lc ($layout) } 
        @$LAYOUT_PROXIES;
    $layout_proxy_name = 'Auto'
        if ('auto' eq lc ($layout));
    die "layout has not been defined"
        if not $layout_proxy_name;
    my $layout_proxy_classname = 
        "Test::WWW::Selenium::ExtJS::Layout::" . $layout_proxy_name;

    # load proxy class
    require_class( $layout_proxy_classname );
    
    # create and return layout object
    my $layout_object = $layout_proxy_classname->new( parent => $self );
    return $layout_object;
}


# autodetect layout
sub _autodetect_layout {
    my $self = shift;

    # wait until container is ready
    $self->wait_for_component_rendered;

    # get expression to access this container
    my $objectExpression = $self->get_expression;

    # build javascript code to find out the type of layout from known layouts
    my $layoutExpression =
        "(function (){" .
            $self->extjs->_js_preserve_window_objects_string .
            "var layout = $objectExpression.getLayout();";
    foreach my $pair (@$LAYOUT_PROXIES) {
        my ($key, $value) = ((keys %$pair)[0], (values %$pair)[0]);
        $layoutExpression .= "
            if (layout instanceof Ext.layout." . $value . ") { return '" . $key . "'; }";
    }
    $layoutExpression .= "
            return 'auto'; 
        }).call( this.page().currentWindow );";

    # get name of layout
    my $result = $self->extjs->selenium->get_eval( $layoutExpression );
# warn $result;
    return $result;
}


sub require_class {
    my ($class) = @_;

    croak "class argument missing" if !defined $class;

    $class =~ s|::|/|g;
    $class .= ".pm";

    if ( !exists $::INC{$class} ) {
        eval { require $class };
        croak $@ if $@;
    }

    return;
}




1;  # Magic true value required at end of module
__END__


=head1 NAME

Test::WWW::Selenium::ExtJS::Container - Proxy class for Ext.Container


=head1 SYNOPSIS

Look at L<Test::WWW::Selenium::ExtJS>.
  
  
=head1 DESCRIPTION

This is the proxy class for the Ext.Container object and extends the 
L<Test::WWW::Selenium::ExtJS::BoxComponent> object.
L<http://www.extjs.com/deploy/dev/docs/?class=Ext.Container>


=head1 INTERFACE 

=head2 Attributes

The attributes of the base class are described at 
L<Test::WWW::Selenium::ExtJS::BoxComponent>.

=head3 C<xtype>

Type: C<Str>.

The XType of the Ext component, default is 'container'.

=head3 C<layout>

Type: C<Str>.

Stores the name of the layout of this container.

=head2 General methods

The methods of the base class are described at 
L<Test::WWW::Selenium::ExtJS::BoxComponent>.

=head3 C<get_layoutname>

Returns the name of the layout, if the attribute L<layout> has not been set,
we try to autodetect the layout. 

=head3 C<get_layout>

Returns the layout proxy object.


=head1 DIAGNOSTICS

Look at L<Test::WWW::Selenium::ExtJS::BoxComponent>.

=over

=item C<< layout has not been defined >>

The layout could not be autodetected. This indicates that either the given 
layout name is not known to this module or the layout name could not be 
retrieved by layout autodetection.

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
