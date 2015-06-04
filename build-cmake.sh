#!/bin/bash -ex
# Download & build cmake on the local machine
# works on Linux, OSX, and Windows (Git Bash)
# leaves output in /tmp/cmake-build/install/
# cmake must be installed on Windows

PROJ=cmake
VER=3.2.3
MSVS=2013

source $(dirname "$0")/build-common.sh build-common.sh

case "$OS" in
windows)
	# wasted a lot of time trying to get it building on windows
	# makefile building didn't work, maybe I should use devenv building
	# just copy the binary release into the install location
	#ZIP=$PROJ-$VER-win32-x86.zip
	#curl -L http://www.cmake.org/files/v3.2/$ZIP -o $ZIP
	#unzip $ZIP
	#mv $PROJ-$VER-win32-x86/* $INSTALL
	ZIP=$PROJ-$VER.zip  # has \r\n line feeds
	#curl http://www.cmake.org/files/v3.2/$ZIP -o $ZIP
	#unzip $ZIP
	TGZ=$PROJ-$VER.tar.gz  # has \n line feeds
	curl -L http://www.cmake.org/files/v3.2/$TGZ -o $TGZ
	tar xzf $TGZ
	mkdir $RD/build
	cd $RD/build
	cmake "$(cygpath -w $RD/$PROJ-$VER)"
	;;
*)
	TGZ=$PROJ-$VER.tar.gz  # has \n line feeds
	curl -L http://www.cmake.org/files/v3.2/$TGZ -o $TGZ
	tar xzf $TGZ
	mkdir $RD/build
	cd $RD/build
	$RD/$PROJ-$VER/configure --prefix=$INSTALL
	make -j$CORES
	make install
	;;
esac

commit_and_push
