/* Copyright (C) 2017 Embecosm Limited and University of Bristol

   Contributor Graham Markall <graham.markall@embecosm.com>

   This file is part of Embench and was formerly part of the Bristol/Embecosm
   Embedded Benchmark Suite.

   SPDX-License-Identifier: GPL-3.0-or-later */

#include <support.h>
#include "riscv.h"

void
initialise_board ()
{

}

processor_t __attribute__ ((noinline)) __attribute__ ((externally_visible))
start_trigger ()
{
  processor_t mcycle = riscv_read_mcycle();
  return mcycle;
}

processor_t __attribute__ ((noinline)) __attribute__ ((externally_visible))
stop_trigger ()
{
  processor_t mcycle = riscv_read_mcycle();
  return mcycle;
}
