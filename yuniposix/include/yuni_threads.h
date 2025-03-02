/* UNUSED: Currently we use threads.h from picolibc */

#ifndef YUNIPOSIX_THREAD_H
#define YUNIPOSIX_THREAD_H

/* https://pubs.opengroup.org/onlinepubs/9799919799/basedefs/threads.h.html */

#ifdef __cplusplus
extern "C" {
#endif
/* } */

/* Types */
typedef int (*thrd_start_t)(void*);
typedef void (*tss_dtor_t)(void*);
typedef void* cnd_t;
typedef void* mtx_t;
typedef void* once_flag;
typedef void* thrd_t; /* = pthread_t (but not interchangeable) */
typedef void* tss_t;

/* Macros */
#define thread_local _Thread_local
#define TSS_DTOR_ITERATIONS (9999) /* FIXME: */
#define ONCE_FLAG_INIT (0)

/* Enums */
enum {
    mtx_plain = 0,
    mtx_recursive = 1,
    mtx_timed = 2
};

enum {
    thrd_busy = 1,
    thrd_error = 2,
    thrd_nomem = 3,
    thrd_success = 0,
    thrd_timeout = 4
};

/* call_once */
/* https://pubs.opengroup.org/onlinepubs/9799919799/functions/call_once.html */
void call_once(once_flag*, void (*)(void));


/* cnd: condition */
/* https://pubs.opengroup.org/onlinepubs/9799919799/functions/cnd_broadcast.html */
int cnd_broadcast(cnd_t*);
int cnd_signal(cnd_t*);

/* https://pubs.opengroup.org/onlinepubs/9799919799/functions/cnd_destroy.html */
void cnd_destroy(cnd_t*);
int cnd_init(cnd_t*);

/* https://pubs.opengroup.org/onlinepubs/9799919799/functions/cnd_timedwait.html */
int cnd_timedwait(cnd_t* restrict, mtx_t* restrict, 
                  const struct timespec* restrict);
int cnd_wait(cnd_t*, mtx_t*);

/* mtx: mutex */
/* https://pubs.opengroup.org/onlinepubs/9799919799/functions/mtx_destroy.html */
void mtx_destroy(mtx_t*);
int mtx_init(mtx_t*, int);

/* https://pubs.opengroup.org/onlinepubs/9799919799/functions/mtx_lock.html */
int mtx_lock(mtx_t*);
int mtx_timedlock(mtx_t* restrict, const struct timespec* restrict);
int mtx_trylock(mtx_t*);
int mtx_unlock(mtx_t*);

/* thrd: thread */
/* https://pubs.opengroup.org/onlinepubs/9799919799/functions/thrd_create.html */
int thrd_create(thrd_t*, thrd_start_t, void*);

/* https://pubs.opengroup.org/onlinepubs/9799919799/functions/thrd_current.html */
thrd_t thrd_current(void);

/* https://pubs.opengroup.org/onlinepubs/9799919799/functions/thrd_detach.html */
int thrd_detach(thrd_t);

/* https://pubs.opengroup.org/onlinepubs/9799919799/functions/thrd_equal.html */
int thrd_equal(thrd_t, thrd_t);

/* https://pubs.opengroup.org/onlinepubs/9799919799/functions/thrd_exit.html */
_Noreturn void thrd_exit(int);

/* https://pubs.opengroup.org/onlinepubs/9799919799/functions/thrd_join.html */
int thrd_join(thrd_t, int *);

/* https://pubs.opengroup.org/onlinepubs/9799919799/functions/thrd_sleep.html */
int thrd_sleep(const struct timespec*, struct timespec*);

/* https://pubs.opengroup.org/onlinepubs/9799919799/functions/thrd_yield.html */
void thrd_yield(void);

/* tss: thread-specific data */
/* https://pubs.opengroup.org/onlinepubs/9799919799/functions/tss_create.html */
int tss_create(tss_t*, tss_dtor_t);

/* https://pubs.opengroup.org/onlinepubs/9799919799/functions/tss_delete.html */
void tss_delete(tss_t);

/* https://pubs.opengroup.org/onlinepubs/9799919799/functions/tss_get.html */
void *tss_get(tss_t);
int tss_set(tss_t, void*);

/* { */

#ifdef __cplusplus
};
#endif

#endif
