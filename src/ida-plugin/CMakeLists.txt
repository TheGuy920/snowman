set(MOC_HEADERS
    DecompilerPlugin.h
    NavigationHelper.h
)

set(SOURCES
    DecompilerPlugin.cpp
    IdaByteSource.cpp
    IdaByteSource.h
    IdaDemangler.cpp
    IdaDemangler.h
    IdaFrontend.cpp
    IdaFrontend.h
    NavigationHelper.cpp
    ${MOC_HEADERS}
)

include_directories(${IDA_INCLUDE_DIR})
add_definitions(${IDA_DEFINITIONS})

if(MSVC)
    # IDA uses functions that MSVC considers unsafe.
    add_definitions(${IDA_DEFINITIONS} -D_CRT_SECURE_NO_WARNINGS)
endif()

if(${CMAKE_CXX_COMPILER_ID} MATCHES "GNU")
    # Kill warnings in intel.hpp
    add_definitions(-Wno-parentheses)
endif()

if(${CMAKE_CXX_COMPILER_ID} MATCHES "Clang")
    # Kill numerous warnings.
    add_definitions(-Wno-ignored-attributes -Wno-format-security -Wno-logical-op-parentheses)
endif()

qt5_wrap_cpp(SOURCES ${MOC_HEADERS})

add_library(ida-plugin SHARED ${SOURCES})
target_link_libraries(ida-plugin nc nc-gui ${Boost_LIBRARIES} ${NC_QT_CORE} ${NC_QT_WIDGETS} ${IDA_LIBRARIES})
set_target_properties(ida-plugin PROPERTIES OUTPUT_NAME "snowman" PREFIX "" SUFFIX "${IDA_PLUGIN_EXT}")
install(TARGETS ida-plugin RUNTIME DESTINATION bin LIBRARY DESTINATION lib)
