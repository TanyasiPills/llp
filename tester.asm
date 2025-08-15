bits 64

extern print_newline
extern print_char
extern print_string
extern exit
extern print_uint
extern print_int
extern read_char
extern read_word
extern parse_uint
extern parse_int
extern string_equals

section .data
message: db "String works, hihi >:3", 10, 0
message2: db "String works, hihi >:3", 10, 0

section .bss
global output_buffer
output_buffer: resb 12

section .text
global _start
_start:
    mov rdi, message
    mov rsi, message2
    call string_equals  
    
    mov rdi, rax
    call print_uint

    xor rdi, rdi
    call exit
