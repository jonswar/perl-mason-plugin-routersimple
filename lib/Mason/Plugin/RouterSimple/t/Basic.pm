package Mason::Plugin::RouterSimple::t::Basic;
use Test::Class::Most parent => 'Mason::Test::Class';

__PACKAGE__->default_plugins( [ '@Default', 'RouterSimple' ] );

sub test_ok : Test(6) {
    my $self = shift;
    $self->add_comp(
        path => '/foo.m',
        src  => '
%% CLASS->router_add("bar");
%% CLASS->router_add("wiki/:page", { action => "wiki" });
%% CLASS->router_add("download/*.*", { action => "download" });
%% CLASS->router_add("blog/{year:[0-9]+}/{month:[0-9]{2}}");

% $m->result->data->{args} = $.args;
',
    );

    my $try = sub {
        my ( $path, $expect ) = @_;

        my $result;
        if ($expect) {
            $self->test_comp(
                path        => $path,
                expect_data => { args => { %$expect, router_result => $expect } }
            );
        }
        else {
            $self->test_comp( path => $path, expect_error => qr/could not find component/ );
        }
    };

    $try->( '/foo/bar',               {} );
    $try->( '/foo/wiki/abc',          { action => 'wiki', page => 'abc' } );
    $try->( '/foo/download/tune.mp3', { action => 'download', splat => [ 'tune', 'mp3' ] } );
    $try->( '/foo/blog/2010/02', { year => '2010', month => '02' } );
    $try->( '/foo/baz',          undef );
    $try->( '/foo/blog/201O/02', undef );
}

1;
