;Please remember to make it a branch first

O_RDONLY    equ 0
O_WRONLY    equ 1

section .text
    global _start

_start:
    call _askforfunction
    call _listfunctions
    call _getresponse
    call _checkresponse
    
    mov rax, 60
    syscall

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

_checkresponse:
    mov rsi, [answer]
    sub rsi, '0'
    mov rbx, '1'
    sub rbx, '0'
    cmp rsi, rbx
    je _searchfile

    mov rbx, '2'
    sub rbx, '0'
    cmp rsi, rbx
    je _getinfo

    mov rbx, '3'
    sub rbx, '0'
    cmp rsi, rbx
    je _listcontacts

    call _invalidinput

    ret

_invalidinput:
    mov rax, 1
    mov rdi, 1
    mov rsi, invalidmessage
    mov rdx, leninvalidmessage
    syscall

    ret

_listcontacts:
    call _openfileforreading
    call _readfile
    call _closefilereadonly
    
    mov rax, 1
    mov rdi, 1
    mov rsi, datalog
    mov rdx, 1000
    syscall
    
    ret

_getinfo:
    call _getname
    call _getnum
    call _savetofile
    
    ret

_getname:
    mov rax, 0
    mov rdi, 0
    mov rsi, name
    mov rdx, 50
    syscall

    ret

_getnum:
    mov rax, 0
    mov rdi, 0
    mov rsi, number
    mov rdx, 50
    syscall

    ret

_savetofile:
    call _openfileforwriting
    
    mov rsi, name
    mov rdx, 50
    call _writetofile
    
    mov rsi, number
    mov rdx, 15
    call _writetofile
    
    call _closefilewriteonly
    
    ret

_openfileforreading:
    mov rax, 2
    mov rdi, filename
    mov rsi, O_RDONLY
    mov rdx, 0777
    syscall
    
    mov [fd_in], rax
    
    ret
    
_openfileforwriting:
    mov rax, 2
    mov rdi, filename
    mov rsi, O_WRONLY
    mov rdx, 0777
    syscall
    
    mov [fd_out], rax
    
    ret

_readfile:
    mov rax, 0
    mov rdi, 0
    mov rsi, datalog
    mov rdx, 1000
    syscall
    
    ret

_searchfile:
    call _openfileforreading
    call _readfile
    call _closefilereadonly
    
    ret

_closefilereadonly:
    mov rax, 3
    mov rdi, [fd_in]
    syscall
    
    ret
    
_closefilewriteonly:
    mov rax, 3
    mov rdi, [fd_out]
    syscall
    
    ret

_writetofile:
    mov rax, 1
    mov rdi, 1
    syscall
    
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

    filename db 'contacts.txt'

segment .bss
    answer resb 1
    
    name resb 50
    number resb 15
    
    datalog resb 1000
    
    fd_in resb 1
    fd_out resb 1
