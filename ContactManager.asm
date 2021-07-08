section .text

;macro to get input
%macro input 2
    mov rax, 0
    mov rdi, 0
    mov rsi, %1
    mov rdx, %2
    syscall
%endmacro

;macro to output to screen
%macro print 2
    mov rax, 1
    mov rdi, 1
    mov rsi, %1
    mov rdx, %2
    syscall
%endmacro

    global _start

_start:
    call _askforfunction
    call _listfunctions
    call _getresponse
    call _checkresponse

    jmp _exit

_exit:
    mov rax, 60
    syscall

_askforfunction:
    print querymessage, lenquerymessage

    ret

_listfunctions:
    print firstoption, lenfirstoption

    print secondoption, lensecondoption

    print listcontacts, lenlistcontacts

    ret

_getresponse:
    input answer, 1

    ret

;Remember to Convert comparison statements to macros
_checkresponse:
    mov rcx, [answer]
    sub rcx, 0x30

    mov rbx, '1'
    sub rbx, 0x30
    cmp rcx, rbx
    je _searchfile

    mov rbx, '2'
    sub rbx, 0x30
    cmp rcx, rbx
    je _getinfo

    mov rbx, '3'
    sub rbx, 0x30
    cmp rcx, rbx
    je _listcontacts

    jmp _invalidinput

    ret

_invalidinput:
    print invalidmesage, leninvalidmessage

    jmp _exit

_listcontacts:
    call _openfileforreading
    call _readfile
    call _closefilereadonly

    print dataloge, 1000

    jmp _exit

_getinfo:
    print getinfoprompt, lengetinfoprompt

    input name, 75
    input name, 75

    call _savetofile

    jmp _exit

_savetofile:
    call _openfileforwriting

    mov rax, name
    call _writetofile

    call _closefilewriteonly

    jmp _exit

_openfileforreading:
    mov rax, 2
    mov rdi, filename
    mov rsi, 0x0
    mov rdx, 0777o
    syscall

    mov [fd_in], rax

    ret

_openfileforwriting:
    mov rax, 2
    mov rdi, filename
    mov rsi, 0x441
    mov rdx, 0777o
    syscall

    mov [fd_out], rax

    ret

_readfile:
    mov rax, 0
    mov rdi, [fd_in]
    mov rsi, dataloge
    mov rdx, 1000
    syscall

    ret

_searchfile:
    call _openfileforreading
    call _readfile
    call _closefilereadonly

    jmp _exit

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
    push rax
    mov rbx, 0

    _printloop:
	inc rax
	inc rbx
	mov cl, [rax]
	cmp cl, 0
	jne _printloop

	mov rax, 1
	mov rdi, [fd_out]
	mov rdx, rbx
	pop rsi
	syscall

    ret

section .data
    querymessage db 'What functionality are you looking for?', 10
    lenquerymessage equ $-querymessage

    firstoption db 'Enter 1 to Search Contact Book.', 10
    lenfirstoption equ $-firstoption

    secondoption db 'Enter 2 to Insert Contact.', 10
    lensecondoption equ $-secondoption

    listcontacts db 'Enter 3 to List all contacts.', 10
    lenlistcontacts equ $-listcontacts

    getinfoprompt db 'Type name, a space, then the number.', 10
    lengetinfoprompt equ $-getinfoprompt

    invalidmessage db 'Your input is invalid', 10
    leninvalidmessage equ $-invalidmessage

    filename db 'contacts.txt', 0

    endchar db '', 10, 0
    lenendchar equ $-endchar

segment .bss
    answer resb 1
    name resb 75
    fd_in resb 1
    fd_out resb 1
    dataloge rest 1000
