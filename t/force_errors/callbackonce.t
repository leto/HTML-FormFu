use strict;
use warnings;

use Test::More tests => 3;

use HTML::FormFu;

my $form = HTML::FormFu->new;

$form->element('Text')->name('foo')->constraint('CallbackOnce')->force_errors(1)
    ->callback(
    sub {
        return $_[0] eq 'a';
    } );

$form->element('Text')->name('bar')->constraint('CallbackOnce')->force_errors(1)
    ->callback(
    sub {
        return $_[0] eq 'b';
    } );

{
    $form->process( {
            foo => 'a',
            bar => 'c',
        } );

    ok( !$form->has_errors('foo') );
    ok( $form->has_errors('bar') );

    ok( @{ $form->get_errors( { name => 'foo', forced => 1 } ) } );
}
