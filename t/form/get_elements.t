use strict;
use warnings;

use Test::More tests => 15;

use HTML::FormFu;

my $form = HTML::FormFu->new({ tt_args => { INCLUDE_PATH => 'share/templates/tt/xhtml' } });

my $fs = $form->element('Fieldset');

my $e1 = $fs->element('Text')->name('foo');
my $e2 = $fs->element('Hidden')->name('foo');
my $e3 = $fs->element('Hidden')->name('bar');

{
    my $elems = $form->get_elements;

    is( @$elems, 1 );

    is( $elems->[0], $fs );
}

{
    my $elems = $form->get_elements( { type => 'Fieldset' } );

    is( @$elems, 1 );

    is( $elems->[0], $fs );
}

{
    my $elems = $fs->get_elements('foo');

    is( @$elems, 2 );

    is( $elems->[0], $e1 );
    is( $elems->[1], $e2 );
}

{
    my $elems = $fs->get_elements( { name => 'foo' } );

    is( @$elems, 2 );

    is( $elems->[0], $e1 );
    is( $elems->[1], $e2 );
}

{
    my $elems = $fs->get_elements( { type => 'Hidden' } );

    is( @$elems, 2 );

    is( $elems->[0], $e2 );
    is( $elems->[1], $e3 );
}

{
    my $elems = $fs->get_elements( {
            name => 'foo',
            type => 'Hidden',
        } );

    is( @$elems, 1 );

    is( $elems->[0], $e2 );
}
