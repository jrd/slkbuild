#Packager: Name <email@address.com>
#Former Packager(s): Name <email@address.com>
#Anything commented out is optional and can be deleted.

pkgname=
pkgver=
pkgrel=
#arch is usually one of x86_64/i486/i686/noarch
arch=i486
source=()
#sourcetemplate=http://people.salixos.org/yournick/$pkgname/$pkgver/
#docs=("readme" "install" "copying" "changelog" "authors" "news" "todo")
#url=
#dotnew=()
#CFLAGS=
#CXXFLAGS=
#options=('noextract')

#doinst() {
#
#}

slackdesc=\
(
#|-----handy-ruler------------------------------------------------------|
""
)


build() {
	cd $startdir/src/$pkgname-$pkgver

	perl Makefile.PL || exit 1
	make OPTIMIZE="$CFLAGS" || exit 1
	make install INSTALLDIRS=vendor DESTDIR=$startdir/pkg || exit 1

	# Remove perllocal.pod and .packlist if present in the package
	( for i in perllocal.pod .packlist; do
	        find $startdir/pkg -name "$i" -exec rm -rf {} \;
		  done
	) || exit 1
} 