package File::Remove::Silent::Test;
use strict;
use warnings;
use base qw( Test::Class );
use Test::More;
use IO::File;
use Path::Class qw( dir file );
use File::Remove::Silent qw( silent_remove );
use File::Timestamp qw( timestamp );

sub setup : Test(setup) {
    my $self = shift;
    my $tmp_dir = "$0.tmp";

    if ( ! -d $tmp_dir ) {
        mkdir $tmp_dir or die "Can't create tmp directory.\n";
    }

    $self->{tmp_dir}    = $tmp_dir;
    $self->{test_dirs}  = [
        "$tmp_dir/parent/child",
        "$tmp_dir/parent",
    ];
    $self->{test_files} = [
        "$tmp_dir/parent/child/file2.txt",
        "$tmp_dir/parent/file1.txt",
    ];

}

sub teardown : Test(teardown) {
    my $self = shift;
    $self->remove_files;
    rmdir $self->{tmp_dir};
}

sub init {
    my $self = shift;
    $self->remove_files;
    $self->make_files;
}

sub make_files {
    my $self = shift;
    my $tmp_dir = $self->{tmp_dir};
    for my $dir ( reverse @{$self->{test_dirs}} ) {
        mkdir $dir if ! -d $dir;
    }
    for my $file ( reverse @{$self->{test_files}} ) {
        touch( $file ) if ! -f $file;
    }

    my $stamp = timestamp( 0, 0 );
    $stamp->set($_) for ( @{$self->{test_files}}, @{$self->{test_dirs}} );
}

sub touch {
    my $path = shift;
    my $fh = IO::File->new( ">$path" );
    if ( defined $fh ) {
        print $fh "touch\n";
        $fh->close;
    }
}

sub remove_files {
    my $self = shift;
    for my $file ( reverse @{$self->{test_files}} ) {
        unlink $file if -f $file;
    }
    for my $dir ( reverse @{$self->{test_dirs}} ) {
        rmdir $dir if -d $dir;
    }
}

sub t01_silent_remove : Tests {
    my $self = shift;
    my $stamp;

    $self->init;
    ok( -f $self->{test_files}->[0] );
    $stamp = timestamp(file($self->{test_files}->[0])->parent);
    File::Remove::Silent::silent_remove( $self->{test_files}->[0] );
    ok( !-f $self->{test_files}->[0] );
    is(
        timestamp(file($self->{test_files}->[0])->parent)->mtime,
        $stamp->mtime
    );

    $self->init;
    ok( -d $self->{test_dirs}->[0] );
    $stamp = timestamp(file($self->{test_dirs}->[0])->parent);
    File::Remove::Silent::silent_remove( \1, $self->{test_dirs}->[0] );
    ok( !-d $self->{test_dirs}->[0] );
    is(
        timestamp(file($self->{test_dirs}->[0])->parent)->mtime,
        $stamp->mtime
    );

    $self->init;
    ok( -d $self->{test_dirs}->[1] );
    $stamp = timestamp(file($self->{test_dirs}->[1])->parent);
    File::Remove::Silent::silent_remove( \1, $self->{test_dirs}->[1] );
    ok( !-d $self->{test_dirs}->[1] );
    is(
        timestamp(file($self->{test_dirs}->[1])->parent)->mtime,
        $stamp->mtime
    );
}

__PACKAGE__->runtests;
