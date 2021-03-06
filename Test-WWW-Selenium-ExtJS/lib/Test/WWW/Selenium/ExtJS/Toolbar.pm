package Test::WWW::Selenium::ExtJS::Toolbar;

use Moose;                                       # Includes strict and warnings

extends "Test::WWW::Selenium::ExtJS::Container";

use Readonly;
Readonly my $TRUE       => 1;
Readonly my $FALSE      => 0;


# xtype - set the default xtype of this Ext component
has '+xtype' => (
    default => 'toolbar',
);


# Build component from given parameters
sub BUILD {
    my ( $self, $params ) = @_;

    # This is just a base class, so we don't set an expression
    # Using this component directly means setting the expression string 
    # your self.
}


# Returns the number of item objects in this toolbar

sub get_eval_items_count {
    my $self = shift;

    return $self->get_eval_integer_property( "items.items.length" );
}


# Get the expressions for all buttongroups of this toolbar

sub get_eval_buttongroup_expressions {
    my $self = shift;

    # Expression to access the toolbar items array
    my $items_expression = $self->get_expression() . ".items.items";

    # Create javascript code for analysing toolbar items
    my $js = 
        "var bg = new Array();".
        "Ext.each( " . $items_expression . ", ". 
        "    function( item, index ) {".
        "        if (item.xtype && item.xtype == 'buttongroup') { ".
        "            bg.push( index ); ".
        "        } ".
        "    } ".
        "); ".
        "return bg; ";
 
    # Execute javascript code
    my $buttongroup_indexes = $self->extjs->get_pure_eval( $js );
# warn $buttongroup_indexes;

    # Convert indexes into expressiions
    my @buttongroups = 
        map { $items_expression . '[' . $_ . ']' }
        split( /,/, $buttongroup_indexes);
# use Data::Dumper;
# warn Dumper( \@buttongroups );

    return @buttongroups;
}


# Gets the expression for a specific buttongroup of the toolbar

sub get_eval_buttongroup_by_index_expression {
    my $self = shift;
    my ($index) = @_;

    my @buttongroups = $self->get_eval_buttongroup_expressions();

    return $buttongroups[ $index ];
}


1;  # Magic true value required at end of module
__END__


=head1 NAME

Test::WWW::Selenium::ExtJS::Toolbar - Proxy class for Ext.Toolbar


=head1 SYNOPSIS

Look at L<Test::WWW::Selenium::ExtJS>.
  
  
=head1 DESCRIPTION

This is the proxy class for the Ext.Toolbar object and extends the 
L<Test::WWW::Selenium::ExtJS::Container> object.
L<http://www.extjs.com/deploy/dev/docs/?class=Ext.Toolbar>

If this class is used by itself you have to specify the L<expression> attribute.


=head1 INTERFACE 

=head2 Attributes

The attributes of the base class are described at 
L<Test::WWW::Selenium::ExtJS::Container>.

=head3 C<xtype>

Type: C<Str>.

The XType of the Ext component, default is 'toolbar'.

=head2 General methods

The methods of the base class are described at 
L<Test::WWW::Selenium::ExtJS::Container>.

=head2 Convenience methods to evaluate properties

=head3 C<get_eval_items_count>

Returns the number of items in this toolbar.

=head3 C<get_eval_buttongroup_expressions>

Gets all expressions for the buttongroups of this toolbar as list.

=head3 C<get_eval_buttongroup_by_index_expression>

Gets the expression for the n-th buttongroup.


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
