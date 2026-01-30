function(detectprofile)
    set(native_profile 
        ${CMAKE_CURRENT_LIST_DIR}/_localbuild/conan2work/native.profile)
    execute_process(COMMAND
        conan detect profile --out-file 
        ${native_profile}
        RESULT_VARIABLE rr)
    if(rr)
        message(FATAL_ERROR "Failed to detect profile")
    endif()
endfunction()

function(genpkg name version srcdir)
    set(template ${CMAKE_CURRENT_LIST_DIR}/packaging/localbuild/conanfile.py)
    set(outjson ${CMAKE_CURRENT_BINARY_DIR}/_localbuild/${name}.json)
    set(profile ${CMAKE_CURRENT_LIST_DIR}/packaging/localbuild/warp.profile)
    set(trashdir ${CMAKE_CURRENT_LIST_DIR}/_localbuild/conan2work/${name})
    file(GLOB_RECURSE lis RELATIVE ${srcdir} 
        ${srcdir}/* ${srcdir}/*.*)
    # {
    #   "name": "${name}",
    #   "version": "${version}",
    #   "files": [
    #     "FILENAME",
    #     "FILENAME"
    #   ]
    # }
    file(WRITE "${outjson}" "{\n  \"name\": \"${name}\",\n  \"version\": \"${version}\",\n  \"files\": [\n    ")
    set(SEP_IN ",\n    ")
    set(SEP_END "\n    \]\n}\n")
    list(POP_BACK lis last)
    set(acc)
    foreach(e IN LISTS lis)
        list(APPEND acc "\"${e}\"")
        list(APPEND acc "${SEP_IN}")
    endforeach()
    list(APPEND acc "\"${last}\"")
    list(APPEND acc "${SEP_END}")
    list(JOIN acc "" rest)
    file(APPEND "${outjson}" "${rest}")

    set(ENV{WARPPKG_SRCDIR} "${srcdir}")
    set(ENV{WARPPKG_PARAMS} "${outjson}")

    execute_process(COMMAND
        conan export-pkg 
        -nr ${template}
        -pr ${profile}
        --output-folder ${trashdir}
        RESULT_VARIABLE rr
    )
    if(rr)
        message(FATAL_ERROR "Failed to build package(${name})")
    endif()

endfunction()
