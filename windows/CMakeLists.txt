cmake_minimum_required(VERSION 3.14)
project(sideswap LANGUAGES CXX)

set(BINARY_NAME "sideswap")

cmake_policy(SET CMP0063 NEW)

set(CMAKE_INSTALL_RPATH "$ORIGIN/lib")

# Configure build options.
get_property(IS_MULTICONFIG GLOBAL PROPERTY GENERATOR_IS_MULTI_CONFIG)
if(IS_MULTICONFIG)
  set(CMAKE_CONFIGURATION_TYPES "Debug;Profile;Release"
    CACHE STRING "" FORCE)
else()
  if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
    set(CMAKE_BUILD_TYPE "Debug" CACHE
      STRING "Flutter build mode" FORCE)
    set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS
      "Debug" "Profile" "Release")
  endif()
endif()

set(CMAKE_EXE_LINKER_FLAGS_PROFILE "${CMAKE_EXE_LINKER_FLAGS_RELEASE}")
set(CMAKE_SHARED_LINKER_FLAGS_PROFILE "${CMAKE_SHARED_LINKER_FLAGS_RELEASE}")
set(CMAKE_C_FLAGS_PROFILE "${CMAKE_C_FLAGS_RELEASE}")
set(CMAKE_CXX_FLAGS_PROFILE "${CMAKE_CXX_FLAGS_RELEASE}")

# Use Unicode for all projects.
add_definitions(-DUNICODE -D_UNICODE)

# Compilation settings that should be applied to most targets.
function(APPLY_STANDARD_SETTINGS TARGET)
  target_compile_features(${TARGET} PUBLIC cxx_std_17)
  target_compile_options(${TARGET} PRIVATE /W4 /WX /wd"4100")
  target_compile_options(${TARGET} PRIVATE /EHsc)
  target_compile_definitions(${TARGET} PRIVATE "_HAS_EXCEPTIONS=0")
  target_compile_definitions(${TARGET} PRIVATE "$<$<CONFIG:Debug>:_DEBUG>")
endfunction()

set(FLUTTER_MANAGED_DIR "${CMAKE_CURRENT_SOURCE_DIR}/flutter")

# Flutter library and tool build rules.
add_subdirectory(${FLUTTER_MANAGED_DIR})

# Application build
add_subdirectory("runner")

# Generated plugin build rules, which manage building the plugins and adding
# them to the application.
include(flutter/generated_plugins.cmake)


# === Installation ===
# Support files are copied into place next to the executable, so that it can
# run in place. This is done instead of making a separate bundle (as on Linux)
# so that building and running from within Visual Studio will work.
set(BUILD_BUNDLE_DIR "$<TARGET_FILE_DIR:${BINARY_NAME}>")
# Make the "install" step default, as it's required to run.
set(CMAKE_VS_INCLUDE_INSTALL_TO_DEFAULT_BUILD 1)
if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
  set(CMAKE_INSTALL_PREFIX "${BUILD_BUNDLE_DIR}" CACHE PATH "..." FORCE)
endif()

set(INSTALL_BUNDLE_DATA_DIR "${CMAKE_INSTALL_PREFIX}/data")
set(INSTALL_BUNDLE_LIB_DIR "${CMAKE_INSTALL_PREFIX}")

install(TARGETS ${BINARY_NAME} RUNTIME DESTINATION "${CMAKE_INSTALL_PREFIX}"
  COMPONENT Runtime)

# Copy sideswap_client.dll (and the MinGW runtime DLLs sitting beside it) next
# to the runner executable, so `flutter build windows` / `flutter run -d
# windows` produce a working exe without a manual copy step. The library is
# taken from the cargo target dir of the sideswap_rust checkout, or, for
# developers who do not build it themselves, from windows/lib/ (a manual drop
# location, gitignored - the Android jniLibs/ equivalent).
#
# This block is declared before the engine and plugin installs below, so a
# drop directory that also holds flutter_windows.dll or a plugin DLL cannot
# overwrite the versions this build produced.
#
# A missing library is a warning, not an error: the app builds without it (it
# will fail to start), and builds that provide the DLL some other way must
# keep working. Everything below is resolved at install time, not configure
# time, because the Visual Studio generator is multi-config, so
# CMAKE_BUILD_TYPE is empty when this file is configured.
install(CODE "
  if(\"\${CMAKE_INSTALL_CONFIG_NAME}\" STREQUAL \"Debug\")
    set(cargo_profile \"debug\")
  else()
    set(cargo_profile \"release\")
  endif()
  if(DEFINED ENV{SIDESWAP_RUST_DIR} AND NOT \"\$ENV{SIDESWAP_RUST_DIR}\" STREQUAL \"\")
    set(rust_root \"\$ENV{SIDESWAP_RUST_DIR}\")
  else()
    set(rust_root \"${CMAKE_CURRENT_SOURCE_DIR}/../../sideswap_rust\")
  endif()
  set(cargo_src_dir \"\${rust_root}/target/\${cargo_profile}\")
  set(manual_src_dir \"${CMAKE_CURRENT_SOURCE_DIR}/lib\")
  if(EXISTS \"\${cargo_src_dir}/sideswap_client.dll\")
    set(src_dir \"\${cargo_src_dir}\")
  elseif(EXISTS \"\${manual_src_dir}/sideswap_client.dll\")
    set(src_dir \"\${manual_src_dir}\")
  else()
    set(src_dir \"\")
  endif()
  if(src_dir)
    file(GLOB dlls \"\${src_dir}/*.dll\")
    file(COPY \${dlls} DESTINATION \"${INSTALL_BUNDLE_LIB_DIR}\")
    message(STATUS \"Copied DLLs from \${src_dir} to ${INSTALL_BUNDLE_LIB_DIR}\")
  else()
    message(WARNING \"sideswap_client.dll not found at \${cargo_src_dir}/sideswap_client.dll nor at \${manual_src_dir}/sideswap_client.dll - run the 'Sideswap: cargo sideswap_client (desktop)' task for a Debug build, or 'cargo build -p sideswap_client --release' in the sideswap_rust checkout, or drop a prebuilt DLL into windows/lib/, or the app will fail on the login screen\")
  endif()
  " COMPONENT Runtime)

install(FILES "${FLUTTER_ICU_DATA_FILE}" DESTINATION "${INSTALL_BUNDLE_DATA_DIR}"
  COMPONENT Runtime)

install(FILES "${FLUTTER_LIBRARY}" DESTINATION "${INSTALL_BUNDLE_LIB_DIR}"
  COMPONENT Runtime)

if(PLUGIN_BUNDLED_LIBRARIES)
  install(FILES "${PLUGIN_BUNDLED_LIBRARIES}"
    DESTINATION "${INSTALL_BUNDLE_LIB_DIR}"
    COMPONENT Runtime)
endif()

# Fully re-copy the assets directory on each build to avoid having stale files
# from a previous install.
set(FLUTTER_ASSET_DIR_NAME "flutter_assets")
install(CODE "
  file(REMOVE_RECURSE \"${INSTALL_BUNDLE_DATA_DIR}/${FLUTTER_ASSET_DIR_NAME}\")
  " COMPONENT Runtime)
install(DIRECTORY "${PROJECT_BUILD_DIR}/${FLUTTER_ASSET_DIR_NAME}"
  DESTINATION "${INSTALL_BUNDLE_DATA_DIR}" COMPONENT Runtime)

# Install the AOT library on non-Debug builds only.
install(FILES "${AOT_LIBRARY}" DESTINATION "${INSTALL_BUNDLE_DATA_DIR}"
  CONFIGURATIONS Profile;Release
  COMPONENT Runtime)
