bits 64

extern print_newline
extern print_char
extern print_string
extern exit
extern print_uint
extern print_int
extern read_char

section .data
message: db "String works, hihi >:3", 10, 0

section .text
global _start
_start:
    lea rdi, [message]
    call print_string
    call read_char
    mov rdi, rax
    call print_char
    call print_newline

    xor rdi, rdi
    call exit
