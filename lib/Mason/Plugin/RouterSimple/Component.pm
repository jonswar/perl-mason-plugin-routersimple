package Mason::Plugin::RouterSimple::Component;
use Mason::PluginRole;
use Router::Simple;

my %router_objects;

has 'router_result' => ();

method allow_path_info ($class:) {
    return $class->router_object ? 1 : $class->SUPER::allow_path_info();
}

method router_add ($class: $pattern, $dest) {
    $dest ||= {};
    unless ( $class->router_object ) {
        $class->router_object( $class->router_create_object() );
    }
    $class->router_object->connect( $pattern, $dest );
}

method router_create_object ($class:) {
    return Router::Simple->new();
}

method router_object ($class: $object) {
    $router_objects{$class} = $object if ( defined($object) );
    return $router_objects{$class};
}

1;
