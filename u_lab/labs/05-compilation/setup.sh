#!/bin/bash
set -e

# 1. Create directory structures
mkdir -p /root/src
mkdir -p /var/local/repo

# 2. Write shared library header file
cat << 'EOF' > /root/src/libmastery.h
#ifndef LIBMASTERY_H
#define LIBMASTERY_H
void print_mastery_message(void);
#endif
EOF

# 3. Write shared library implementation source file
cat << 'EOF' > /root/src/libmastery.c
#include <stdio.h>
#include "libmastery.h"

void print_mastery_message(void) {
    printf("Labyrinth: Ubuntu Server Mastery Completed!\n");
}
EOF

# 4. Write main application source file using the library
cat << 'EOF' > /root/src/main.c
#include "libmastery.h"

int main(void) {
    print_mastery_message();
    return 0;
}
EOF

# 5. Clean prior compilations and loader maps
rm -f /usr/local/lib/libmastery.so
rm -f /usr/local/bin/my_app
rm -f /etc/ld.so.conf.d/mastery.conf
ldconfig

# 6. Reset custom local APT repo configuration
rm -f /etc/apt/sources.list.d/local.list
