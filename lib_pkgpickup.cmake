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

    set(bins0 "${bins}")
    foreach(e IN LISTS bins0)
        if(IS_SYMLINK "${e}")
            file(REAL_PATH "${e}" pth2)
            message(STATUS "Symlink tgt: ${pth2} <= ${e}")
            list(APPEND bins "${pth2}")
        endif()
    endforeach()

    list(REMOVE_DUPLICATES bins)

    # Copy files (Use COPY here; COPY_FILE cannot copy symlink)
    file(COPY ${bins} DESTINATION ${pkgdest}/bin
        USE_SOURCE_PERMISSIONS)

    foreach(d IN LISTS pkgdirs)
        cmake_path(SET d0 NORMALIZE ${d}/..)
        file(COPY ${pkgsrc}/${d} DESTINATION ${pkgdest}/${d0}
            USE_SOURCE_PERMISSIONS)
    endforeach()
endfunction()
