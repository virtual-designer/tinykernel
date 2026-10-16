#ifndef KERNEL_REGIONS_H
#define KERNEL_REGIONS_H

#include "stddef.h"
#include "stdint.h"

extern const uint8_t __KERNEL_LOAD_PHY_ADDR_START_SYM;
extern const uint8_t __KERNEL_LOAD_VIRT_ADDR_START_SYM;
extern const uint8_t __KERNEL_LOAD_VIRT_ADDR_END_SYM;
extern const uint8_t __KERNEL_LOAD_RUNTIME_SIZE_SYM;
__attribute__ ((unused)) static const uint8_t *__KERNEL_LOAD_PHY_ADDR_START
    = &__KERNEL_LOAD_PHY_ADDR_START_SYM;
__attribute__ ((unused)) static const uint8_t *__KERNEL_LOAD_VIRT_ADDR_START
    = &__KERNEL_LOAD_VIRT_ADDR_START_SYM;
__attribute__ ((unused)) static const uint8_t *__KERNEL_LOAD_VIRT_ADDR_END
    = &__KERNEL_LOAD_VIRT_ADDR_END_SYM;
__attribute__ ((unused)) static const size_t __KERNEL_LOAD_RUNTIME_SIZE
    = (size_t) (void *) &__KERNEL_LOAD_RUNTIME_SIZE_SYM;

#endif /* KERNEL_REGIONS_H */
