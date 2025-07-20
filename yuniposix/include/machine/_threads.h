#ifndef YUNIPOSIX_MACHINE_THREADS_H
#define YUNIPOSIX_MACHINE_THREADS_H

#ifdef __cplusplus
extern "C" {
#endif
/* } */

/* Types */
//typedef int (*thrd_start_t)(void*);
//typedef void (*tss_dtor_t)(void*);

struct yuniwarp_cnd_s {
    void* obj[2];
};

struct yuniwarp_mtx_s {
    void* obj[2];
};

struct yuniwarp_once_flag_s {
    void* obj[2];
};

typedef struct yuniwarp_cnd_s cnd_t;
typedef struct yuniwarp_mtx_s mtx_t;
typedef struct yuniwarp_once_flag_s once_flag;
typedef void* thrd_t; /* = pthread_t (but not interchangeable) */
typedef void* tss_t;

/* { */

#ifdef __cplusplus
};
#endif

#endif
