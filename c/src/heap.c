#include <stdint.h>
#include <string.h>
#include <assert.h>
#include "heap.h"


/*
 * parent_index
 *
 * Get the index of the parent element of the element at a given index. Note
 * that this does not work for index 0 - the caller should check this first
 * before calling.
 */
static inline size_t
parent_index (size_t index)
{
    assert(index != 0);
    return (index - 1) / 2;
}


/*
 * heap_get_elem
 *
 * Get a pointer to the element at a given index in the heap array.
 */
static inline void *
heap_get_elem (const heap_type *heap,
               size_t           index)
{
    return (uint8_t *)heap->array + index * heap->elem_size;
}


/*
 * heap_swap_elems
 *
 * Swap two elements in the heap array.
 */
static void
heap_swap_elems (heap_type *heap,
                 size_t     index_a,
                 size_t     index_b)
{
    uint8_t tmp_elem[heap->elem_size];

    memcpy(tmp_elem,
           heap_get_elem(heap, index_a),
           heap->elem_size);
    memcpy(heap_get_elem(heap, index_a),
           heap_get_elem(heap, index_b),
           heap->elem_size);
    memcpy(heap_get_elem(heap, index_b),
           tmp_elem,
           heap->elem_size);
}


/*
 * heap_init
 *
 * See description in heap.h
 */
bool
heap_init (heap_type   *heap,
           size_t       elem_size,
           size_t       initial_size,
           heap_cmp_fn  cmp_fn)
{
    heap->array = calloc(initial_size, elem_size);
    if (heap->array == NULL) {
        return false;
    }

    heap->elem_size = elem_size;
    heap->max_size = initial_size;
    heap->cur_size = 0;
    heap->cmp = cmp_fn;
    return true;
}


/*
 * heap_destroy
 *
 * See description in heap.h
 */
void
heap_destroy (heap_type *heap)
{
    free (heap->array);
}


/*
 * heap_clear
 *
 * See description in heap.h
 */
void
heap_clear (heap_type *heap)
{
    heap->cur_size = 0;
}


/*
 * heap_is_empty
 *
 * See description in heap.h
 */
bool
heap_is_empty (heap_type *heap)
{
    return heap->cur_size == 0;
}


/*
 * heap_insert
 *
 * See description in heap.h
 */
bool
heap_insert (heap_type *heap,
             void      *elem)
{
    size_t  new_size;
    void   *new_array;
    bool    ok = true;
    size_t  cur_index;  // The current index of the new elem.
    size_t  next_index; // The index of the next elem to compare during sift.

    // Check whether the current array is long enough and resize it if
    // necessary.
    if (ok && heap->cur_size == heap->max_size) {
        new_size = heap->max_size * 2;
        new_array = realloc(heap->array, new_size);
        if (new_array == NULL) {
            ok = false;
        } else {
            heap->array = new_array;
            heap->max_size = new_size;
        }
    }

    if (ok) {
        // Insert the new element at the bottom of the heap.
        memcpy(heap_get_elem(heap, heap->cur_size),
               elem,
               heap->elem_size);
        heap->cur_size++;

        // Sift the new element upwards until it is in the correct position.
        cur_index = heap->cur_size - 1;
        next_index = parent_index(cur_index);
        while (cur_index > 0 &&
               heap->cmp(heap_get_elem(heap, cur_index),
                         heap_get_elem(heap, next_index)) > 0) {
            heap_swap_elems(heap, cur_index, next_index);
            cur_index = next_index;
            next_index = parent_index(cur_index);
        }
    }

    return ok;
}


/*
 * heap_extract
 *
 * See description in heap.h
 */
bool
heap_extract (heap_type *heap,
              void      *elem)
{
    size_t  cur_index;
    size_t  left_index;
    size_t  right_index;
    int     left_cmp;
    int     right_cmp;
    void   *cur_elem;
    void   *left_elem;
    void   *right_elem;

    if (heap->cur_size == 0) {
        return false;
    }

    // Copy out the element at the top of the heap.
    memcpy(elem,
           heap->array,
           heap->elem_size);

    // Swap the element we're extracting with the last element, and then sift
    // that element down.
    heap_swap_elems(heap, 0, heap->cur_size - 1);
    heap->cur_size -= 1;

    if (heap->cur_size == 0) {
        // We've removed the final element, there's nothing left to do.
        return true;
    }

    cur_index = 0;
    do {
        left_index = cur_index * 2 + 1;
        right_index = cur_index * 2 + 2;
        cur_elem = heap_get_elem(heap, cur_index);

        if (left_index > heap->cur_size - 1 &&
            right_index > heap->cur_size - 1) {
            // We've reached the bottom of the heap.
            break;
        } else if (right_index > heap->cur_size - 1) {
            // The current position only has a left child.
            left_elem = heap_get_elem(heap, left_index);
            left_cmp = heap->cmp(cur_elem, left_elem);
            if (left_cmp < 0) {
                heap_swap_elems(heap, cur_index, left_index);
                cur_index = left_index;
            } else {
                // The element is in the correct place
                break;
            }
        } else {
            left_elem = heap_get_elem(heap, left_index);
            right_elem = heap_get_elem(heap, right_index);
            left_cmp = heap->cmp(cur_elem, left_elem);
            right_cmp = heap->cmp(cur_elem, right_elem);

            if (left_cmp >= 0 && right_cmp >= 0) {
                // The element is in the correct place
                break;
            } else {
                if (heap->cmp(left_elem, right_elem) > 0) {
                    // The left element is nearer the top of the heap.
                    heap_swap_elems(heap, cur_index, left_index);
                    cur_index = left_index;
                } else {
                    // The right element is nearer the top of the heap.
                    heap_swap_elems(heap, cur_index, right_index);
                    cur_index = right_index;
                }
            }
        }
    } while (true);

    return true;
}
