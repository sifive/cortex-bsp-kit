#------------------------------------------------------------------------------
# SiFive Nitro CMake integration
#
# Copyright (c) 2023-2024 SiFive, Inc. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
#------------------------------------------------------------------------------

# Common include directories
set(COMMON_INCLUDE_DIRS
    support
    examples/riscv32/ri5cyverilator)

set(DEFAULT_CPU_MHZ 1)
if(DEFINED CPU_MHZ)
    set(TARGET_CPU_MHZ ${CPU_MHZ})
else()
    set(TARGET_CPU_MHZ ${DEFAULT_CPU_MHZ})
endif()

set(DEFAULT_WARMUP_HEAT 1)
if(DEFINED WARMUP_HEAT)
    set(TARGET_WARMUP_HEAT ${WARMUP_HEAT})
else()
    set(TARGET_WARMUP_HEAT ${DEFAULT_WARMUP_HEAT})
endif()

# Common source files
set(COMMON_SRCS
    support/beebsc.c
    support/main.c
    examples/riscv32/ri5cyverilator/boardsupport.c)

set(TARGETS
    aha-mont64
    crc32
    depthconv
    edn
    huffbench
    matmult-int
    md5sum
    nettle-aes
    nettle-sha256
    nsichneu
    picojpeg
    qrduino
    sglib-combined
    slre
    statemate
    tarfind
    ud
    wikisort
    xgboost
    dummy-benchmark)

# Define mont64-specific source files
set(aha-mont64_SRCS
    src/aha-mont64/mont64.c)

set(crc32_SRCS
    src/crc32/crc_32.c)

set(depthconv_SRCS
    src/depthconv/depthconv.c)

set(edn_SRCS
    src/edn/libedn.c)

set(huffbench_SRCS
    src/huffbench/libhuffbench.c)

set(matmult-int_SRCS
    src/matmult-int/matmult-int.c)

set(md5sum_SRCS
    src/md5sum/md5.c)

set(nettle-aes_SRCS
    src/nettle-aes/nettle-aes.c)

set(nettle-sha256_SRCS
    src/nettle-sha256/nettle-sha256.c)

set(nsichneu_SRCS
    src/nsichneu/libnsichneu.c)

set(picojpeg_SRCS
    src/picojpeg/libpicojpeg.c
    src/picojpeg/picojpeg_test.c)

set(qrduino_SRCS
    src/qrduino/qrencode.c
    src/qrduino/qrframe.c
    src/qrduino/qrtest.c)

set(sglib-combined_SRCS
    src/sglib-combined/combined.c)

set(slre_SRCS
    src/slre/libslre.c)

set(statemate_SRCS
    src/statemate/libstatemate.c)

set(tarfind_SRCS
    src/tarfind/tarfind.c)

set(ud_SRCS
    src/ud/libud.c)

set(wikisort_SRCS
    src/wikisort/libwikisort.c)

set(xgboost_SRCS
    src/xgboost/xgboost.c
    src/xgboost/testbench.c)

set(dummy-benchmark_SRCS
    support/dummy-benchmark/dummy.c)

set(picojpeg_INCLUDE_DIRS
    src/picojpeg)

set(qrduino_INCLUDE_DIRS
    src/qrduino)

set(sglib-combined_INCLUDE_DIRS
    src/sglib-combined)

set(slre_INCLUDE_DIRS
    src/slre)

set(xgboost_INCLUDE_DIRS
    src/xgboost)

# Use foreach loop to deal with each target
foreach(target ${TARGETS})
    # Set target-specific source files and include directories
    set(TARGET_SRCS ${${target}_SRCS})
    if(DEFINED ${${target}_INCLUDE_DIRS})
        set(TARGET_INCLUDE_DIRS ${${target}_INCLUDE_DIRS})
    endif()

    # Add executable for the target
    if(DEFINED ${TARGET_INCLUDE_DIRS})
      add_benchmark(TARGET_NAME ${target} SOURCE_FILES ${TARGET_SRCS} ${COMMON_SRCS} INCLUDE_FOLDERS ${TARGET_INCLUDE_DIRS} ${COMMON_INCLUDE_DIRS})
    else()
      add_benchmark(TARGET_NAME ${target} SOURCE_FILES ${TARGET_SRCS} ${COMMON_SRCS} INCLUDE_FOLDERS ${COMMON_INCLUDE_DIRS})
    endif()

    # Set compile definitions for the target
    target_compile_definitions(${target}
        PRIVATE CPU_MHZ=${TARGET_CPU_MHZ}
        WARMUP_HEAT=${TARGET_WARMUP_HEAT}
        GLOBAL_SCALE_FACTOR=${TARGET_CPU_MHZ})
endforeach()

set(ALL_BENCHMARK_TARGETS ${TARGETS} PARENT_SCOPE)
