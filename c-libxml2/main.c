#include <stdio.h>
#include <stdlib.h>
#include <limits.h>
#include <libxml/parser.h>
#include <libxml/tree.h>
#include <libxml/HTMLparser.h>
#include <libxml/HTMLtree.h>


static void run_loop(char *html, size_t size, const char *name, int n) {
    int i;
    xmlDocPtr doc;

    for (i = 0; i < n; i++) {
        doc = htmlReadMemory(html, size, name, NULL,
                             (HTML_PARSE_RECOVER
                              | HTML_PARSE_NOWARNING
                              | HTML_PARSE_NOERROR
                              | HTML_PARSE_NONET));
        if (doc == NULL) {
            fprintf(stderr, "Failed to parse document\n");
            return;
        }
        xmlFreeDoc(doc);
    }
}


static suseconds_t time_us() {
    struct timeval t;
    gettimeofday(&t, NULL);
    return (t.tv_sec * 1000000) + t.tv_usec;
}


int main(int argc, char *argv[]) {
    suseconds_t start, runtime_us;
    long double runtime_s;
    char *html;
    size_t size;
    ulong n;
    FILE *f;

    /* parse args */
    if (argc != 3) {
        printf("Usage: %s <path-to-html-file> <number-of-iterations>\n", argv[0]);
        exit(1);
    }

    if ( (f = fopen(argv[1], "r")) == NULL) {
        printf("Can't open file %s", argv[1]);
        exit(1);
    }

    if ( (n = strtoul(argv[2], NULL, 10)) == ULONG_MAX ) {
        printf("Bad number of iterations");
        exit(1);
    }

    /* load file to memory */
    fseek(f, 0, SEEK_END);
    size = (size_t)ftell(f);
    fseek(f, 0, SEEK_SET);

    html = (char *)malloc(size + 1);
    if (size != fread(html, sizeof(char), size, f)) {
        printf("Can't read file");
        exit(2);
    }
    fclose(f);
    (html)[size] = 0;

    /* benchmarking */
    start = time_us();

    run_loop(html, size, argv[1], n);

    runtime_us = time_us() - start;
    runtime_s = runtime_us / 1000000.0;
    printf("%Lf s\n", runtime_s);
}
