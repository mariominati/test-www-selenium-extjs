package Test::WWW::Selenium::ExtJS::Container;

use Moose;                                       # Includes strict and warnings

extends "Test::WWW::Selenium::ExtJS::BoxComponent";

use Readonly;
Readonly my $TRUE   => 1;
Readonly my $FALSE  => 0;

# map layout names to proxy class names
Readonly my $LAYOUT_PROXIES => {
    card    =>  'CardLayout',
    anchor  =>  'AnchorLayout',
    border  =>  'BorderLayout',
    box     =>  'BoxLayout', 
    column  =>  'ColumnLayout', 
    fit     =>  'FitLayout', 
    menu    =>  'MenuLayout', 
    table   =>  'TableLayout', 
    toolbar =>  'ToolbarLayout',
};


# xtype - set the default xtype of this Ext component
has '+xtype' => (
    default => 'container',
);

# layout - stores the layout object of this component
has 'layout' => (
    isa         => 'Str',
    is          => 'rw', 
);

# get items object where region == north 

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

    # convert layout name into proxy class name
    my $layout_proxy_name = $LAYOUT_PROXIES->{ lc ($layout) };
    die "layout has not been defined"
        if not $layout_proxy_name;
    my $layout_proxy_classname = 
        "Test::WWW::Selenium::ExtJS::Layout::" . $layout_proxy_name;

    # load proxy class
    require $layout_proxy_classname; 
    
    # create and return layout object
    my $layout_object = $layout_proxy_classname->new( parent => $self );
    return $layout_object;
}


# autodetect layout
sub _autodetect_layout {
    my $self = shift;

    # wait until container is ready
    $self->wait_for_component->wait_for_rendered;

    # get expression to access this container
    my $objectExpression = $self->get_expression;

    # build javascript code to find out the type of layout from known layouts
    my $layoutExpression =
        "(function (){" .
            $self->extjs->_js_preserve_window_objects_string .
            "var layout = $objectExpression.getLayout();";
    foreach my $key (keys %$LAYOUT_PROXIES) {
        $layoutExpression .= "
            if (layout instanceof Ext.layout." . $LAYOUT_PROXIES->{ $key } . ") { return '" . $key . "'; }";
    }
    $layoutExpression .= "
            return 'auto'; 
        }).call( this.page().currentWindow );";

    # get name of layout
    my $result = $self->extjs->selenium->get_eval( $layoutExpression );
    return $result;
}


1;  # Magic true value required at end of module
__END__
