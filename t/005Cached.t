# $Id: 005Cached.t,v 1.1 2004/02/10 19:04:40 dan Exp $

BEGIN { $| = 1; print "1..2\n"; }
END { print "not ok 1\n" unless $loaded; }

use IO::File::Cached;
use Cache::MemoryCache;
use Carp qw(confess);

$SIG{__WARN__} = sub { confess "now"; };
$SIG{__DIE__} = sub { confess "then"; };

$loaded = 1;
print "ok 1\n";

my $cache = Cache::MemoryCache->new( { namespace => 'Test',
				       default_expires_in => 600 });
my $expected = "foobar";

$cache->set('foo.txt', $expected);

my $file = IO::File::Cached->new(filename => 'foo.txt',
				 cache => $cache);

$/ = undef;
my $actual = <$file>;

print "not " unless $actual eq $expected;
print "ok 2\n";

# Local Variables:
# mode: cperl
# End:
