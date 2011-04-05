package Mason::Plugin::RouterSimple::Interp;
use Mason::PluginRole;
use Mason::Util qw(uniq);
use Router::Simple;

after 'modify_loaded_class' => sub {
    my ( $self, $compc ) = @_;

    if ( my $router_object = $compc->router_object ) {
        my $routes = $router_object->{routes};
        my @attrs = uniq( map { @{ $_->{capture} } } @$routes );
        for (@attrs) { s/__splat__/splat/ }
        my $meta = $compc->meta;
        foreach my $attr (@attrs) {
            unless ( $meta->has_attribute($attr) ) {
                $meta->add_attribute( $attr => () );
            }
        }
    }
};

1;
