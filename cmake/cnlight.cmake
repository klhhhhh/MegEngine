find_library(
  CNLIGHT_LIBRARY
  NAMES libcnlight.so
  PATHS ${ALTER_LD_LIBRARY_PATHS} "$ENV{NEUWARE_HOME}/lib64" ${CMAKE_INSTALL_PREFIX}
  HINTS ${ALTER_LIBRARY_PATHS}
  PATH_SUFFIXES lib lib64
  DOC "CNLIGHT library.")

if(CNLIGHT_LIBRARY STREQUAL "CNLIGHT_LIBRARY-NOTFOUND")
  message(FATAL_ERROR "Can not find CNLIGHT Library")
endif()

get_filename_component(__found_cnlight_root "${CNLIGHT_LIBRARY}/../.." REALPATH)
find_path(
  CNLIGHT_INCLUDE_DIR
  NAMES cnlight.h
  HINTS "$ENV{NEUWARE_HOME}/include" ${__found_cnlight_root}
  PATH_SUFFIXES include
  DOC "Path to CNLIGHT include directory.")

if(CNLIGHT_INCLUDE_DIR STREQUAL "CNLIGHT_INCLUDE_DIR-NOTFOUND")
  message(FATAL_ERROR "Can not find CNLIGHT Library")
endif()

file(STRINGS "${CNLIGHT_INCLUDE_DIR}/cnlight.h" CNLIGHT_MAJOR
     REGEX "^#define CNLIGHT_MAJOR_VERSION [0-9]+.*$")
file(STRINGS "${CNLIGHT_INCLUDE_DIR}/cnlight.h" CNLIGHT_MINOR
     REGEX "^#define CNLIGHT_MINOR_VERSION [0-9]+.*$")
file(STRINGS "${CNLIGHT_INCLUDE_DIR}/cnlight.h" CNLIGHT_PATCH
     REGEX "^#define CNLIGHT_PATCH_VERSION [0-9]+.*$")

string(REGEX REPLACE "^#define CNLIGHT_MAJOR_VERSION ([0-9]+).*$" "\\1"
                     CNLIGHT_VERSION_MAJOR "${CNLIGHT_MAJOR}")
string(REGEX REPLACE "^#define CNLIGHT_MINOR_VERSION ([0-9]+).*$" "\\1"
                     CNLIGHT_VERSION_MINOR "${CNLIGHT_MINOR}")
string(REGEX REPLACE "^#define CNLIGHT_PATCH_VERSION ([0-9]+).*$" "\\1"
                     CNLIGHT_VERSION_PATCH "${CNLIGHT_PATCH}")
set(CNLIGHT_VERSION_STRING
    "${CNLIGHT_VERSION_MAJOR}.${CNLIGHT_VERSION_MINOR}.${CNLIGHT_VERSION_PATCH}")

add_library(libcnlight SHARED IMPORTED)

set_target_properties(
  libcnlight PROPERTIES IMPORTED_LOCATION ${CNLIGHT_LIBRARY}
                        INTERFACE_INCLUDE_DIRECTORIES ${CNLIGHT_INCLUDE_DIR})

message(
  STATUS
    "Found CNLIGHT: ${__found_cnlight_root} (found version: ${CNLIGHT_VERSION_STRING})")
