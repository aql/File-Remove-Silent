package File::Remove::Silent;

use warnings;
use strict;
use Carp;

use version;
our $VERSION = qv('0.0.1');

use base qw( Exporter::Lite );
use File::Remove qw( remove );
use File::Timestamp qw( timestamp );
use Path::Class qw();
use List::MoreUtils qw();

our @EXPORT_OK = qw( silent_remove );
use Data::Dumper;

sub silent_remove {
    my @parents =
        map  { {path  => $_->parent, stamp => timestamp($_->parent)}; }
        map  { -d $_ ? Path::Class::dir( $_ ) : Path::Class::file( $_ ); }
        grep { $_ and ( -d $_ or -f $_ ); }
        map  { $_ }
        List::MoreUtils::uniq( @_ );
    my @results = remove( @_ );
    $_->{stamp}->set( $_->{path} ) for @parents;
    return @results;
}

1;
__END__

=head1 NAME

File::Remove::Silent - File::Remove by stealth


=head1 SYNOPSIS

    use File::Remove::Silent qw( silent_remove );

    silent_remove( '*.c', '*.pl' );
    silent_remove( \1, qw{directory1 directory2} ); # recursive
    silent_remove( \1, qw{file1 file2 directory1 *~} );


=head1 DESCRIPTION

This function makes no changes in the timestamp of parent directory.


=head1 FUNCTIONS

=over 4

=item C<< silent_remove >>

=back


=head1 DEPENDENCIES

L<File::Remove>, L<File::Timestamp>, L<List::MoreUtils>, L<Path::Class>


=head1 SEE ALSO

L<File::Remove>


=head1 AUTHOR

TOYODA Tetsuya  C<< <cpan@hikoboshi.org> >>


=head1 LICENCE AND COPYRIGHT

Copyright (c) 2009, TOYODA Tetsuya C<< <cpan@hikoboshi.org> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.
