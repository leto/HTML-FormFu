use strict;
use warnings;

use Test::More tests => 1;

use HTML::FormFu;

my $form = HTML::FormFu->new;
$form->load_config_file('t/elements/simple_table_multiple.yml');

# test putting an array-ref of elements into a single cell

my $xhtml = <<EOF;
<form action="" method="post">
<fieldset>
<table class="simpletable">
<tr>
<th>
foo
</th>
<th>
bar
</th>
</tr>
<tr>
<td>
<span class="text">
<input name="foo" type="text" />
</span>
<span class="radio">
<input name="foo" type="radio" />
</span>
</td>
<td>
<span class="text">
<input name="bar" type="text" />
</span>
<span class="radio">
<input name="bar" type="radio" />
</span>
</td>
</tr>
</table>
</fieldset>
</form>
EOF

is( "$form", $xhtml );

