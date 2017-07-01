#ifndef __HEAP_H__
#define __HEAP_H__


#include <stdbool.h>
#include <stdlib.h>


/*
 * heap_cmp_fn
 *
 * Function type for functions used to compare different elements on the heap.
 * Should return:
 *  < 0 if the second element should be higher in the heap than the first.
 *  0 if the elements are the same.
 *  > 0 if the first element should be higher in the heap than the second.
 */
typedef int (* heap_cmp_fn)(void *, void *);

typedef struct heap {
    size_t       elem_size;
    size_t       max_size;
    size_t       cur_size;
    heap_cmp_fn  cmp;
    void        *array;
} heap_type;

bool heap_init(heap_type   *heap,
               size_t       elem_size,
               size_t       initial_size,
               heap_cmp_fn  cmp_fn);

void heap_destroy(heap_type *heap);


void heap_clear(heap_type *heap);


bool heap_is_empty(heap_type *heap);


bool heap_insert(heap_type *heap,
                 void      *elem);


bool heap_extract(heap_type *heap,
                  void      *elem);


#endif /* __HEAP_H__ */
