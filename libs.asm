bits 64

section .text

global exit
exit:
    mov rax, 60
    syscall

global string_length
string_length:
    xor rax, rax
.loop:
    cmp byte[rdi+rax], 0

    jz .end

    inc rax
    jmp .loop

.end:
    ret

global print_string
print_string: 
    mov rsi, rdi
    call string_length
    mov rdx, rax
    mov rax, 1
    mov rdi, 1
    syscall
    ret

global print_char
print_char:
    sub rsp, 8
    mov byte[rsp], dil 
    mov rax, 1
    mov rdi, 1
    mov rdx, 1
    mov rsi, rsp
    syscall
    add rsp, 8
    ret

global print_newline
print_newline:
    sub rsp, 8
    mov byte[rsp], 0xA
    mov rax, 1
    mov rdi, 1
    mov rdx, 1
    mov rsi, rsp
    syscall
    add rsp, 8
    ret

section .data

numbers: db "0123456789"

section .text

global print_uint
print_uint:
    sub rsp, 32
    mov rsi, rsp
    add rsi, 31
    mov byte[rsi], 0
    dec rsi
    
.loop:
    mov rax, rdi     ;div result 
    xor rdx, rdx    ;mod result
    mov rcx, 10     ;divider
    div rcx

    mov rcx, rdx    ;mod goes to shit
    mov rdi, rax     ;div back as number
    
    mov al, [numbers+rcx]
    mov [rsi], al 
  
    dec rsi
    
    cmp rdi, 0
    jz .end

    jmp .loop

.end:
    inc rsi
    mov rdi, rsi 
    call print_string
    add rsp, 32
    ret
