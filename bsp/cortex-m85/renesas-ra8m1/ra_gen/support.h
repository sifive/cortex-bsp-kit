#ifndef SUPPORT_H
#define SUPPORT_H

#define GLOBAL_SCALE_FACTOR 1
int verify_benchmark (int result);

int benchmark (void) __attribute__ ((noinline));

void start_trigger (void);

void stop_trigger (void);

/* Include beebsc.h for BEEBS functions */
#include "beebsc.h"

#endif /* SUPPORT_H */