# AddBenchmark.cmake
# Macro to create benchmark libraries that can be linked with BSP library
# Usage: add_benchmark(TARGET_NAME <name> SOURCE_FILES <files> INCLUDE_FOLDERS <folders>)

macro(add_benchmark)
    set(options)
    set(oneValueArgs TARGET_NAME)
    set(multiValueArgs SOURCE_FILES INCLUDE_FOLDERS)
    cmake_parse_arguments(ADD_BENCHMARK "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    # Create library instead of executable
    add_library(${ADD_BENCHMARK_TARGET_NAME} STATIC ${ADD_BENCHMARK_SOURCE_FILES})
    
    # Set include directories if provided
    if(ADD_BENCHMARK_INCLUDE_FOLDERS)
        target_include_directories(${ADD_BENCHMARK_TARGET_NAME} PUBLIC ${ADD_BENCHMARK_INCLUDE_FOLDERS})
    endif()
    
    # Set C standard
    set_target_properties(${ADD_BENCHMARK_TARGET_NAME} PROPERTIES
        C_STANDARD 99
        C_STANDARD_REQUIRED ON
    )
    
    message(STATUS "Created benchmark library: ${ADD_BENCHMARK_TARGET_NAME}")
endmacro()
