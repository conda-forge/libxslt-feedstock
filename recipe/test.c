#include <libxslt/xslt.h>

int main(void) {
    xsltInit();
    xsltCleanupGlobals();
    return 0;
}
