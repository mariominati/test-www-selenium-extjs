package Test::WWW::Selenium::ExtJS;

use warnings;
use strict;
use version; our $VERSION = qv('0.0.3');

use Readonly;
Readonly my $TRUE       => 1;
Readonly my $FALSE      => 0;


use Moose;                                       # Includes strict and warnings

use Test::WWW::Selenium::ExtJS::Window;


# selenium - Selenium proxy through which it can fire Selenese commands
has 'selenium' => (
    isa         => 'WWW::Selenium', 
    is          => 'ro', 
    predicate   => 'has_selenium',
    required    => 1
);

has 'js_preserve_window_objects' => (
    isa         => 'ArrayRef[Str]', 
    is          => 'ro', 
    default     => sub { [] },
);

# has 'resize_window' => (
#     isa         => 'ArrayRef[Int]', 
#     is          => 'ro', 
#     predicate   => 'has_resize_window',
# );

has 'timeout' => (
    isa         => 'Int', 
    is          => 'ro', 
    default     => 15000,
);

has 'looptime' => (
    isa         => 'Int', 
    is          => 'ro', 
    default     => 500,
);

# Private attributes

has '_js_preserve_window_objects_string' => (
    is          => 'ro',
    lazy_build  => 1,
    init_arg    => undef,
    builder     => '_js_preserve_window_objects_string_builder'
);


# Build component from given parameters
sub BUILD {
    my $self = shift;

# Disabled as it doesn't work at all - mm 03.01.2010
#     # Set window dimensions if given
#     if ($self->has_resize_window) {
#         $self->selenium->get_eval( 
#             "window.moveTo(0,0); window.resizeTo(" . 
#             join (',', @{$self->resize_window}) . 
#             "); selenium.windowMaximize();" 
#         );
#     }
}


# Build javascript preserve window objects string
sub _js_preserve_window_objects_string_builder {
    my $self = shift;

    my $javascript = "var Ext = this.Ext";
    map { $javascript .= ", $_ = this.$_" } @{$self->js_preserve_window_objects};
    $javascript .= ";";

    return $javascript;
}


# Evaluates expressions and returns result.

sub get_eval {
    my $self = shift;
    my $expression = shift;

    # Build a closure around expression to move scope to current window object
    # instead of using the selenium object to run commands in. Additionally we
    # create a local varaible to access the Ext object.

    my $anonymous_function =
        "(function (){ " . 
        $self->_js_preserve_window_objects_string .
        "return " . $expression .
        "}).call( window );";

#     return $self->selenium->get_eval( $expression );

    my $result = $self->selenium->get_eval( $anonymous_function );
# warn "evaluating anonymous_function: ".$anonymous_function . "returns: ". $result;
    return $result;
}

###
###   Methods to synchronise with AJAX
###


# Returns as soon as the generic expression evals true, else throws exception
# on timeout.
# This method is based this article: http://www.perlmonks.org/?node_id=720018

sub wait_eval_true {
    my $self = shift;
    my ($expression, $timeout) = @_;

    $timeout ||= $self->timeout;                   # Fall back on default value

    # Initiate timeout loop
    for (1 .. $timeout / $self->looptime) {

        # Run expression and check result
        my $result = $self->get_eval( $expression );
        return if $result eq 'true';

        # Wait before next check
        select(undef, undef, undef, ($self->looptime / 1000));
    }

    die "Timed out waiting for JS code: '$expression'";
}




# Returns true as soon as expression evaluates, else false on timeout.

sub wait_until_expression_resolves {
    my $self = shift;
    my ($expression, $timeout) = @_;

    $timeout ||= $self->timeout;                   # Fall back on default value

    # Initiate timeout loop
    for (1 .. $timeout / $self->looptime) {

        # Run expression and check result
        my $result = $self->get_eval( $expression );
# TODO - check if the expression resolves or if it failed
warn $result;
        return $TRUE if $result;

        # Wait before next check
        select(undef, undef, undef, ($self->looptime / 1000));
    }

    return $FALSE;
}


# Returns true as soon as expression fails to resolve, else timeout exception

sub wait_until_expression_not_resolves {
    my $self = shift;
    my ($expression, $timeout) = @_;

    $timeout ||= $self->timeout;                   # Fall back on default value

    # Initiate timeout loop
    for (1 .. $timeout / $self->looptime) {

        # Run expression and check result
        my $result = $self->get_eval( $expression );
# TODO - check if the expression resolves or if it failed
warn $result;
        return if not $result;

        # Wait before next check
        select(undef, undef, undef, ($self->looptime / 1000));
    }

    die "Timed out waiting for JS code: '$expression'";
}


sub get_window {
    my $self = shift;
    my ($id) = @_;

    my $window = new Test::WWW::Selenium::ExtJS::Window( 
        extjs    => $self,
        id       => $id
    );
}

1; # Magic true value required at end of module
__END__

=head1 NAME

Test::WWW::Selenium::ExtJS - [One line description of module's purpose here]


=head1 VERSION

This document describes Test::WWW::Selenium::ExtJS version 0.0.1


=head1 SYNOPSIS

    use Test::WWW::Selenium::ExtJS;

=for author to fill in:
    Brief code example(s) here showing commonest usage(s).
    This section will be as far as many users bother reading
    so make it as educational and exeplary as possible.
  
  
=head1 DESCRIPTION

=for author to fill in:
    Write a full description of the module and its features here.
    Use subsections (=head2, =head3) as appropriate.


=head1 INTERFACE 

=for author to fill in:
    Write a separate section listing the public components of the modules
    interface. These normally consist of either subroutines that may be
    exported, or methods that may be called on objects belonging to the
    classes provided by the module.


=head1 DIAGNOSTICS

=for author to fill in:
    List every single error and warning message that the module can
    generate (even the ones that will "never happen"), with a full
    explanation of each problem, one or more likely causes, and any
    suggested remedies.

=over

=item C<< Error message here, perhaps with %s placeholders >>

[Description of error here]

=item C<< Another error message here >>

[Description of error here]

[Et cetera, et cetera]

=back


=head1 CONFIGURATION AND ENVIRONMENT

=for author to fill in:
    A full explanation of any configuration system(s) used by the
    module, including the names and locations of any configuration
    files, and the meaning of any environment variables or properties
    that can be set. These descriptions must also include details of any
    configuration language used.
  
Test::WWW::Selenium::ExtJS requires no configuration files or environment variables.


=head1 DEPENDENCIES

=for author to fill in:
    A list of all the other modules that this module relies upon,
    including any restrictions on versions, and an indication whether
    the module is part of the standard Perl distribution, part of the
    module's distribution, or must be installed separately. ]

None.


=head1 INCOMPATIBILITIES

=for author to fill in:
    A list of any modules that this module cannot be used in conjunction
    with. This may be due to name conflicts in the interface, or
    competition for system or program resources, or due to internal
    limitations of Perl (for example, many modules that use source code
    filters are mutually incompatible).

None reported.


=head1 BUGS AND LIMITATIONS

=for author to fill in:
    A list of known problems with the module, together with some
    indication Whether they are likely to be fixed in an upcoming
    release. Also a list of restrictions on the features the module
    does provide: data types that cannot be handled, performance issues
    and the circumstances in which they may arise, practical
    limitations on the size of data sets, special cases that are not
    (yet) handled, etc.

No bugs have been reported.

Please report any bugs or feature requests to
C<bug-test-www-selenium-extjs@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.


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
