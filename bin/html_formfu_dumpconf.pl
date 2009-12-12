#!/usr/bin/perl
use strict;
use warnings;
use Pod::Help qw( -h --help );
use Config::Any;
use Data::Dumper ();
use Regexp::Assemble;

if ( @ARGV == 1 ) {
    my $file = $ARGV[0];
    
    # do we have a filename or stem?
    my $regex_builder = Regexp::Assemble->new;
    
    map { $regex_builder->add($_) } Config::Any->extensions;
    
    my $regex = $regex_builder->re;
    my $config;
    
    if ( $file =~ m/ \. $regex \z /x ) {
        $config = Config::Any->load_files({
            files => [$file],
            _config_any_args(),
        });
    }
    else {
        $config = Config::Any->load_stems({
            stems => [$file],
            _config_any_args(),
        });
    }
    
    die "File not found: '$file'\n"
        if !@$config;
    
    my ( $filename, $data ) = %{ $config->[0] };
    
    my $dumper = Data::Dumper->new( [$data] );
    
    $dumper->Terse(1);
    $dumper->Useqq(1);
    $dumper->Quotekeys(0);
    $dumper->Sortkeys(1);
    
    print "$filename\n";
    print $dumper->Dump;
}
elsif ( @ARGV ) {
    die <<ERROR;
html_formfu_dumpconf.pl: requires a single filename argument.
Try "--help" for help.
ERROR
}
else {
    Pod::Help->help;
}

sub _config_any_args {
    return (
        use_ext => 1,
    );
}

__END__

=head1 NAME

html_formfu_dumpconf.pl

=head1 SYNOPSIS

    html_formfu_dumpconf.pl file.conf
    
    html_formfu_dumpconf.pl file # searches for any supported file extensions
    
    html_formfu_dumpconf.pl --help

=head1 DESCRIPTION

Uses L<Config::Any> and L<Data::Dumper> to display how your config file is
parsed.
