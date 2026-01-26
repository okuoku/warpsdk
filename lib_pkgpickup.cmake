function(runpickup prefix)
    set(pkgsrc "${${prefix}_pickup_src}")
    set(pkgdest "${${prefix}_pickup_dest}")
    set(pkgdirs "${${prefix}_pickup_dirs}")
    set(binnames "${${prefix}_pickup_bin}")

    if(WIN32)
        set(exe ".exe")
    else()
        set(exe "")
    endif()

    set(bins)
    foreach(e IN LISTS binnames)
        cmake_path(SET pth NORMALIZE "${pkgsrc}/bin/${e}${exe}")
        list(APPEND bins "${pth}")
    endforeach()

    # Pass1: Detect symlink and follow targets
    set(bins0 "${bins}")
    foreach(e IN LISTS bins0)
        if(IS_SYMLINK "${e}")
            file(REAL_PATH "${e}" pth2)
            message(STATUS "Symlink tgt: ${pth2} <= ${e}")
            list(APPEND bins "${pth2}")
        endif()
    endforeach()

    list(REMOVE_DUPLICATES bins)

    # Pass2: Split list into EXEC/Symlink
    set(execs)
    set(symlinks)
    foreach(e IN LISTS bins)
        if(IS_SYMLINK "${e}")
            list(APPEND symlinks "${e}")
        else()
            list(APPEND execs "${e}")
        endif()
    endforeach()

    # Strip executables FIXME: Save debug info somewhere
    foreach(e IN LISTS execs)
        if(WIN32)
            # MSVC already uses split-debuginfo
            file(COPY ${e} DESTINATION ${pkgdest}/bin
                USE_SOURCE_PERMISSIONS)
        else()
            cmake_path(GET e FILENAME fn)
            cmake_path(SET out NORMALIZE ${pkgdest}/bin/${fn})
            file(MAKE_DIRECTORY ${pkgdest}/bin)
            message(STATUS "Strip ${e} => ${out}")
            execute_process(COMMAND
                strip -o ${out} ${e}
                RESULT_VARIABLE rr)
            if(rr)
                message(FATAL_ERROR "Failed to strip ${e} (${rr})")
            endif()
        endif()
    endforeach()
    # Copy symlinks (Use COPY here; COPY_FILE cannot copy symlink)
    file(COPY ${symlinks} DESTINATION ${pkgdest}/bin
        USE_SOURCE_PERMISSIONS)

    foreach(d IN LISTS pkgdirs)
        cmake_path(SET d0 NORMALIZE ${d}/..)
        file(COPY ${pkgsrc}/${d} DESTINATION ${pkgdest}/${d0}
            USE_SOURCE_PERMISSIONS)
    endforeach()
endfunction()
