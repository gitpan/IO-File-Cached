# -*- perl -*-
#
# IO::File::Cached by Daniel Berrange <dan@berrange.com>
#
# Copyright (C) 20004  Daniel P. Berrange <dan@berrange.com>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#
# $Id: Cached.pm,v 1.3 2004/02/12 14:20:38 dan Exp $

=pod

=head1 NAME

IO::File::Cached - an caching file IO handle 

=head1 SYNOPSIS

    use IO::File::Cached;

    # Open a file and read it line by line
    my $fh = IO::File::Cached->new(filename => $filename,
                                   cache => $cache);
    while (defined ($_ = $fh->read)) {
	print "Got line: $_\n";
    }
    $fh->close;

=head1 DESCRIPTION

The IO::File::Cached module is a subclass of the IO::Scalar module
that uses IO::File and Cache::Cache modules to access the contents
of a file. The first time it is called for a particular file name it 
will load the file as normal using IO::File. The entire contents of 
the file will then be stored in the supplied cache object, such that
later loads do not have to read from disk. One situation in which
this can be useful is to cache files in memory across all processes
in a mod_perl server.

=head1 METHODS

=over 4

=cut

package IO::File::Cached;

use strict;
use IO::Scalar;
use IO::File;
use Carp qw(confess);

use vars qw($VERSION $RELEASE @ISA);

@ISA = qw(IO::Scalar);

$VERSION = "1.0.0";
$RELEASE = "1";

=item new(filename => $filename[, cache => $cache] );

Creates a new IO::File::Cached object. If the cache parameter is
supplied, this cache object will be used to load and store the
file contents. At this time, instances of IO::File::Cached are
read only. The object specified by the 'cache' parameter should
be an instance of the Cache::Cache module.

=cut

sub new {
    my $proto = shift;
    my $class = ref($proto) || $proto;
    my %params = @_;

    my $filename = exists $params{filename} ? $params{filename} : confess "filename parameter is required";
    my $cache = exists $params{cache} ? $params{cache} : undef;

    my $data;
    if ($filename eq '-') {
	local $/ = undef;
	$data = <STDIN>;
    } else {
	if (defined $cache)  {
	    $data = $cache->get($filename);
	}
      
	if (!defined $data) {
	    my $fh = IO::File->new($filename) or
		confess "cannot load file $filename: $!";;
	    local $/ = undef;
	    $data = <$fh>;
	    $fh->close or 
		confess "cannot close file $filename: $!";
	    
	    if (defined $cache) {
		$cache->set($filename, $data);
	    }
	}
    }
    
    my $self = $class->SUPER::new(\$data);

    bless $self, $class;
    
    return $self;
}


1 # So that the require or use succeeds.

__END__

=back 4

=head1 AUTHORS

Daniel Berrange <dan@berrange.com>

=head1 COPYRIGHT

Copyright (C) 2004 Daniel P. Berrange <dan@berrange.com>

=head1 SEE ALSO

L<perl(1)>, L<IO::Scalar>, L<Cache::Cache>, L<IO::File>

=cut
