use strict;
use warnings;

use Test::More tests => 2;

use HTML::FormFu::MultiForm;

my $multi = HTML::FormFu::MultiForm->new({ tt_args => { INCLUDE_PATH => 'share/templates/tt/xhtml' } });

$multi->load_config_file('t-aggregated/multiform-nested-name/multiform.yml');

$multi->process;

my $html = <<HTML;
<form action="" id="form" method="post">
<fieldset>
<div class="text">
<input name="foo" type="text" />
</div>
<div>
<div class="text">
<input name="block.foo" type="text" />
</div>
</div>
<div class="submit">
<input name="submit" type="submit" />
</div>
</fieldset>
</form>
HTML

is( "$multi", $html );

my $form = $multi->current_form;

is( "$form", $html );
