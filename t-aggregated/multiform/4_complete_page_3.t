use strict;
use warnings;

use Test::More tests => 8;

use HTML::FormFu::MultiForm;

# submit form 1

my $yaml_file = 't-aggregated/multiform/multiform.yml';
my $form2_hidden_value;

{
    my $multi = HTML::FormFu::MultiForm->new;

    $multi->load_config_file($yaml_file);

    $multi->process( {
            foo    => 'abc',
            submit => 'Submit',
        } );

    ok( $multi->current_form->submitted_and_valid );

    my $form2 = $multi->next_form;

    my $hidden_field = $form2->get_field( { name => $multi->default_multiform_hidden_name } );

    $form2_hidden_value = $hidden_field->default;
}

# submit form 2

my $form3_hidden_value;

{
    my $multi = HTML::FormFu::MultiForm->new;

    $multi->load_config_file($yaml_file);

    $multi->process( {
            $multi->default_multiform_hidden_name => $form2_hidden_value,
            bar    => 'def',
            submit => 'Submit',
        } );

    my $form = $multi->current_form;

    ok( $form->submitted_and_valid );

    my $form3 = $multi->next_form;

    my $hidden_field = $form3->get_field( { name => $multi->default_multiform_hidden_name } );

    $form3_hidden_value = $hidden_field->default;
}

# submit form 3

{
    my $multi = HTML::FormFu::MultiForm->new;

    $multi->load_config_file($yaml_file);

    $multi->process( {
            $multi->default_multiform_hidden_name => $form3_hidden_value,
            baz    => 'ghi',
            submit => 'Submit',
        } );

    ok( $multi->complete );

    my $form = $multi->current_form;

    ok( $form->submitted_and_valid );

    my $params = $form->params;

    is( $params->{foo},    'abc' );
    is( $params->{bar},    'def' );
    is( $params->{baz},    'ghi' );
    is( $params->{submit}, 'Submit' );
}

