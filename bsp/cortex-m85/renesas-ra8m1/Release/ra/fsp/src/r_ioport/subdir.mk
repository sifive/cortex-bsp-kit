################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../ra/fsp/src/r_ioport/r_ioport.c 

C_DEPS += \
./ra/fsp/src/r_ioport/r_ioport.d 

OBJS += \
./ra/fsp/src/r_ioport/r_ioport.o 

SREC += \
baremetal_ek_ra8m1_ep.srec 

MAP += \
baremetal_ek_ra8m1_ep.map 


# Each subdirectory must supply rules for building sources it contributes
ra/fsp/src/r_ioport/%.o: ../ra/fsp/src/r_ioport/%.c
	$(file > $@.in,-mthumb -mfloat-abi=hard -march=armv8.1-m.main+mve.fp+fp.dp -O2 -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections -Wunused -Wuninitialized -Wall -Wextra -Wmissing-declarations -Wconversion -Wpointer-arith -Wshadow -Wlogical-op -Waggregate-return -Wfloat-equal -g -gdwarf-4 -D_RENESAS_RA_ -D_RA_CORE=CM85 -D_RA_ORDINAL=1 -I"D:/Downloads/r20an0715eu0119-ek-ra8m1-exampleprojects/ek_ra8m1/baremetal/baremetal_ek_ra8m1_ep/e2studio/src" -I"D:/Downloads/r20an0715eu0119-ek-ra8m1-exampleprojects/ek_ra8m1/baremetal/baremetal_ek_ra8m1_ep/e2studio/ra/fsp/inc" -I"D:/Downloads/r20an0715eu0119-ek-ra8m1-exampleprojects/ek_ra8m1/baremetal/baremetal_ek_ra8m1_ep/e2studio/ra/fsp/inc/api" -I"D:/Downloads/r20an0715eu0119-ek-ra8m1-exampleprojects/ek_ra8m1/baremetal/baremetal_ek_ra8m1_ep/e2studio/ra/fsp/inc/instances" -I"D:/Downloads/r20an0715eu0119-ek-ra8m1-exampleprojects/ek_ra8m1/baremetal/baremetal_ek_ra8m1_ep/e2studio/ra_gen" -I"D:/Downloads/r20an0715eu0119-ek-ra8m1-exampleprojects/ek_ra8m1/baremetal/baremetal_ek_ra8m1_ep/e2studio/ra_cfg/fsp_cfg/bsp" -I"D:/Downloads/r20an0715eu0119-ek-ra8m1-exampleprojects/ek_ra8m1/baremetal/baremetal_ek_ra8m1_ep/e2studio/ra_cfg/fsp_cfg" -I"." -I"D:/Downloads/r20an0715eu0119-ek-ra8m1-exampleprojects/ek_ra8m1/baremetal/baremetal_ek_ra8m1_ep/e2studio/ra/arm/CMSIS_6/CMSIS/Core/Include" -std=c99 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" -c -o "$@" -x c "$<")
	@echo Building file: $< && arm-none-eabi-gcc @"$@.in"

