/* generated main source file - do not edit */
#include "hal_data.h"
#include "support.h"

int main(void)
{
    hal_entry ();

    int i;
    volatile int result;
    int correct;

    //start_trigger ();
    result = benchmark ();
    //stop_trigger ();

    /* bmarks that use arrays will check a global array rather than int result */
    correct = verify_benchmark (result);

    return (!correct);
}
