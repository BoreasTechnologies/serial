function(buildInfo PREFIX)
    execute_process(COMMAND hostname OUTPUT_VARIABLE HOSTNAME)
    string(STRIP ${HOSTNAME} HOSTNAME)

    string(TIMESTAMP YEAR "%Y")
    string(TIMESTAMP BUILD_DATE_TIME "%Y-%m-%dT%H:%M:%SZ" UTC)

    set(${PREFIX}_BUILD_HOSTNAME  ${HOSTNAME} PARENT_SCOPE)
    set(${PREFIX}_BUILD_TIMESTAMP  ${BUILD_DATE_TIME} PARENT_SCOPE)
    set(${PREFIX}_BUILD_YEAR  ${YEAR} PARENT_SCOPE)
endfunction()



# Extract versions from GIT using the command: git describe --tags --long --dirty
#
# This function use the nearest tag number in the git history to uniquely identify the version built.
#
# The tag name must comply with the semantic versioning https://semver.org: Ex: 1.2.3.RC1
#
# Properties set by this function:
#
#  ${PREFIX}_VERSION_FULL    (ex: 1.2.3-RC1+6.b7a53a2-dirty)
#  ${PREFIX}_VERSION_SHORT   (ex: 1.2.3-RC1)
#  ${PREFIX}_VERSION_MAJOR   (ex: 1)
#  ${PREFIX}_VERSION_MINOR   (ex: 2)
#  ${PREFIX}_VERSION_PATCH   (ex: 3)
#  ${PREFIX}_VERSION_META    (ex: -RC1)
#  ${PREFIX}_VERSION_COMMIT  (ex: 6)
#  ${PREFIX}_VERSION_HASH    (ex: b7a53a2)
#  ${PREFIX}_VERSION_DIRTY   (ex: -dirty)
function(parseVersion PREFIX)
    execute_process(COMMAND git describe --tags --long --dirty WORKING_DIRECTORY  ${CMAKE_CURRENT_SOURCE_DIR} OUTPUT_VARIABLE GIT_VERSION )

    if(${GIT_VERSION} MATCHES "(([0-9]*)\.([0-9]*)\.([0-9]*)(.*))-([0-9]*)-g([0-9A-Fa-f]*)(-dirty)?")
        set(${PREFIX}_VERSION_SHORT  ${CMAKE_MATCH_1} PARENT_SCOPE)
        set(${PREFIX}_VERSION_MAJOR  ${CMAKE_MATCH_2} PARENT_SCOPE)
        set(${PREFIX}_VERSION_MINOR  ${CMAKE_MATCH_3} PARENT_SCOPE)
        set(${PREFIX}_VERSION_PATCH  ${CMAKE_MATCH_4} PARENT_SCOPE)
        set(${PREFIX}_VERSION_META   ${CMAKE_MATCH_5} PARENT_SCOPE)
        set(${PREFIX}_VERSION_COMMIT ${CMAKE_MATCH_6} PARENT_SCOPE)
        set(${PREFIX}_VERSION_HASH   ${CMAKE_MATCH_7} PARENT_SCOPE)
        set(${PREFIX}_VERSION_DIRTY  ${CMAKE_MATCH_8} PARENT_SCOPE)
        set(${PREFIX}_VERSION_FULL   ${CMAKE_MATCH_1}"+"${CMAKE_MATCH_6}"."${CMAKE_MATCH_7}${CMAKE_MATCH_8} PARENT_SCOPE)
    else()
        message(FATAL_ERROR "Invalid version ${GIT_VERSION}")
    endif()
endfunction()