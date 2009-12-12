package HTML::FormFu::I18N::en;
use strict;

use base qw( HTML::FormFu::I18N );

our %Lexicon = (
    form_error_message =>
        'There were errors with your submission, see below for details',
    form_constraint_allornone    => 'Error',
    form_constraint_ascii        => 'Field contains invalid characters',
    form_constraint_autoset      => 'Field contains an invalid choice',
    form_constraint_bool         => 'Field must be a boolean value',
    form_constraint_callback     => 'Invalid input',
    form_constraint_datetime     => 'Invalid date',
    form_constraint_dependon     => 'Error',
    form_constraint_email        => 'This field must contain an email address',
    form_constraint_equal        => 'Error',
    form_constraint_file         => 'Not a file',
    form_constraint_file_mime    => 'Invalid file-type',
    form_constraint_file_size    => 'Invalid file-size',
    form_constraint_integer      => 'This field must be an integer',
    form_constraint_length       => 'Invalid input',
    form_constraint_minlength    => 'Must be at least [_1] characters long',
    form_constraint_minmaxfields => 'Invalid input',
    form_constraint_maxlength => 'Must not be longer than [_1] characters long',
    form_constraint_number    => 'This field must be a number',
    form_constraint_printable => 'Field contains invalid characters',
    form_constraint_range     => 'Invalid input',
    form_constraint_regex     => 'Invalid input',
    form_constraint_required  => 'This field is required',
    form_constraint_set       => 'Field contains an invalid choice',
    form_constraint_singlevalue    => 'This field only accepts a single value',
    form_constraint_word           => 'Field contains invalid characters',
    form_inflator_compounddatetime => 'Invalid date',
    form_inflator_datetime         => 'Invalid date',
    form_validator_callback        => 'Validator error',
    form_transformer_callback      => 'Transformer error',

    form_inflator_imager       => 'Error opening image file',
    form_validator_imager_size => 'Image upload too large',
    form_transformer_imager    => 'Error processing image file',
);

1;
