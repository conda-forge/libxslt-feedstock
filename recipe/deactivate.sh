#!/bin/bash

if test -n "${xml_catalog_files_libxslt}"; then
    export XML_CATALOG_FILES="${xml_catalog_files_libxslt}"
else
    unset XML_CATALOG_FILES
fi
unset xml_catalog_files_libxslt
