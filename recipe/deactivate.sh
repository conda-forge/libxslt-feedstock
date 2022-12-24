#!/bin/bash

if test -z "${xml_catalog_files_libxslt}"; then
    unset XML_CATALOG_FILES
else
    export XML_CATALOG_FILES="${xml_catalog_files_libxslt}"
fi
unset xml_catalog_files_libxslt
