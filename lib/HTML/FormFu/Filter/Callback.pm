package HTML::FormFu::Filter::Callback;

use strict;
use warnings;
use base 'HTML::FormFu::Filter';

__PACKAGE__->mk_accessors(qw/callback/);

sub filter {
    my ( $self, $value ) = @_;

    my $callback = $self->callback || sub { $_[0] };

    return $callback->($value);
}

1;

__END__

=head1 NAME

HTML::FormFu::Filter::Callback - filter with custom subroutine

=head1 SYNOPSIS

    $form->filter( Callback => 'foo' );

=head1 DESCRIPTION

Filter using a user-provided subroutine.

=head1 AUTHOR

Carl Franks, C<cfranks@cpan.org>

Based on the original source code of L<HTML::Widget::Filter::Callback>, by 
Lyo Kato, C<lyo.kato@gmail.com>

=head1 LICENSE

This library is free software, you can redistribute it and/or modify it under
the same terms as Perl itself.

=cut
