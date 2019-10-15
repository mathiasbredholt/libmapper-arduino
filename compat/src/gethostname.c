#include <stdio.h>

int gethostname(char *name, size_t len) {
    snprintf(name, len, "esp32");
    return 0;
}
