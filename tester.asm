bits 64

extern print_newline
extern print_char
extern print_string
extern exit
extern print_uint
extern print_int
extern read_char
extern read_word

section .data
message: db "String works, hihi >:3", 10, 0

section .bss
output_buffer: resb 12

section .text
global _start
_start:
    mov rbx, 0
    mov byte[output_buffer+rbx], 12
    lea rdi, output_buffer
    mov rsi, 12
    call read_word
    lea rdi, output_buffer
    call print_string
    call print_newline

    xor rdi, rdi
    call exit
