#!/bin/sh
ver=$(grep '^slkbuildver=' src/slkbuild | cut -d= -f2)
[ -n "$rlz" ] || rlz=1gv
make PREFIX=/usr
mkdir -p pkg/install
cat >pkg/install/doinst.sh <<"EODOTNEW"
dotnew() {
  NEW="${1}.new"
  OLD="$1"
  if [ ! -e $OLD ]; then
    mv $NEW $OLD
  elif [ "$(cat $OLD | md5sum)" = "$(cat $NEW | md5sum)" ]; then
    rm $NEW
  fi
}

EODOTNEW
cat >pkg/install/slack-desc <<"EODESC"
slkbuild: slkbuild (arch-like wrapper script for easy packaging)
slkbuild: 
slkbuild: slkbuild is a script inspired by makepkg from Arch which greatly
slkbuild: simplifies the package building process in Slackware and derivatives.
slkbuild: It parses an easy to create SLKBUILD meta-file and from that creates
slkbuild: slackware packages.
slkbuild: 
slkbuild: 
slkbuild: 
slkbuild: 
slkbuild: 
EODESC
fakeroot sh -c 'make PREFIX=/usr DESTDIR=pkg install && \
  cd pkg && \
  for conf in $(find ./etc -type f); do mv -v $conf ${conf}.new; echo "dotnew $conf" >>install/doinst.sh; done && \
  makepkg -p -l y -c n ../slkbuild-'$ver'-noarch-'$rlz'.txz && \
  cd .. && \
  rm -rf pkg'
