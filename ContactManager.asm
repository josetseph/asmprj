;Branch file

section .text
    global _start

_start:
    call _askforfunction
    call _listfunctions
    call _getresponse

_askforfunction:
    mov rax, 1
    mov rdi, 1
    mov rsi, querymessage
    mov rdx, lenquerymessage
    syscall

    ret

_listfunctions:
    mov rax, 1
    mov rdi, 1
    mov rsi, firstoption
    mov rdx, lenfirstoption
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, secondoption
    mov rdx, lensecondoption
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, listcontacts 
    mov rdx, lenlistcontacts
    syscall

    ret

_getresponse:
    mov rax, 0
    mov rdi, 0
    mov rsi, answer
    mov rdx, 1

    ret

_listcontacts:

_getname:

_getnum:

_saveinput:

_getfile:

_openfile:

_readfile:

_searchfile:

_closefile:

_writetofile:

section .data
    querymessage db 'What functionality are you looking for?', 10
    lenquerymessage equ $-querymessage

    firstoption db 'Enter 1 to Search Contact Book', 10
    lenfirstoption equ $-firstoption

    secondoption db 'Enter 2 to Insert Contact', 10
    lensecondoption equ $-secondoption

    listcontacts db 'Enter 3 to List all contacts', 10
    lenlistcontacts equ $-listcontacts

segment .bss
    answer resb 1
