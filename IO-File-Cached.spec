# Automatically generated by IO-File-Cached.spec.PL

%define perlsitearch %(perl -e 'use Config; print $Config{installsitearch}')
%define perlsitelib %(perl -e 'use Config; print $Config{installsitelib}')
%define perlman1dir %(perl -e 'use Config; print $Config{installman1dir}')
%define perlman3dir %(perl -e 'use Config; print $Config{installman3dir}')
%define perlversion %(perl -e 'use Config; print $Config{version}')

Summary: IO::File::Cached - On demand file caching
Name: perl-IO-File-Cached
Version: 1.0.0
Release: 1
Copyright: GPL
Group: Applications/Internet
Source: %{name}-%{version}.tar.gz
BuildRoot: /var/tmp/%{name}-%{version}-root
BuildArchitectures: noarch
#Requires: perl >= %{perlversion}
Requires: perl

%description

IO::File::Cached is a subclass of IO::Scalar that uses IO::File
and Cache::Cache for load on demand caching of files.
 
%prep
%setup -q


%build
perl Makefile.PL
make


%install
rm -rf $RPM_BUILD_ROOT
make PREFIX=$RPM_BUILD_ROOT/usr INSTALLMAN3DIR=$RPM_BUILD_ROOT/usr/share/man/man3 install
find $RPM_BUILD_ROOT/usr/lib/perl5 -name perllocal.pod -exec rm -f {} \;


%clean
rm -rf $RPM_BUILD_ROOT


%files
%defattr(-,root,root)
%doc AUTHORS
%doc COPYING
%doc README
%{perlman3dir}/*
%{perlsitelib}/IO/File/Cached.pm