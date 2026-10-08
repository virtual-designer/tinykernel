#!/bin/sh

cat <<'EOF'
#include <kernel/utils/macros.s>

.code64
.text

.globl isr_cpu_entry_paths_begin
.align 8
isr_cpu_entry_paths_begin:

EOF

for int_num in $(seq 0 255); do
    cat <<EOF
.align 8
isr_cpu_entry_${int_num}:
    movl \$${int_num}, %eax
    jmp isr_main

EOF
done

cat <<'EOF'
.globl isr_cpu_entry_paths_end
isr_cpu_entry_paths_end:

.section .rodata, "a", @progbits
.globl isr_cpu_entry_path_list
.align 8
isr_cpu_entry_path_list:
EOF

for int_num in $(seq 0 255); do
    cat <<EOF
    .quad isr_cpu_entry_${int_num}
EOF
done
