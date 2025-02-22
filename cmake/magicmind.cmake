find_library(
  MAGICMIND_LIBRARY
  NAMES libmagicmind.so
  PATHS ${ALTER_LD_LIBRARY_PATHS} "$ENV{NEUWARE_HOME}/lib64" ${CMAKE_INSTALL_PREFIX}
  HINTS ${ALTER_LIBRARY_PATHS}
  PATH_SUFFIXES lib lib64
  DOC "MAGICMIND library.")

if(MAGICMIND_LIBRARY STREQUAL "MAGICMIND_LIBRARY-NOTFOUND")
  message(FATAL_ERROR "Can not find MAGICMIND Library")
endif()

get_filename_component(__found_magicmind_root "${MAGICMIND_LIBRARY}/../../" REALPATH)
find_path(
  MAGICMIND_INCLUDE_DIR
  NAMES common.h
  HINTS "$ENV{NEUWARE_HOME}/include" ${__found_magicmind_root}
  PATH_SUFFIXES include
  DOC "Path to MAGICMIND include directory.")

if(MAGICMIND_INCLUDE_DIR STREQUAL "MAGICMIND_INCLUDE_DIR-NOTFOUND")
  message(FATAL_ERROR "Can not find MAGICMIND Library")
endif()

file(STRINGS "${MAGICMIND_INCLUDE_DIR}/common.h" MAGICMIND_MAJOR
     REGEX "^#define MM_MAJOR_VERSION [0-9]+.*$")
file(STRINGS "${MAGICMIND_INCLUDE_DIR}/common.h" MAGICMIND_MINOR
     REGEX "^#define MM_MINOR_VERSION [0-9]+.*$")
file(STRINGS "${MAGICMIND_INCLUDE_DIR}/common.h" MAGICMIND_PATCH
     REGEX "^#define MM_PATCH_VERSION [0-9]+.*$")

string(REGEX REPLACE "^#define MM_MAJOR_VERSION ([0-9]+).*$" "\\1"
                     MAGICMIND_VERSION_MAJOR "${MAGICMIND_MAJOR}")
string(REGEX REPLACE "^#define MM_MINOR_VERSION ([0-9]+).*$" "\\1"
                     MAGICMIND_VERSION_MINOR "${MAGICMIND_MINOR}")
string(REGEX REPLACE "^#define MM_PATCH_VERSION ([0-9]+).*$" "\\1"
                     MAGICMIND_VERSION_PATCH "${MAGICMIND_PATCH}")
set(MAGICMIND_VERSION_STRING
    "${MAGICMIND_VERSION_MAJOR}.${MAGICMIND_VERSION_MINOR}.${MAGICMIND_VERSION_PATCH}")

add_library(libmagicmind SHARED IMPORTED)

set_target_properties(
  libmagicmind PROPERTIES IMPORTED_LOCATION ${MAGICMIND_LIBRARY}
                          INTERFACE_INCLUDE_DIRECTORIES ${MAGICMIND_INCLUDE_DIR})

message(
  STATUS
    "Found MAGICMIND: ${__found_magicmind_root} (found version: ${MAGICMIND_VERSION_STRING})"
)

find_library(
  MAGICMIND_RUNTIME_LIBRARY
  NAMES libmagicmind_runtime.so
  PATHS "${__found_magicmind_root}/lib64")

if(MAGICMIND_RUNTIME_LIBRARY STREQUAL "MAGICMIND_RUNTIME_LIBRARY-NOTFOUND")
  message(FATAL_ERROR "Can not find MAGICMIND_RUNTIME Library")
else()
  message(STATUS "Found MAGICMIND_RUNTIME: ${MAGICMIND_RUNTIME_LIBRARY}")
endif()
add_library(libmagicmind_runtime SHARED IMPORTED)
set_target_properties(libmagicmind_runtime PROPERTIES IMPORTED_LOCATION
                                                      ${MAGICMIND_RUNTIME_LIBRARY})
