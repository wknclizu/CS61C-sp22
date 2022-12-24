/* Include the system headers we need */
#include <stdlib.h>
#include <stdio.h>

/* Include our header */
#include "vector.h"

/* Define what our struct is */
struct vector_t {
    size_t size;
    int *data;
};

/* Utility function to handle allocation failures. In this
   case we print a message and exit. */
static void allocation_failed() {
    fprintf(stderr, "Out of memory.\n");
    exit(1);
}

/* Bad example of how to create a new vector */
vector_t *bad_vector_new() {
    /* 
    *   Create the vector and a pointer to it 
    *   The vector is created on the stack, instead of the heap.
    *   All memory stored on the stack gets freed 
    *   as soon as that function finishes running.
    */
    vector_t *retval, v;
    retval = &v;

    /* Initialize attributes */
    retval->size = 1;
    retval->data = malloc(sizeof(int));
    if (retval->data == NULL) {
        allocation_failed();
    }

    retval->data[0] = 0;
    return retval;
}

/* Another suboptimal way of creating a vector */
vector_t also_bad_vector_new() {
    /* Create the vector */
    // Struct vector_t v is too big 
    // that will slow down our speed when we return it.
    vector_t v;

    /* Initialize attributes */
    v.size = 1;
    v.data = malloc(sizeof(int));
    if (v.data == NULL) {
        allocation_failed();
    }
    v.data[0] = 0;
    return v;
}

/* Create a new vector with a size (length) of 1 and set its single component to zero... the
   right way */
/* TODO: uncomment the code that is preceded by // */
vector_t *vector_new() {
    /* Declare what this function will return */
    vector_t *retval;

    /* First, we need to allocate memory on the heap for the struct */
    retval = (vector_t *) malloc(sizeof(vector_t));

    /* Check our return value to make sure we got memory */
    if (!retval) {
        allocation_failed();
    }

    /* Now we need to initialize our data.
       Since retval->data should be able to dynamically grow,
       what do you need to do? */
    retval->size = 1;
    retval->data = (int *) malloc(sizeof(int));

    /* Check the data attribute of our vector to make sure we got memory */
    if (!retval->data) {
        free(retval);				//Why is this line necessary? ans: to prevent memery leak
        allocation_failed();
    }

    /* Complete the initialization by setting the single component to zero */
    retval->data[0] = 0;

    /* and return... */
    return retval; /* UPDATE RETURN VALUE */
}

/* Return the value at the specified location/component "loc" of the vector */
int vector_get(vector_t *v, size_t loc) {

    /* If we are passed a NULL pointer for our vector, complain about it and exit. */
    if(v == NULL) {
        fprintf(stderr, "vector_get: passed a NULL vector.\n");
        abort();
    }

    /* If the requested location is higher than we have allocated, return 0.
     * Otherwise, return what is in the passed location.
     */
    if (loc >= v->size) {
        return 0;
    }

    return v->data[loc];
}

/* Free up the memory allocated for the passed vector.
   Remember, you need to free up ALL the memory that was allocated. */
void vector_delete(vector_t *v) {
    if (v == NULL) {
        fprintf(stderr, "vector_delete: passed a NULL vector.\n");
        abort();
    }

    free(v->data);
    free(v);
}

/* Set a value in the vector. If the extra memory allocation fails, call
   allocation_failed(). */
void vector_set(vector_t *v, size_t loc, int value) {
    /* What do you need to do if the location is greater than the size we have
     * allocated?  Remember that unset locations should contain a value of 0.
     */

    int pre, i;

    if (v == NULL) {
        fprintf(stderr, "vector_set: passed a NULL vector.\n");
        abort();
    }

    if (loc < v->size) {
        v->data[loc] = value;
        return;
    }

    pre = v->size;
    v->data = realloc(v->data, sizeof(int) * (loc + 1));
    v->size = loc + 1;

    if (!v->data) {
        allocation_failed();
    }

    for (i = pre; i <= loc; i++) {
        v->data[i] = 0;
    }
    v->data[loc] = value;

    return;
}