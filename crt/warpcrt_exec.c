//int main(int ac, char** av, char** envp);
int main(int ac, char** av);
void __call_exitprocs(int, void*);
void __libc_init_array(void);

int __attribute__((export_name ("__start")))
__start(void){
    int r;
    __libc_init_array();

    r = main(0, 0);

    __call_exitprocs(r, 0);

    return r;
}
