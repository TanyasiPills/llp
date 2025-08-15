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

int_root:
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
    ret

global print_uint
print_uint:
    sub rsp, 32
    mov rsi, rsp
    add rsi, 31
    mov byte[rsi], 0
    dec rsi
    
    call int_root

    mov rdi, rsi 
    call print_string 

    add rsp, 32
    ret

global print_int
print_int:
    sub rsp, 32
    mov rsi, rsp
    add rsi, 31
    mov byte[rsi], 0
    dec rsi

    mov r8, rdi
    cmp rdi, 0
    jge .process
    neg rdi

.process:
    call int_root

    cmp r8, 0
    jge .end
    dec rsi
    mov byte[rsi], '-'
    
.end:
    mov rdi, rsi
    call print_string

    add rsp, 32
    ret

section .bss

char_buffer: resb 1 
word_buffer: resb 256

section .text

global read_char
read_char:
    mov rax, 0
    mov rdi, 0
    mov rsi, char_buffer
    mov rdx, 1
    syscall

    cmp byte[char_buffer], 0x0A
    jz .enter

    movzx rax, byte[char_buffer]
.enter:
    ret

global read_word
read_word:
    xor rbx, rbx 
    mov r9, rdi
    dec rsi
    mov r8, rsi
    mov rax, 0
    mov rdi, 0
    mov rsi, word_buffer
    mov rdx, 256
    syscall

.loop:
    mov al, [word_buffer+rbx]

    cmp al, 0x0A
    je .end

    mov byte[r9+rbx], al
    
    inc rbx 
    cmp rbx, r8
    jae .end

    jmp .loop

.end:
    mov byte[r9+rbx], 0
    ret 

global parse_uint
parse_uint:
    xor rax, rax
    mov rbx, 10

.loop:
    movzx rcx, byte[rdi]
    cmp rcx, 0
    je .end

    cmp rcx, '0'
    jb .end

    cmp rcx, '9'
    ja .end

    sub rcx, '0'
    mul rbx
    add rax, rcx

    inc rdi
    jmp .loop

.end:
    ret 

global parse_int
parse_int:
    xor rax, rax
    xor r8, r8 ;is negative
    mov rbx, 10
    xor rsi, rsi
.loop:
    movzx rcx, byte[rdi]
    cmp rcx, 0
    je .end
    
    cmp rcx, '-'
    je .negative
    
    cmp rcx, '0'
    jl .end

    cmp rcx, '9'
    jg .end

    sub rcx, '0'
    imul rbx
    add rax, rcx

    inc rdi
    inc rsi
    jmp .loop

.negative:
    cmp rsi, 0
    jne .bad
    
    mov r8, 1
    inc rdi
    inc rsi
    jmp .loop

.bad:
    mov rax, 0

.end:
    cmp r8, 0
    je .endEnd

    neg rax

.endEnd:
    ret

global string_equals
string_equals:
    mov rax, 1
    xor r8, r8
    xor r9, r9 ;if 1 needs to check ending
.loop:
    cmp byte[rdi+r8], 0
    jne .loop_c
    cmp byte[rsi+r8], 0
    jne .loop_c

    mov r9, 1

.loop_c:
    mov cl, byte[rdi+r8]
    cmp cl, byte[rsi+r8]
    jne .bad

    cmp r9, 0
    jne .loop
    jmp .end

.bad:
    mov rax, 0

.end:
    ret
