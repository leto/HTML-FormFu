use strict;
use warnings;

use Test::More tests => 9;

use HTML::FormFu;

my $form = HTML::FormFu->new;

$form->element('Text')->name('foo')->constraint('DependOn')
    ->others(qw/ bar baz /)->force_errors(1);
$form->element('Text')->name('bar');
$form->element('Text')->name('baz');

{
    $form->process( {
            foo => 1,
            bar => 'a',
            baz => [2],
        } );

    ok( !$form->has_errors('foo') );
    ok( !$form->has_errors('bar') );
    ok( !$form->has_errors('baz') );

    ok( $form->get_errors( { name => 'bar', forced => 1 } ) );
    ok( $form->get_errors( { name => 'baz', forced => 1 } ) );
}

{
    $form->process( {
            foo => 1,
            bar => '',
            baz => 2,
        } );

    ok( !$form->has_errors('foo') );
    ok( $form->has_errors('bar') );
    ok( !$form->has_errors('baz') );

    ok( $form->get_errors( { name => 'bar', forced => 1 } ) );
}
