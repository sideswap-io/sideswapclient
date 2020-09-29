cmake_minimum_required(VERSION 3.0)

if(APPLE)
    set(PROJECT_NAME SideSwap)
elseif (WIN32)
    set(PROJECT_NAME SideSwap)
else ()
    set(PROJECT_NAME sideswap)
endif()
project(${PROJECT_NAME})

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

find_package(Qt5 COMPONENTS Core Widgets Quick Qml Gui REQUIRED)

option(STATIC_QT_BUILD "Use static Qt build" OFF)

if (STATIC_QT_BUILD)
    set(SOURCES cpp/qt_plugins.cpp)
endif()

set(SOURCES
    ${SOURCES}
    cpp/main.cpp
    cpp/addressverificationhelper.cpp
    cpp/clipboardhelper.cpp
    cpp/client_rs_lib.cpp
    cpp/main.cpp
    cpp/netmanager.cpp
    cpp/settingshelper.cpp
    resources.qrc
)

if (APPLE)
    set( BUNDLE_NAME ${PROJECT_NAME} )
    set( MACOSX_BUNDLE_BUNDLE_NAME ${BUNDLE_NAME} )
    set( MACOSX_BUNDLE_GUI_IDENTIFIER "com.sideswap" )
    set( MACOSX_BUNDLE_BUNDLE_VERSION "0.1.0")
    set( MACOSX_BUNDLE_SHORT_VERSION_STRING ${MACOSX_BUNDLE_BUNDLE_VERSION})
    set( MACOSX_BUNDLE_LONG_VERSION_STRING ${MACOSX_BUNDLE_BUNDLE_VERSION})

    set( MACOSX_BUNDLE_ICON_FILE "app_icon.icns" )

    set(LOGO_ICNS_FILE "${CMAKE_CURRENT_SOURCE_DIR}/deploy_assets/app_icon.icns")
    set_source_files_properties( ${LOGO_ICNS_FILE} PROPERTIES MACOSX_PACKAGE_LOCATION Resources)
    add_executable( ${PROJECT_NAME} MACOSX_BUNDLE ${SOURCES} ${LOGO_ICNS_FILE} )
    set_target_properties( ${PROJECT_NAME} PROPERTIES OUTPUT_NAME "${BUNDLE_NAME}" )
elseif (WIN32)
    add_executable(${PROJECT_NAME} WIN32
        ${SOURCES}
        deploy_assets/sideswap.rc
    )
else()
    add_executable(${PROJECT_NAME} ${SOURCES})
endif()



set_target_properties(${PROJECT_NAME} PROPERTIES CXX_STANDARD 17 CXX_STANDARD_REQUIRED ON)

include(ExternalProject)

if(CMAKE_BUILD_TYPE STREQUAL "Release")
    set(CARGO_BUILD_FLAG "--release")
    set(CARGO_BUILD_TYPE "release")
else()
    set(CARGO_BUILD_FLAG "")
    set(CARGO_BUILD_TYPE "debug")
endif()
if (WIN32)
    set(CARGO_BUILD_OUTPUT "${CMAKE_SOURCE_DIR}/rust/target/${CARGO_BUILD_TYPE}/sideswap_client.lib")
else()
    set(CARGO_BUILD_OUTPUT "${CMAKE_SOURCE_DIR}/rust/target/${CARGO_BUILD_TYPE}/libsideswap_client.a")
endif()

ExternalProject_Add(
    client_rs
    BINARY_DIR "${CMAKE_SOURCE_DIR}/rust"
    DOWNLOAD_COMMAND ""
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    COMMAND cargo build ${CARGO_BUILD_FLAG}
    INSTALL_COMMAND ""
    BUILD_ALWAYS 1
    LOG_BUILD ON
    BUILD_BYPRODUCTS ${CARGO_BUILD_OUTPUT}
)
add_dependencies(${PROJECT_NAME} client_rs)

target_include_directories(${PROJECT_NAME}
    PRIVATE ${CMAKE_SOURCE_DIR}/cpp
    PRIVATE ${CMAKE_BINARY_DIR}
)

get_filename_component(QT_ROOT_DIR "${Qt5_DIR}/../../.." ABSOLUTE)

if (WIN32)
    target_link_libraries(${PROJECT_NAME}
        ${CARGO_BUILD_OUTPUT}
        Qt5::Widgets
        Qt5::Qml
        ws2_32
        userenv
        crypt32
        secur32
        ncrypt
    )
elseif(APPLE)
    target_link_libraries(${PROJECT_NAME}
        ${CARGO_BUILD_OUTPUT}
        Qt5::Widgets
        Qt5::Qml
        "-framework CoreFoundation"
        "-framework Security"
    )
else ()
    if (STATIC_QT_BUILD)
        set(STATIC_QT_PLUGINS
            ${QT_ROOT_DIR}/qml/QtQuick/Controls.2/libqtquickcontrols2plugin.a
            ${QT_ROOT_DIR}/qml/QtQuick.2/libqtquick2plugin.a
            ${QT_ROOT_DIR}/qml/QtQuick/Layouts/libqquicklayoutsplugin.a
            ${QT_ROOT_DIR}/qml/Qt/labs/platform/libqtlabsplatformplugin.a
            ${QT_ROOT_DIR}/qml/QtQuick/Window.2/libwindowplugin.a
            ${QT_ROOT_DIR}/qml/QtGraphicalEffects/libqtgraphicaleffectsplugin.a
            ${QT_ROOT_DIR}/qml/QtQuick/Templates.2/libqtquicktemplates2plugin.a
            ${QT_ROOT_DIR}/qml/QtGraphicalEffects/private/libqtgraphicaleffectsprivate.a
            ${QT_ROOT_DIR}/qml/Qt/labs/qmlmodels/liblabsmodelsplugin.a
            ${QT_ROOT_DIR}/lib/libQt5QuickControls2.a
            ${QT_ROOT_DIR}/lib/libQt5QuickTemplates2.a
            ${QT_ROOT_DIR}/lib/libQt5QmlWorkerScript.a
            ${QT_ROOT_DIR}/lib/libQt5QuickTemplates2.a

            Qt5::QXcbIntegrationPlugin
        )
    endif()

    target_link_libraries(${PROJECT_NAME}
        ${CARGO_BUILD_OUTPUT}
        ${STATIC_QT_PLUGINS}
        Qt5::Quick
        Qt5::Qml
        Qt5::Widgets
        Qt5::Core
        pthread
        dl
    )

endif()

add_custom_command(
    OUTPUT client_rs_gen.h client_rs_gen.cpp
    DEPENDS rust/sideswap_client/src/ffi.rs
    COMMAND cxxbridge --header ${CMAKE_SOURCE_DIR}/rust/sideswap_client/src/ffi.rs > ${CMAKE_BINARY_DIR}/client_rs_gen.h
    COMMAND cxxbridge ${CMAKE_SOURCE_DIR}/rust/sideswap_client/src/ffi.rs > ${CMAKE_BINARY_DIR}/client_rs_gen.cpp
    COMMAND cxxbridge --header > ${CMAKE_BINARY_DIR}/cxx.h
)

add_custom_target(client_rs_cxx DEPENDS ${CMAKE_BINARY_DIR}/client_rs_gen.cpp ${CMAKE_BINARY_DIR}/client_rs_gen.cpp)

add_dependencies(${PROJECT_NAME} client_rs_cxx)
