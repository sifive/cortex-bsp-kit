# BSP Library for Renesas RA8M1
# This is a component library that will be used by the main project

# Source files for the BSP library
set(BSP_SOURCES
    src/baremetal_ep.c
    src/hal_entry.c
    src/SEGGER_RTT/SEGGER_RTT.c
    src/SEGGER_RTT/SEGGER_RTT_printf.c
    ra_gen/common_data.c
    ra_gen/hal_data.c
    ra_gen/main.c
    ra_gen/pin_data.c
    ra_gen/vector_data.c
    ra/fsp/src/r_ioport/r_ioport.c
    ra/fsp/src/bsp/mcu/all/bsp_clocks.c
    ra/fsp/src/bsp/mcu/all/bsp_common.c
    ra/fsp/src/bsp/mcu/all/bsp_delay.c
    ra/fsp/src/bsp/mcu/all/bsp_group_irq.c
    ra/fsp/src/bsp/mcu/all/bsp_guard.c
    ra/fsp/src/bsp/mcu/all/bsp_io.c
    ra/fsp/src/bsp/mcu/all/bsp_irq.c
    ra/fsp/src/bsp/mcu/all/bsp_macl.c
    ra/fsp/src/bsp/mcu/all/bsp_register_protection.c
    ra/fsp/src/bsp/mcu/all/bsp_rom_registers.c
    ra/fsp/src/bsp/mcu/all/bsp_sbrk.c
    ra/fsp/src/bsp/mcu/all/bsp_sdram.c
    ra/fsp/src/bsp/mcu/all/bsp_security.c
    ra/fsp/src/bsp/cmsis/Device/RENESAS/Source/startup.c
    ra/fsp/src/bsp/cmsis/Device/RENESAS/Source/system.c
    ra/board/ra8m1_ek/board_init.c
    ra/board/ra8m1_ek/board_leds.c
)

add_library(renesas-ra8m1 STATIC ${BSP_SOURCES})

set_target_properties(renesas-ra8m1 PROPERTIES
    OUTPUT_NAME "renesas-ra8m1"
    ARCHIVE_OUTPUT_NAME "renesas-ra8m1"
    PREFIX "lib"
    C_STANDARD 99
    C_STANDARD_REQUIRED ON
)

target_include_directories(renesas-ra8m1 PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}/src
    ${CMAKE_CURRENT_SOURCE_DIR}/ra/fsp/inc
    ${CMAKE_CURRENT_SOURCE_DIR}/ra/fsp/inc/api
    ${CMAKE_CURRENT_SOURCE_DIR}/ra/fsp/inc/instances
    ${CMAKE_CURRENT_SOURCE_DIR}/ra_gen
    ${CMAKE_CURRENT_SOURCE_DIR}/ra_cfg/fsp_cfg/bsp
    ${CMAKE_CURRENT_SOURCE_DIR}/ra_cfg/fsp_cfg
    ${CMAKE_CURRENT_SOURCE_DIR}/ra/arm/CMSIS_6/CMSIS/Core/Include
) 
