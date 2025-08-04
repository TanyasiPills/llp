bits 64

extern print_newline
extern print_char
extern print_string
extern exit
extern print_uint

section .data
message: db "Suck my balls, hihi >:3", 10, 0

section .text
global _start
_start:
    mov rdi, 'M'
    call print_char
    call print_newline
    lea rdi, [message]
    call print_string
    mov rdi, 0xF
    call print_uint

    xor rdi, rdi
    call exit
