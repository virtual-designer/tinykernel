#ifndef KERNEL_STDINT_H
#define KERNEL_STDINT_H

typedef char int8_t;
typedef unsigned char uint8_t;
typedef short int int16_t;
typedef unsigned short int uint16_t;
typedef int int32_t;
typedef unsigned int uint32_t;
typedef long long int int64_t;
typedef unsigned long long int uint64_t;

#define SIZE_MAX (~(SIZE_C (0)))
#define SIZE_MIN SIZE_C (0)
#define SIZE_C(c) ((size_t) c##UL)

#define UINT64_MAX (~UINT64_C (0))
#define UINT64_MIN UINT64_C (0)
#define UINT64_C(c) ((uint64_t) c##ULL)

#endif /* KERNEL_STDINT_H */
