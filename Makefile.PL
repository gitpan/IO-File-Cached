# $Id: Makefile.PL,v 1.1 2004/02/10 19:04:40 dan Exp $
# -*- perl -*-

use ExtUtils::MakeMaker;

WriteMakefile(
	      NAME => "IO::File::Cached",
	      VERSION_FROM => 'lib/IO/File/Cached.pm',

	      dist =>
	      {
	       COMPRESS => 'gzip --force --best',
	      },

	      clean =>
	      {
	       FILES => '*.bak *~',
	      },
	      
	      depend => {
	        Makefile => '$(VERSION_FROM)',
	        IO-File-Cached.spec => '$(VERSION_FROM)',
		dist => 'IO-File-Cached.spec',
	      },
	      
	      realclean => {
	       FILES => 'IO-File-Cached-*.tar.gz IO-File-Cached.spec',
	      }
	     );

package MY;

sub libscan
  {
    my ($self, $path) = @_;
    ($path =~ /\~$/) ? undef : $path;
  }

__END__
