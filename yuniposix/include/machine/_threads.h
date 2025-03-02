#ifndef YUNIPOSIX_MACHINE_THREADS_H
#define YUNIPOSIX_MACHINE_THREADS_H

#ifdef __cplusplus
extern "C" {
#endif
/* } */

/* Types */
//typedef int (*thrd_start_t)(void*);
//typedef void (*tss_dtor_t)(void*);
typedef void* cnd_t;
typedef void* mtx_t;
typedef void* once_flag;
typedef void* thrd_t; /* = pthread_t (but not interchangeable) */
typedef void* tss_t;

/* { */

#ifdef __cplusplus
};
#endif

#endif
