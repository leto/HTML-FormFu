package HTML::FormFu::Element::Checkbox;

use strict;
use base 'HTML::FormFu::Element::_Input';
use Class::C3;

__PACKAGE__->mk_output_accessors(qw/ default /);

use HTML::FormFu::Util qw(
    append_xml_attribute
    has_xml_attribute
    remove_xml_attribute
    xml_escape
);

sub new {
    my $self = shift->next::method(@_);

    $self->field_type('checkbox');
    $self->multi_filename('multi_rtl');

    return $self;
}

sub process_value {
    my ( $self, $render ) = @_;

    return $self->value;
}

sub prepare_attrs {
    my ( $self, $render ) = @_;

    my $submitted = $self->form->submitted;
    my $default   = $self->default;
    my $original  = $self->value;
    my $value     = $self->form->input->{ $self->name };

    if (   $submitted
        && defined $value
        && defined $original
        && $value eq $original )
    {
        $render->attributes( 'checked', 'checked' );
    }
    elsif ($submitted
        && $self->retain_default
        && ( !defined $value || $value eq "" ) )
    {
        $render->attributes( 'checked' => 'checked' );
    }
    elsif ($submitted) {
        delete $render->attributes->{checked};
    }
    elsif ( defined $default && $default eq $original ) {
        $render->attributes( 'checked', 'checked' );
    }

    $self->next::method($render);

    return;
}

1;

__END__

=head1 NAME

HTML::FormFu::Element::Checkbox - Checkbox form field

=head1 SYNOPSIS

    my $e = $form->element( checkbox => 'foo' );

=head1 DESCRIPTION

Checkbox form field.

=head1 METHODS

=head1 SEE ALSO

Is a sub-class of, and inherits methods from 
L<HTML::FormFu::Element::_Input>, 
L<HTML::FormFu::Element::_Field>, 
L<HTML::FormFu::Element>

L<HTML::FormFu::FormFu>

=head1 AUTHOR

Carl Franks, C<cfranks@cpan.org>

=head1 LICENSE

This library is free software, you can redistribute it and/or modify it under
the same terms as Perl itself.
