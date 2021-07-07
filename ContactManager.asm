O_RDONLY equ 0
O_WRONLY equ 1

section .text
%macro input 2
    mov rax, 0
    mov rdi, 0
    mov rsi, %1
    mov rdx, %2
    syscall
%endmacro
%macro output 3
    mov rax, 1
    mov rdi, %1
    mov rsi, %2
    mov rdx, %3
    syscall
%endmacro
%macro fileopen 2
    mov rax, 2
    mov rdi, %1
    mov rsi, %2
    mov rdx, 0777o
    syscall
%endmacro
%macro fileclose 1
    mov rax, 3
    mov rdi, %1
    syscall
%endmacro


    global _start

_start:
    call _askforfunction
    call _listfunctions
    call _getresponse
    call _checkresponse
    
_exit:
    mov rax, 60
    syscall


_askforfunction:
    output 1, querymessage, lenquerymessage
    ret

_listfunctions:
    output 1, firstoption, lenfirstoption
    output 1, secondoption, lensecondoption
    output 1, listcontacts, lenlistcontacts
    ret

_getresponse:
    input answer, 1
    ret

_checkresponse:
    mov rsi, [answer]
    sub rsi, '0'
    mov rbx, '1'
    sub rbx, '0'

    cmp rsi, rbx
    je _searchfile

    ;input option
    mov rbx, 2
    cmp rsi, rbx
    je _getinfo

    ;output list option
    mov rbx, 3
    cmp rsi, rbx
    je _listcontacts

    call _invalidinput
    ret

_invalidinput:
    output 1, invalidmessage, leninvalidmessage
    ret

_listcontacts:
    call _openfileforreading
    call _readfile
    call _closefilereadonly

    output 1, datalog, 1000
    ret

_getinfo:
    ;get name
    output 1, namequestion, lennamequestion
    input name, 50
    
    ;get number
    output 1, numberquestion, lennumberquestion
    input number, 50

    ;open file for writing
    fileopen [filename], O_WRONLY
    mov [fd_out], rax
    

    output [fd_out], name, 50
    output [fd_out], number, 50
    fileclose [fd_out]   
    ret

_openfileforreading:
    fileopen filename, O_RDONLY    
    mov [fd_in], rax
    
    ret
    
_openfileforwriting:
    fileopen filename, O_WRONLY
    mov [fd_out], rax

    ret

_readfile:
    input datalog, 1000
    ret

_searchfile:
    call _openfileforreading
    call _readfile
    call _closefilereadonly
    ret

_closefilereadonly:
    fileclose [fd_in]
    ret
    

section .data
    querymessage db 'What functionality are you looking for?', 10
    lenquerymessage equ $-querymessage

    firstoption db 'Enter 1 to Search Contact Book', 10
    lenfirstoption equ $-firstoption

    secondoption db 'Enter 2 to Insert Contact', 10
    lensecondoption equ $-secondoption

    listcontacts db 'Enter 3 to List all contacts', 10
    lenlistcontacts equ $-listcontacts

    invalidmessage db 'Your input is invalid', 10
    leninvalidmessage equ $-invalidmessage

    namequestion db 'Enter your name: '
    lennamequestion equ $-namequestion

    numberquestion db 'Enter your number: '
    lennumberquestion equ $-numberquestion

    filename db 'contacts.txt', 0
    lenfilename equ $-filename

    filename db 'contacts.txt'

segment .bss
    answer resb 2
    
    name resq 50
    number resb 15
    
    datalog resb 1000
    
    fd_in resb 1
    fd_out resb 1

