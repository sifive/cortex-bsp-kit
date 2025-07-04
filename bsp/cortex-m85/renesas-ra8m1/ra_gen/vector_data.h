/* generated vector header file - do not edit */
#ifndef VECTOR_DATA_H
#define VECTOR_DATA_H
#ifdef __cplusplus
        extern "C" {
        #endif
/* Number of interrupts allocated */
#ifndef VECTOR_DATA_IRQ_COUNT
#define VECTOR_DATA_IRQ_COUNT    (1)
#endif
/* ISR prototypes */
void baremetal_doc_isr(void);

/* Vector table allocations */
#define VECTOR_NUMBER_DOC_INT ((IRQn_Type) 0) /* DOC INT (Data operation circuit interrupt) */
#define DOC_INT_IRQn          ((IRQn_Type) 0) /* DOC INT (Data operation circuit interrupt) */
/* The number of entries required for the ICU vector table. */
#define BSP_ICU_VECTOR_NUM_ENTRIES (1)

#ifdef __cplusplus
        }
        #endif
#endif /* VECTOR_DATA_H */
