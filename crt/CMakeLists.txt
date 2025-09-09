cmake_minimum_required(VERSION 3.20)
project(warp_crt)

function(calc_objname out src)
    cmake_path(SET srcpath NORMALIZE ${src})
    cmake_path(GET srcpath FILENAME fn)
    cmake_path(REPLACE_EXTENSION fn .o)
    cmake_path(APPEND CMAKE_CURRENT_BINARY_DIR "${fn}"
        OUTPUT_VARIABLE tmp)
    set(${out} "${tmp}" PARENT_SCOPE)
endfunction()

function(compile_crtfile src)
    calc_objname(obj ${src})
    message(STATUS "Compile ${src} => ${obj}")
    add_custom_command(COMMAND
        ${CMAKE_C_COMPILER} 
        --target=wasm32 -fPIC -nostdinc
        -Wall -Werror
        -O2 -g -o ${obj} 
        -c
        "${src}"
        DEPENDS ${src}
        OUTPUT ${obj}
    )
endfunction()

set(srcs
    ${CMAKE_CURRENT_LIST_DIR}/warpcrt_exec.c)

set(objs)
foreach(s IN LISTS srcs)
    calc_objname(obj ${s})
    compile_crtfile(${s})
    list(APPEND objs ${obj})
endforeach()

add_custom_target(crtobjs ALL DEPENDS ${objs})

install(FILES ${objs}
    DESTINATION lib
)
