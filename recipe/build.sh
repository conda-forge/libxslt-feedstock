#!/bin/bash
# Get an updated config.sub and config.guess
cp $BUILD_PREFIX/share/gnuconfig/config.* .

sed -i.bak -e 's/-llzma //g' -e 's/-lz //g' $PREFIX/bin/xml2-config

# It looks like an missing symbol of libxml2 on osx-arm64
if [[ ${target_platform} =~ .*arm64.* ]]; then
    LDFLAGS="${LDFLAGS} -lxml2"
fi

./configure --prefix=$PREFIX \
            --with-libxml-prefix=$PREFIX \
            --without-python

make -j${CPU_COUNT} ${VERBOSE_AT}
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" || "${CROSSCOMPILING_EMULATOR}" != "" ]]; then
make check
fi
make install


# We can remove this when we start using the new conda-build.
find $PREFIX -name '*.la' -delete
