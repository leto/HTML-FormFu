package HTML::FormFu::Attribute;

use strict;
use Exporter qw/ import /;
use HTML::FormFu::Util qw/
    append_xml_attribute remove_xml_attribute literal
    _parse_args /;

our @EXPORT_OK = qw/ mk_attrs mk_attr_accessors mk_attr_modifiers
    mk_inherited_accessors mk_output_accessors
    mk_inherited_merging_accessors mk_accessors /;

sub mk_accessors {
    my $class = shift;

    for my $name (@_) {
        my $sub = sub {
            my $self = shift;

            if ( @_ == 1 ) {
                $self->{$name} = $_[0];
                return $self;
            }
            elsif (@_) {
                $self->{$name} = [@_];
                return $self;
            }
            else {
                return $self->{$name};
            }
        };

        no strict 'refs';
        *{"$class\::$name"} = $sub;
    }
}

sub mk_attrs {
    my ( $self, @names ) = @_;

    my $class = ref $self || $self;

    for my $name (@names) {
        my $sub = sub {
            my $self = shift;

            $self->{$name} = {} if not exists $self->{$name};

            return $self->{$name} unless @_;

            my %attrs = ( @_ == 1 ) ? %{ $_[0] } : @_;

            $self->{$name}->{$_} = $attrs{$_} for keys %attrs;

            return $self;
        };
        my $xml_sub = sub {
            my $self = shift;
            my %attrs = ( @_ == 1 ) ? %{ $_[0] } : @_;

            return $self->$name(
                map { ( $_, literal( $attrs{$_} ) ) }
                    keys %attrs
            );
        };
        no strict 'refs';
        *{"$class\::$name"}       = $sub;
        *{"$class\::${name}_xml"} = $xml_sub;

        # add shortcuts
        my $short = $name;
        if ( $short =~ s/attributes$/attrs/ ) {
            *{"$class\::$short"}       = $sub;
            *{"$class\::${short}_xml"} = $xml_sub;
        }
    }

    mk_add_attrs( $class, @names );
    mk_del_attrs( $class, @names );

    return;
}

sub mk_attr_accessors {
    my ( $self, @names ) = @_;

    my $class = ref $self || $self;

    for my $name (@names) {
        my $sub = sub {
            return ( $_[0]->attributes->{$name} ) unless @_ > 1;
            my $self = shift;
            $self->attributes->{$name} = $_[0];
            return $self;
        };
        my $xml_sub = sub {
            my $self = shift;
            my @args;

            for my $item (@_) {
                if ( ref $item eq 'HASH' ) {
                    push @args, { map { $_, literal($_) } keys %$item };
                }
                elsif ( ref $item eq 'ARRAY' ) {
                    push @args, [ map { literal($_) } @$item ];
                }
                else {
                    push @args, literal($item);
                }
            }
            return $self->$name(@args);
        };
        no strict 'refs';
        *{"$class\::$name"}       = $sub;
        *{"$class\::${name}_xml"} = $xml_sub;

        # add shortcuts
        my $short = $name;
        if ( $short =~ s/attributes$/attrs/ ) {
            *{"$class\::$short"}       = $sub;
            *{"$class\::${short}_xml"} = $xml_sub;
        }
    }

    return;
}

sub mk_add_attrs {
    my ( $self, @names ) = @_;

    my $class = ref $self || $self;

    for my $name (@names) {
        my $sub = sub {
            my $self = shift;
            my %attrs = ( @_ == 1 ) ? %{ $_[0] } : @_;

            for ( keys %attrs ) {
                append_xml_attribute( $self->{$name}, $_, $attrs{$_} );
            }
            return $self;
        };
        my $xml_sub = sub {
            my $self = shift;
            my %attrs = ( @_ == 1 ) ? %{ $_[0] } : @_;

            my $method = "add_$name";

            return $self->$method(
                { map { $_, literal( $attrs{$_} ) } keys %attrs } );
        };
        no strict 'refs';
        *{"$class\::add_$name"}       = $sub;
        *{"$class\::add_${name}_xml"} = $xml_sub;

        # add shortcuts
        my $short = $name;
        if ( $short =~ s/attributes$/attrs/ ) {
            *{"$class\::add_$short"}       = $sub;
            *{"$class\::add_${short}_xml"} = $xml_sub;
        }
    }

    return;
}

sub mk_del_attrs {
    my ( $self, @names ) = @_;

    my $class = ref $self || $self;

    for my $name (@names) {
        my $sub = sub {
            my $self = shift;
            my %attrs = ( @_ == 1 ) ? %{ $_[0] } : @_;

            for ( keys %attrs ) {
                remove_xml_attribute( $self->{$name}, $_, $attrs{$_} );
            }
            return $self;
        };
        my $xml_sub = sub {
            my $self = shift;
            my %attrs = ( @_ == 1 ) ? %{ $_[0] } : @_;

            my $method = "del_$name";

            return $self->$method(
                { map { $_, literal( $attrs{$_} ) } keys %attrs } );
        };
        no strict 'refs';
        *{"$class\::del_$name"}       = $sub;
        *{"$class\::del_${name}_xml"} = $xml_sub;

        # add shortcuts
        my $short = $name;
        if ( $short =~ s/attributes$/attrs/ ) {
            *{"$class\::del_$short"}       = $sub;
            *{"$class\::del_${short}_xml"} = $xml_sub;
        }
    }

    return;
}

sub mk_inherited_accessors {
    my ( $self, @names ) = @_;

    my $class = ref $self || $self;

    for my $name (@names) {
        my $sub = sub {
            my $self = shift;
            if (@_) {
                $self->{$name} = $_[0];
                return $self;
            }
            while ( defined $self->parent && !defined $self->{$name} ) {
                $self = $self->parent;
            }
            return $self->{$name};
        };
        no strict 'refs';
        *{"$class\::$name"} = $sub;
    }

    return;
}

sub mk_inherited_merging_accessors {
    my ( $self, @names ) = @_;

    my $class = ref $self || $self;

    $class->mk_inherited_accessors(@names);

    for my $name (@names) {
        my $sub = sub {
            my $self = shift;
            if (@_) {
                my %attrs = ( @_ == 1 ) ? %{ $_[0] } : @_;

                for ( keys %attrs ) {
                    append_xml_attribute( $self->{$name}, $_, $attrs{$_} );
                }
                return $self;
            }
            while ( defined $self->parent && !defined $self->{$name} ) {
                $self = $self->parent;
            }
            return $self->{$name};
        };
        no strict 'refs';
        *{"$class\::add_$name"} = $sub;
    }

    return;
}

sub mk_output_accessors {
    my ( $self, @names ) = @_;

    my $class = ref $self || $self;

    for my $name (@names) {
        my $sub = sub {
            my $self = shift;
            if (@_) {
                $self->{$name} = $_[0];
                return $self;
            }
            return $self->{$name};
        };
        my $xml_sub = sub {
            my ( $self, $arg ) = @_;

            return $self->$name( literal($arg) );
        };
        my $loc_sub = sub {
            my ( $self, $mess, @args ) = @_;

            return $self->$name(
                literal( $self->form->localize( $mess, @args ) ) );
        };
        no strict 'refs';
        *{"$class\::$name"}       = $sub;
        *{"$class\::${name}_xml"} = $xml_sub;
        *{"$class\::${name}_loc"} = $loc_sub;
    }

    return;
}

1;

__END__

=head1 NAME

HTML::FormFu::Attribute

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 METHODS

=head1 AUTHOR

Carl Franks, C<cfranks.org>

Based on the original source code of L<HTML::Widget::Accessor>, by 
Sebastian Riedel, C<sri@oook.de>.

=head1 LICENSE

This library is free software, you can redistribute it and/or modify it under
the same terms as Perl itself.
