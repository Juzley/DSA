#include <stdbool.h>
#include "heap.h"


static int
heap_test_min_cmp (void *a, void *b)
{
    int int_a = *(int *)a;
    int int_b = *(int *)b;

    return int_b - int_a; 
}


static int
heap_test_max_cmp (void *a, void *b)
{
    int int_a = *(int *)a;
    int int_b = *(int *)b;

    return int_a - int_b;
}


int
main (int argc, char *argv[])
{
    heap_type heap;
    int       val;

    heap_init(&heap, sizeof(val), 5, &heap_test_min_cmp);

    val = 2; heap_insert(&heap, &val);
    val = 4; heap_insert(&heap, &val);
    val = 1; heap_insert(&heap, &val);
    val = 0; heap_insert(&heap, &val);
    val = 3; heap_insert(&heap, &val);

    for (int i = 0; i < 5; i++) {
        heap_extract(&heap, &val);
        if (val != i) {
            return 1;
        }
    }

    heap_destroy(&heap);

    heap_init(&heap, sizeof(val), 5, &heap_test_max_cmp);
    val = 2; heap_insert(&heap, &val);
    val = 4; heap_insert(&heap, &val);
    val = 1; heap_insert(&heap, &val);
    val = 0; heap_insert(&heap, &val);
    val = 3; heap_insert(&heap, &val);

    for (int i = 4; i >= 0; i--) {
        heap_extract(&heap, &val);
        if (val != i) {
            return 1;
        }
    }

    return 0;
}
