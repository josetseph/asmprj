section .text

%macro input 2
    mov rax, 0
    mov rdi, 0
    mov rsi, %1
    mov rdx, %2
    syscall
%endmacro

%macro print 2
    mov rax, 1
    mov rdi, 1
    mov rsi, %1
    mov rdx, %2
    syscall
%endmacro

%macro compareans 2
    mov rbx, %1
    sub rbx, 0x30
    cmp rcx, rbx
    je %2
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

_checkresponse:
    mov rcx, [answer]
    sub rcx, 0x30

    compareans '1', _searchfile

    compareans '2', _getinfo

    compareans '3', _listcontacts

    jmp _invalidinput

    ret

_invalidinput:
    print invalidmessage, leninvalidmessage

    jmp _exit
    ;call _getresponse
    ;jmp _checkresponse

_listcontacts:
    call _openfileforreading
    call _readfile
    call _closefilereadonly

    mov rax, 1
    mov rdi, 1
    mov rsi, dataloge
    mov rdx, 1000
    syscall

    jmp _exit

_getinfo:
    print getinfoprompt, lengetinfoprompt
    print cases, lencases

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

    print searchinfo, lensearchinfo
    print cases, lencases

    input name, 75
    input name, 75
    ;mov rbx, name
    mov rbx, dataloge
    mov rdi, 0
    ;mov rsi, 0
    dec rbx
    ;dec rcx

    jmp loop

loop:
    inc rbx
    inc rdi
    mov rcx, name ;inc rcx
    mov al, [rbx]
    mov ah, [rcx]
    cmp al, ah
    je loop2

    cmp al, 0
    je _notfound

    ;mov rsi, 0
    jmp loop

loop2:
    inc rbx
    inc rcx
    inc rdi
    mov al, [rbx]
    mov ah, [rcx]
    cmp al, ah
    jne loop3

    jmp loop2

loop3:
    inc rcx
    mov ah, [rcx]
    cmp ah, 0
    je _setprint

    ;inc rsi
    jmp loop

_setprint:
    dec rbx
    dec rcx
    dec rdi
    ;mov [rdnum], rdi
    mov al, [rbx]
    mov ah, [rcx]
    cmp al, ah
    je _setprint

    mov rbx, dataloge
    jmp _printcontact

_printcontact:
    inc rbx
    dec rdi
    cmp rdi, 0
    jne _printcontact

    loop4:
	dec rbx
	mov al, [rbx]
	cmp al, '-'
	jne loop4
	inc rbx
	inc rbx
    loop1:
	print rbx, 1
        inc rbx
	mov al, [rbx]
	cmp al, '-'
	je _exit
	cmp al, 0
	je _exit

	jmp loop1

    jmp _exit

;_checkthis:
    ;mov rbx, dataloge
    ;mov rdi, [rdnum]
    ;loopnext:
	;inc rbx
        ;dec rdi
	;cmp rdi, 0
	;jne loopnext

	;jmp loop

_notfound:
    print notfound, lennotfound

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
	mov rdx, 2
	mov rsi, breaker
	syscall

	mov rax, 1
	mov rdi, [fd_out]
	mov rdx, rbx
	pop rsi
	syscall

	;mov rax, 1
	;mov rdi, [fd_out]
	;mov rdx, 2
	;mov rsi, breaker
	;syscall

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

    notfound db 'No such contact found in contact book.', 10
    lennotfound equ $-notfound

    searchinfo db 'Enter Name or Number', 10
    lensearchinfo equ $-searchinfo

    cases db 'Please make sure to capitalise each Name', 10
    lencases equ $-cases

    breaker db '-', 10

segment .bss
    answer resb 1
    name resb 75
    fd_in resb 1
    fd_out resb 1
    dataloge rest 1000
    ;rdnum resb 5
