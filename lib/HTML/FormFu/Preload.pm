package HTML::FormFu::Preload;

use strict;
use warnings;
use HTML::FormFu;

use Module::Pluggable (
    search_path => [
        qw/
            HTML::FormFu::Element
            HTML::FormFu::Constraint
            HTML::FormFu::Deflator
            HTML::FormFu::Filter
            HTML::FormFu::Inflator
            HTML::FormFu::Render
            /
    ],
    require => 1
);

__PACKAGE__->plugins;

Class::C3::initialize();

1;
