cmake_minimum_required(VERSION 3.16)

# Project name
project(cortex_bsp_kit)

# Set C standard
set(CMAKE_C_STANDARD 99)
set(CMAKE_C_STANDARD_REQUIRED ON)

# Set build type if not specified
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Release)
endif()

# Allow user to specify which BSP and Benchmark to use
set(BSP "" CACHE STRING "Select BSP (e.g. cortex-m85/renesas-ra8m1)")
set(BENCHMARK "" CACHE STRING "Select Benchmark (e.g. embench-2.0)")
set(BENCHMARK_TARGET "" CACHE STRING "Select Benchmark Target (e.g. aha-mont64). Leave empty to build all targets.")

if(NOT BSP)
    message(FATAL_ERROR "Please set BSP, e.g. -DBSP=cortex-m85/renesas-ra8m1")
endif()
if(NOT BENCHMARK)
    message(FATAL_ERROR "Please set BENCHMARK, e.g. -DBENCHMARK=embench-2.0")
endif()

# Set BSP target name based on BSP selection
# Extract the last part of BSP path as the target name
string(REPLACE "/" ";" BSP_PARTS ${BSP})
list(GET BSP_PARTS -1 BSP_TARGET)
message(STATUS "BSP target name: ${BSP_TARGET}")

# Include the AddBenchmark macro
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
include(AddBenchmark)

# Toolchain settings for ARM Cortex-M85
set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR ARM)

# Specify the cross compiler
set(CMAKE_C_COMPILER arm-none-eabi-gcc)
set(CMAKE_OBJCOPY arm-none-eabi-objcopy)
set(CMAKE_SIZE arm-none-eabi-size)

# Global compiler flags
set(CMAKE_C_FLAGS "-mcpu=cortex-m85 -mthumb -mfloat-abi=hard -march=armv8.1-m.main+mve.fp+fp.dp")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -O2 -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wunused -Wuninitialized -Wall -Wextra -Wmissing-declarations")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wconversion -Wpointer-arith -Wshadow -Wlogical-op -Waggregate-return")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wfloat-equal -g -gdwarf-4")

# Global linker flags
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_C_FLAGS}")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -Xlinker --gc-sections")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} --specs=nano.specs --specs=rdimon.specs")

# Global preprocessor definitions
add_compile_definitions(
    _RENESAS_RA_
    _RA_CORE=CM85
    _RA_ORDINAL=1
    GLOBAL_SCALE_FACTOR=1
)

# Print project configuration
message(STATUS "Project: ${PROJECT_NAME}")
message(STATUS "Build type: ${CMAKE_BUILD_TYPE}")
message(STATUS "C compiler: ${CMAKE_C_COMPILER}")
message(STATUS "C standard: ${CMAKE_C_STANDARD}")
message(STATUS "Selected BSP: ${BSP}")
message(STATUS "Selected Benchmark: ${BENCHMARK}")
if(BENCHMARK_TARGET)
    message(STATUS "Selected Benchmark Target: ${BENCHMARK_TARGET}")
else()
    message(STATUS "Selected Benchmark Target: ALL (will build all available targets)")
endif()

# Add the selected BSP and Benchmark subdirectories
add_subdirectory(bsp/${BSP})
add_subdirectory(benchmark/${BENCHMARK})

# Function to create executable for a benchmark target
function(create_benchmark_executable TARGET_NAME)
    # Create the final executable that links BSP and benchmark
    add_executable(${TARGET_NAME}_with_bsp.elf
        ${CMAKE_CURRENT_SOURCE_DIR}/bsp/${BSP}/src/baremetal_ep.c
    )

    # Set C standard for the executable
    set_target_properties(${TARGET_NAME}_with_bsp.elf PROPERTIES
        C_STANDARD 99
        C_STANDARD_REQUIRED ON
    )

    # Link with BSP and benchmark libraries
    target_link_libraries(${TARGET_NAME}_with_bsp.elf
        ${BSP_TARGET}
        ${TARGET_NAME}
    )

    # Set linker script
    set_target_properties(${TARGET_NAME}_with_bsp.elf PROPERTIES
        LINK_FLAGS "-T ${CMAKE_CURRENT_SOURCE_DIR}/bsp/${BSP}/script/fsp.ld -L ${CMAKE_CURRENT_SOURCE_DIR}/bsp/${BSP}/script"
    )

    # Add custom target for hex file
    add_custom_target(${TARGET_NAME}_hex
        COMMAND ${CMAKE_OBJCOPY} -O ihex $<TARGET_FILE:${TARGET_NAME}_with_bsp.elf> ${TARGET_NAME}_with_bsp.hex
        DEPENDS ${TARGET_NAME}_with_bsp.elf
        COMMENT "Generating HEX file for ${TARGET_NAME}"
    )

    # Add custom target for size report
    add_custom_target(${TARGET_NAME}_size
        COMMAND ${CMAKE_SIZE} --format=berkeley $<TARGET_FILE:${TARGET_NAME}_with_bsp.elf> > ${TARGET_NAME}_with_bsp.siz
        DEPENDS ${TARGET_NAME}_with_bsp.elf
        COMMENT "Generating size report for ${TARGET_NAME}"
    )

    # Add custom target for all outputs
    add_custom_target(${TARGET_NAME}_all
        DEPENDS ${TARGET_NAME}_with_bsp.elf ${TARGET_NAME}_hex ${TARGET_NAME}_size
        COMMENT "Building all outputs for ${TARGET_NAME}"
    )

    # Add to global list for build_all target
    list(APPEND ALL_BENCHMARK_EXECUTABLES ${TARGET_NAME}_all)
    set(ALL_BENCHMARK_EXECUTABLES ${ALL_BENCHMARK_EXECUTABLES} PARENT_SCOPE)
endfunction()

# Initialize list for all benchmark executables
set(ALL_BENCHMARK_EXECUTABLES "")

# If specific target is specified, create executable for it
if(BENCHMARK_TARGET)
    create_benchmark_executable(${BENCHMARK_TARGET})
else()
    # Get all available benchmark targets from the benchmark directory
    # This will be populated by the benchmark CMakeLists.txt
    set(ALL_BENCHMARK_TARGETS "" CACHE INTERNAL "All available benchmark targets")
    
    # Create executables for all available targets
    # This will be called from the benchmark subdirectory
    message(STATUS "Will create executables for all available benchmark targets")
endif()

# Add custom target to build all benchmark executables
add_custom_target(build_all_benchmarks
    DEPENDS ${ALL_BENCHMARK_EXECUTABLES}
    COMMENT "Building all benchmark executables"
)

# Add custom target to list available targets
if(BENCHMARK_TARGET)
    set(BENCHMARK_TARGETS_MSG "  ${BENCHMARK_TARGET} - Build benchmark library")
    set(FINAL_EXECUTABLES_MSG "  ${BENCHMARK_TARGET}_with_bsp.elf - Final executable\n  ${BENCHMARK_TARGET}_hex - Generate hex file\n  ${BENCHMARK_TARGET}_size - Generate size report\n  ${BENCHMARK_TARGET}_all - Build all outputs")
else()
    set(BENCHMARK_TARGETS_MSG "  [Multiple] - All available benchmark libraries")
    set(FINAL_EXECUTABLES_MSG "  build_all_benchmarks - Build all benchmark executables\n  [Multiple] - Individual targets: <target>_with_bsp.elf, <target>_hex, <target>_size, <target>_all")
endif()

add_custom_target(list_targets
    COMMAND ${CMAKE_COMMAND} -E echo "=== Cortex BSP Kit - Available Targets ==="
    COMMAND ${CMAKE_COMMAND} -E echo ""
    COMMAND ${CMAKE_COMMAND} -E echo "BSP Targets:"
    COMMAND ${CMAKE_COMMAND} -E echo "  ${BSP_TARGET} - Build BSP library"
    COMMAND ${CMAKE_COMMAND} -E echo ""
    COMMAND ${CMAKE_COMMAND} -E echo "Benchmark Targets:"
    COMMAND ${CMAKE_COMMAND} -E echo "${BENCHMARK_TARGETS_MSG}"
    COMMAND ${CMAKE_COMMAND} -E echo ""
    COMMAND ${CMAKE_COMMAND} -E echo "Final Executable Targets:"
    COMMAND ${CMAKE_COMMAND} -E echo "${FINAL_EXECUTABLES_MSG}"
    COMMENT "Listing available targets"
)

# Set default target
set_property(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} PROPERTY DEFAULT_TARGET list_targets)
