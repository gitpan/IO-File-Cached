# $Id: Makefile.PL,v 1.2 2004/04/01 19:11:23 dan Exp $
# -*- perl -*-

use ExtUtils::MakeMaker;

WriteMakefile(
	      NAME => "IO::File::Cached",
	      VERSION_FROM => 'lib/IO/File/Cached.pm',
	      AUTHOR => "Daniel P. Berrange (dan[at]berrange[dot]com)",
              PREREQ_PM => {
	        'IO::Scalar' => '0',
		'Cache::Cache' => '0'
	      },
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
