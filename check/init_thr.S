.globl __warp__init_thr
.globl __warp__get_tls_size
.globl __warp__get_tls_align
.globaltype __stack_pointer, i32
.globaltype __tls_base, i32
.globaltype __tls_size, i32, immutable
.globaltype __tls_align, i32, immutable

__warp__init_thr:
  .functype __warp__init_thr (i32, i32) -> ()
  .export_name __warp__init_thr, __warp__init_thr
  local.get 0
  global.set __stack_pointer
  local.get 1
  global.set __tls_base
  end_function

__warp__get_tls_size:
  .functype __warp__get_tls_size () -> (i32)
  .export_name __warp__get_tls_size, __warp__get_tls_size
  global.get __tls_size
  return
  end_function

__warp__get_tls_align:
  .functype __warp__get_tls_align () -> (i32)
  .export_name __warp__get_tls_align, __warp__get_tls_align
  global.get __tls_align
  return
  end_function
