package Test::WWW::Selenium::ExtJS;

use warnings;
use strict;
use version; our $VERSION = qv('0.0.1');

use Readonly;
Readonly my $TRUE       => 1;
Readonly my $FALSE      => 0;


use Moose;                                       # Includes strict and warnings


# selenium - Selenium proxy through which it can execute Selenese commands
has 'selenium' => (
    isa         => 'WWW::Selenium', 
    is          => 'ro', 
    predicate   => 'has_selenium',
    required    => 1
);

# js_preserve_window_objects - objects of the browsers window object that must
# be available for processing the test expressions
has 'js_preserve_window_objects' => (
    isa         => 'ArrayRef[Str]', 
    is          => 'ro', 
    default     => sub { [] },
);

# resize_window - the size of the browser window that we want it to resize to
has 'resize_window' => (
    isa         => 'ArrayRef[Int]', 
    is          => 'ro', 
    predicate   => 'has_resize_window',
);

# maximize_window - if set to true the browser window is being maximized
has 'maximize_window' => (
    isa         => 'Bool', 
    is          => 'ro', 
    default     => $FALSE,
);

# timeout - the timeout when waiting commands timeout and die
has 'timeout' => (
    isa         => 'Int', 
    is          => 'ro', 
    default     => 15000,
);

# looptime - the interval for rechecking waiting commands
has 'looptime' => (
    isa         => 'Int', 
    is          => 'ro', 
    default     => 500,
);


### Private attributes

# _js_preserve_window_objects_string - a store for the javascript string
# representing the windowobject that are available in test expressions
has '_js_preserve_window_objects_string' => (
    is          => 'ro',
    lazy_build  => 1,
    init_arg    => undef,
    builder     => '_js_preserve_window_objects_string_builder'
);


### Build component from given parameters

sub BUILD {
    my $self = shift;

    # Set window dimensions if given
    if ($self->has_resize_window) {
        $self->selenium->get_eval( 
            "window.moveTo(1,1); window.resizeTo(" .   # using 0,0 has problems
            join (',', @{$self->resize_window}) .      # on some browsers / os
            ");" 
        );
    }

    # maximize window
    elsif ( $self->maximize_window ) {
        $self->selenium->window_maximize;
    }
}


### Public methods

# Evaluates expressions and returns result.
sub get_eval {
    my $self = shift;
    my $expression = shift;

    # Build an anonymous sub around expression to move scope to current window
    # object instead of using the selenium object to run commands in.
    # Additionally we create a local varaible to access the Ext and other
    # objects. We must explicitly 'return' otherwise the anonymous sub will
    # always return null.

    my $anonymous_function =
        "(function (){ " . 
        $self->_js_preserve_window_objects_string .
        "return " . $expression .
        "}).call( this.page().currentWindow );";

    return $self->selenium->get_eval( $anonymous_function );
}


#   Methods to synchronise with AJAX

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

    die "Timed out waiting for JS code (wait_eval_true): '$expression'";
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
# warn 'wait_until_expression_resolves - expression / result: ' . $expression . "/" . $result;
        return $TRUE if not ($result eq 'null');

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
die $result;
        return if ($result eq 'null');

        # Wait before next check
        select(undef, undef, undef, ($self->looptime / 1000));
    }

    die "Timed out waiting for JS code (wait_until_expression_not_resolves): '$expression'";
}


### Private methods

# Build javascript preserve window objects string
sub _js_preserve_window_objects_string_builder {
    my $self = shift;

    my $javascript = "var Ext = this.Ext";
    map { $javascript .= ", $_ = this.$_" } @{$self->js_preserve_window_objects};
    $javascript .= ";";

    return $javascript;
}


1; # Magic true value required at end of module
__END__

=head1 NAME

Test::WWW::Selenium::ExtJS - Testing ExtJS powered gui with selenium


=head1 VERSION

This document describes C<Test::WWW::Selenium::ExtJS> version C<0.0.1>.


=head1 SYNOPSIS

    # Testing a catalyst based app that uses ExtJS
    use Test::WWW::Selenium::Catalyst 'MyApp', -selenium_args => "-multiWindow"; 

    use Test::WWW::Selenium::ExtJS;
    use Test::WWW::Selenium::ExtJS::Window;
    use Test::WWW::Selenium::ExtJS::Form::TextField;
    use Test::WWW::Selenium::ExtJS::Button;

    use Test::More;

    # Start catalyst app and load initial page
    my $selenium = Test::WWW::Selenium::Catalyst->start; 
    $selenium->open_ok ( 'http://localhost:3000/' );                   # Test 1

    # Prepare ExtJS proxies
    my $extjs = new Test::WWW::Selenium::ExtJS( 
        selenium                    => $selenium, 
        js_preserve_window_objects  => [qw( CustomMyApp swfobject )],
        resize_window               => [1000, 600],
    );

    # Test login window
    my $login = new Test::WWW::Selenium::Window( 
        extjs   => $extjs, 
        id      => 'login_window' 
    );
    is( $login->get_title, 
        'Please enter your login data', 
        'login window title' 
    );                                                                 # Test 2
    my $username = new Test::WWW::Selenium::ExtJS::Form::TextField( 
        parent  => $login, 
        name    => 'username' 
    )->type_value( 'me_or_you' );             # Test 3 - does selenium->type_ok
    my $password = new Test::WWW::Selenium::ExtJS::Form::TextField( 
        parent  => $login, 
        name    => 'password' 
    )->type_value( 's3cr37' );                # Test 4 - does selenium->type_ok
    my $login_button = new Test::WWW::Selenium::ExtJS::Button( 
        parent  => $login->get_footer_toolbar, 
        text    => 'Login' 
    )->click();                              # Test 5 - does selenium->click_ok

    # Mark end of tests
    done_testing();
  
  
=head1 DESCRIPTION

Automatic testing of an ExtJS based gui is made easy with this set of 
modules.

=head2 Concept

The concept is based on an article of Lindsay Kay 
(L<http://www.xeolabs.com/portal/articles/selenium-and-extjs>).
As ExtJS is using randomly generated ids in the DOM they will not persist
during working on you app. Using XPath expressions isn't also an option as
they change often during developmen. It would be a pain to keep the tests
up to date.
The solution was to use ExtJS related javascript expressions to get the 
ids of the ExtJS components that shall be tested by evaluating those
expressions through selenium. With that ids we can easily act on the 
specific components.
    
=head2 Implementation

To realize this concept we provide a proxy class for each ExtJS component.
We almost rebuild the complete ExtJS object tree to allow testing the gui
in a well known way.
Custom ExtJS components can be hold in custom proxy modules to abstract away
the inner parts of that component and just offer a simple interface for
testing.


=head1 INTERFACE 

=head2 Attributes

=head3 C<selenium>

Type: C<WWW::Selenium> object, B<required> attribute.

The selenium proxy object through which we can execute selenese commands.

=head3 C<js_preserve_window_objects>

Type: C<ArrayRef[Str]>.

Names of javascript objects of the browsers window object that must be 
available for processing the test expressions.

If you are using one of the Flash based ExtJS features you should include
the C<swfobject> to make these functions work:

    my $extjs = new Test::WWW::Selenium::ExtJS( 
        selenium                    => $selenium, 
        js_preserve_window_objects  => [qw( swfobject )],
    );

=head3 C<resize_window>

Type: C<ArrayRef[Int]>.

The size (width, height) of the browser window that we want it to resize to.

=head3 C<maximize_window>

Type: C<Bool>.

If set to true the browser window is being maximized.

If both C<resize_window> and C<maximize_window> are given, the window will be
only resized and B<not> maximized.

=head3 C<timeout>

Type: C<Int>, Default: C<15000>.

The timeout in milliseconds (thausends of a second) when waiting for commands 
to evaluate in a given way (be true, be null, be not null). After timeout the
commands die.

=head3 C<looptime>

Type: C<Int>, Default: C<500>.

The interval in milliseconds (thausends of a second) to wait befor retrying a 
waiting command.

=head2 General methods

=head3 C<get_eval>

Evaluates the given expression in the scope of the current window object and 
returns the result.

The expression is evaluated in an anonymous javascript function:
    (function (){
        Ext = this.Ext;
        return $expression
    }).call( this.page().currentWindow );

=head2 Methods to synchronise with AJAX

=head3 C<wait_eval_true>

Returns as soon as the expression evaluates true, else dies on timeout.

=head3 C<wait_until_expression_resolves>

Returns true as soon as expression evaluates, else false on timeout.

=head3 C<wait_until_expression_not_resolves>

Returns true as soon as expression fails to resolve, else dies on timeout.


=head1 DIAGNOSTICS

=over

=item C<< Timed out waiting for JS code (wait_eval_true): '%s' >>

This error happens when the given expression can not be evaluated in the given 
period of time. If the page is loading slowly you can try to increase the value
of the L<timeout> attribute.

=item C<< Timed out waiting for JS code (wait_until_expression_not_resolves): '%s' >>

This error happens when the given expression does not stop to resolve in the 
given period of time. You can try to increase the value of the L<timeout> 
attribute.

=back


=head1 CONFIGURATION AND ENVIRONMENT

Test::WWW::Selenium::ExtJS requires no configuration files or environment variables.


=head1 DEPENDENCIES

=head2 Configure time

=over

=item core modules

Perl 5.10

=item CPAN modules

L<Module::Build>

=back

=head2 Run time

=over

=item core modules

Perl 5.10

=item CPAN modules

L<Moose>

=back

=head1 INCOMPATIBILITIES

None reported.


=head1 BUGS AND LIMITATIONS

No bugs have been reported.

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
