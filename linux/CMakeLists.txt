cmake_minimum_required(VERSION 3.10)
project(runner LANGUAGES CXX)

set(BINARY_NAME "sideswap")
set(APPLICATION_ID "io.sideswap")

cmake_policy(SET CMP0063 NEW)

set(CMAKE_INSTALL_RPATH "$ORIGIN/lib")

# Root filesystem for cross-building.
if(FLUTTER_TARGET_PLATFORM_SYSROOT)
  set(CMAKE_SYSROOT ${FLUTTER_TARGET_PLATFORM_SYSROOT})
  set(CMAKE_FIND_ROOT_PATH ${CMAKE_SYSROOT})
  set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
  set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)
  set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
  set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
endif()

# Configure build options.
if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
  set(CMAKE_BUILD_TYPE "Debug" CACHE
    STRING "Flutter build mode" FORCE)
  set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS
    "Debug" "Profile" "Release")
endif()

# Compilation settings that should be applied to most targets.
function(APPLY_STANDARD_SETTINGS TARGET)
  target_compile_features(${TARGET} PUBLIC cxx_std_14)
  target_compile_options(${TARGET} PRIVATE -Wall -Werror)
  target_compile_options(${TARGET} PRIVATE "$<$<NOT:$<CONFIG:Debug>>:-O3>")
  target_compile_definitions(${TARGET} PRIVATE "$<$<NOT:$<CONFIG:Debug>>:NDEBUG>")
endfunction()

set(FLUTTER_MANAGED_DIR "${CMAKE_CURRENT_SOURCE_DIR}/flutter")

# Flutter library and tool build rules.
add_subdirectory(${FLUTTER_MANAGED_DIR})

# System-level dependencies.
find_package(PkgConfig REQUIRED)
pkg_check_modules(GTK REQUIRED IMPORTED_TARGET gtk+-3.0)

add_definitions(-DAPPLICATION_ID="${APPLICATION_ID}")

# Application build
add_executable(${BINARY_NAME}
  "main.cc"
  "my_application.cc"
  "${FLUTTER_MANAGED_DIR}/generated_plugin_registrant.cc"
)
apply_standard_settings(${BINARY_NAME})
target_link_libraries(${BINARY_NAME} PRIVATE flutter)
target_link_libraries(${BINARY_NAME} PRIVATE PkgConfig::GTK)
add_dependencies(${BINARY_NAME} flutter_assemble)

# Only the install-generated bundle's copy of the executable will launch
# correctly, since the resources must in the right relative locations. To avoid
# people trying to run the unbundled copy, put it in a subdirectory instead of
# the default top-level location.
set_target_properties(${BINARY_NAME}
  PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/intermediates_do_not_run"
)

# Generated plugin build rules, which manage building the plugins and adding
# them to the application.
include(flutter/generated_plugins.cmake)


# === Installation ===
# By default, "installing" just makes a relocatable bundle in the build
# directory.
set(BUILD_BUNDLE_DIR "${PROJECT_BINARY_DIR}/bundle")
if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
  set(CMAKE_INSTALL_PREFIX "${BUILD_BUNDLE_DIR}" CACHE PATH "..." FORCE)
endif()

# Start with a clean build bundle directory every time.
install(CODE "
  file(REMOVE_RECURSE \"${BUILD_BUNDLE_DIR}/\")
  " COMPONENT Runtime)

set(INSTALL_BUNDLE_DATA_DIR "${CMAKE_INSTALL_PREFIX}/data")
set(INSTALL_BUNDLE_LIB_DIR "${CMAKE_INSTALL_PREFIX}/lib")

install(TARGETS ${BINARY_NAME} RUNTIME DESTINATION "${CMAKE_INSTALL_PREFIX}"
  COMPONENT Runtime)

install(FILES "${FLUTTER_ICU_DATA_FILE}" DESTINATION "${INSTALL_BUNDLE_DATA_DIR}"
  COMPONENT Runtime)

install(FILES "${FLUTTER_LIBRARY}" DESTINATION "${INSTALL_BUNDLE_LIB_DIR}"
  COMPONENT Runtime)

if(PLUGIN_BUNDLED_LIBRARIES)
  install(FILES "${PLUGIN_BUNDLED_LIBRARIES}"
    DESTINATION "${INSTALL_BUNDLE_LIB_DIR}"
    COMPONENT Runtime)
endif()

# Copy the rust client library into the bundle's lib/ directory.
#
# flutter run/build on Linux dlopen()s libsideswap_client.so by its bare
# name, resolved via the executable's $ORIGIN/lib rpath (set above), so the
# library must be present in INSTALL_BUNDLE_LIB_DIR for the app to start.
#
# The library is taken from the cargo target dir of the sideswap_rust
# checkout (SIDESWAP_RUST_DIR env var, or the sibling ../../sideswap_rust),
# or, for developers who do not build it themselves, from linux/lib/ (a
# manual drop location, gitignored - the Android jniLibs/ equivalent).
#
# A missing library is a warning, not an error: the app still builds (it
# will fail to start), and this must not break builds that provide the
# library some other way.
install(CODE "
  if(\"\$ENV{SIDESWAP_RUST_DIR}\" STREQUAL \"\")
    set(rust_root \"${CMAKE_CURRENT_SOURCE_DIR}/../../sideswap_rust\")
  else()
    set(rust_root \"\$ENV{SIDESWAP_RUST_DIR}\")
  endif()

  if(CMAKE_INSTALL_CONFIG_NAME)
    set(cargo_config \"\${CMAKE_INSTALL_CONFIG_NAME}\")
  else()
    set(cargo_config \"${CMAKE_BUILD_TYPE}\")
  endif()
  if(cargo_config STREQUAL \"Debug\")
    set(cargo_profile \"debug\")
  else()
    set(cargo_profile \"release\")
  endif()

  set(cargo_src \"\${rust_root}/target/\${cargo_profile}/libsideswap_client.so\")
  set(manual_src \"${CMAKE_CURRENT_SOURCE_DIR}/lib/libsideswap_client.so\")

  if(EXISTS \"\${cargo_src}\")
    set(client_src \"\${cargo_src}\")
  elseif(EXISTS \"\${manual_src}\")
    set(client_src \"\${manual_src}\")
  else()
    set(client_src \"\")
  endif()

  if(client_src STREQUAL \"\")
    message(WARNING \"libsideswap_client.so not found at \${cargo_src} nor at \${manual_src} - build it with 'cargo build -p sideswap_client' (add --release for a Profile or Release build) in the sideswap_rust checkout, or drop a prebuilt library into linux/lib/, or the app will fail on the login screen\")
  else()
    file(INSTALL \"\${client_src}\" DESTINATION \"${INSTALL_BUNDLE_LIB_DIR}\")
    message(STATUS \"Copied \${client_src} -> ${INSTALL_BUNDLE_LIB_DIR}\")
  endif()
  " COMPONENT Runtime)

# Fully re-copy the assets directory on each build to avoid having stale files
# from a previous install.
set(FLUTTER_ASSET_DIR_NAME "flutter_assets")
install(CODE "
  file(REMOVE_RECURSE \"${INSTALL_BUNDLE_DATA_DIR}/${FLUTTER_ASSET_DIR_NAME}\")
  " COMPONENT Runtime)
install(DIRECTORY "${PROJECT_BUILD_DIR}/${FLUTTER_ASSET_DIR_NAME}"
  DESTINATION "${INSTALL_BUNDLE_DATA_DIR}" COMPONENT Runtime)

# Install the AOT library on non-Debug builds only.
if(NOT CMAKE_BUILD_TYPE MATCHES "Debug")
  install(FILES "${AOT_LIBRARY}" DESTINATION "${INSTALL_BUNDLE_LIB_DIR}"
    COMPONENT Runtime)
endif()
