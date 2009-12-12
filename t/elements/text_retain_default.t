use strict;
use warnings;

use Test::More tests => 9 + 1;
use Test::NoWarnings;

use HTML::FormFu;

my $form = HTML::FormFu->new;

$form->element('text')->name('foo')->default('a')->retain_default(1);
$form->element('text')->name('bar')->default('b');
$form->element('text')->name('baz')->default('c')->retain_default(1);

$form->process({
        foo => '',
        bar => '',
    });

ok( $form->valid('foo') );
ok( $form->valid('bar') );
ok( !$form->valid('baz') );

is( $form->param('foo'), '' );
is( $form->param('bar'), '' );
is( $form->param('baz'), undef );

like( $form->get_field('foo'), qr/value="a"/ );
like( $form->get_field('bar'), qr/value=""/ );
like( $form->get_field('baz'), qr/value="c"/ );
