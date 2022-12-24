#!/bin/bash
# Get an updated config.sub and config.guess
cp $BUILD_PREFIX/share/gnuconfig/config.* .

# osx-64 cross-compile seems to have trouble to get libxml2 info via pkg-config
if [[ ${target_platform} =~ .*arm64.* ]]; then
    LIBXML_CFLAGS="$( pkg-config --cflags libxml-2.0 )"
    LIBXML_LIBS="$( pkg-config --libs libxml-2.0 )"
    export LIBXML_CFLAGS LIBXML_LIBS
fi

./configure --prefix=$PREFIX \
            --with-libxml-prefix=$PREFIX \
            --enable-static=no \
            --without-python

make -j${CPU_COUNT} ${VERBOSE_AT}
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" || "${CROSSCOMPILING_EMULATOR}" != "" ]]; then
make check
fi
make install


# We can remove this when we start using the new conda-build.
find $PREFIX -name '*.la' -delete

for f in "activate" "deactivate"; do
    mkdir -p "${PREFIX}/etc/conda/${f}.d"
    cp "${RECIPE_DIR}/${f}.sh" "${PREFIX}/etc/conda/${f}.d/${PKG_NAME}_${f}.sh"
done
