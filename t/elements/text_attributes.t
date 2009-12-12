use strict;
use warnings;

use Test::More tests => 10;

use HTML::FormFu;

my $form = HTML::FormFu->new;

my $element = $form->element('text')->name('foo')->comment('Whatever')->label('Foo')
    ->default('bar')->size(30)->maxlength(50);

is( $element->name,         'foo',      'element name' );
is( $element->type, 'text',     'element type' );
is( $element->comment,      'Whatever', 'element comment' );
is( $element->label,        'Foo',      'element label' );
is( $element->default,      'bar',      'element value' );
is( $element->size,         30,         'element size' );
is( $element->maxlength,    50,         'element maxlength' );
is_deeply(
    $element->attributes,
    {   size      => 30,
        maxlength => 50,
    },
    'element attributes',
);

# add more elements to test accessor output
$form->element('text')->name('bar')->container_attributes( { class => 'bar' } );

my $expected_field_xhtml = qq{<span class="text comment label">
<label>Foo</label>
<input name="foo" type="text" value="bar" maxlength="50" size="30" />
<span class="comment">
Whatever
</span>
</span>};

is( "$element", $expected_field_xhtml, 'stringified field' );

my $expected_form_xhtml = <<EOF;
<form action="" method="post">
$expected_field_xhtml
<span class="bar text">
<input name="bar" type="text" />
</span>
</form>
EOF

is( "$form", $expected_form_xhtml, 'stringified form' );

