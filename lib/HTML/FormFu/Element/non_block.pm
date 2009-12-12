package HTML::FormFu::Element::non_block;

use strict;
use warnings;
use base 'HTML::FormFu::Element';

__PACKAGE__->mk_accessors(qw/ tag /);

sub new {
    my $self = shift->SUPER::new(@_);

    $self->filename('non_block');

    return $self;
}

sub render {
    my $self = shift;

    my $render = $self->SUPER::render({
        tag => $self->tag,
        @_ ? %{$_[0]} : ()
        });

    return $render;
}

1;

__END__

=head1 NAME

HTML::FormFu::Element::non_block

=head1 DESCRIPTION

Base class for single-tag elements.

=head1 METHODS

=head2 tag

=head1 SEE ALSO

Is a sub-class of, and inherits methods from L<HTML::FormFu::Element>

L<HTML::FormFu::FormFu>

=head1 AUTHOR

Carl Franks, C<cfranks@cpan.org>

=head1 LICENSE

This library is free software, you can redistribute it and/or modify it under
the same terms as Perl itself.
