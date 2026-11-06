
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h

; add your code here
    ; Tarefa 1.1 - Divisao inteira com arrays (algoritmo da aula)
.model small
.stack 100h

.data
msgDvd    db 13,10,'Dividendo (0-65535, max 5 digitos): $'
msgDvs    db 13,10,'Divisor (1-6553): $'
msgErr    db 13,10,'ERRO: divisor invalido.$'
msgCab    db 13,10,'Passos da divisao:',13,10,'$'
msgPasso  db 'Passo $'
msgDig    db ' | algarismo = $'
msgAt     db ' | atual = $'
msgQ      db ' | q = $'
msgPr     db ' | divisor*q = $'
msgRs     db ' | resto = $'
msgQuo    db 13,10,13,10,'Quociente = $'
msgRes    db 13,10,'Resto      = $'
crlf      db 13,10,'$'

digs       db 5 dup(0)       ; array: algarismos do dividendo
qdig_arr   db 5 dup(0)       ; array: algarismo do quociente em cada passo
atual_arr  dw 5 dup(0)       ; array: valor parcial em cada passo
prod_arr   dw 5 dup(0)       ; array: divisor*q em cada passo
resto_arr  dw 5 dup(0)       ; array: resto em cada passo

ndig      dw 0
divisor   dw 0
quoc      dw 0
resto     dw 0
atual     dw 0
qdig      dw 0
prod      dw 0
dtmp      dw 0

.code
main proc
    mov ax,@data
    mov ds,ax

    lea dx,msgDvd
    mov ah,9
    int 21h
    call ler_digitos
    mov ax,ax                    ; valor do dividendo em AX (nao usado depois)

    lea dx,msgDvs
    mov ah,9
    int 21h
    call ler_valor
    mov divisor,ax

    cmp divisor,0
    je erro
    cmp divisor,6553
    ja erro

    lea dx,msgCab
    mov ah,9
    int 21h

    mov quoc,0
    mov resto,0
    mov si,0                     ; SI = indice do algarismo (arrays de bytes)

prox_dig:
    cmp si,ndig
    jae fim
    mov di,si
    shl di,1                     ; DI = SI*2 (indice em arrays de words)

    ; atual = resto*10 + digs[si]
    mov ax,resto
    mov bx,10
    mul bx
    mov bl,digs[si]
    mov bh,0
    add ax,bx
    mov atual,ax
    mov atual_arr[di],ax

    ; maior q (0..9) com divisor*q <= atual
    mov qdig,0
busca:
    mov ax,qdig
    inc ax
    cmp ax,10
    jae achou
    mov bx,divisor
    mul bx
    cmp ax,atual
    ja achou
    inc qdig
    jmp busca

achou:
    ; prod = qdig*divisor
    mov ax,qdig
    mov bx,divisor
    mul bx
    mov prod,ax
    mov prod_arr[di],ax

    ; resto = atual - prod
    mov ax,atual
    sub ax,prod
    mov resto,ax
    mov resto_arr[di],ax

    ; guarda o algarismo do quociente
    mov ax,qdig
    mov qdig_arr[si],al

    ; quociente = quociente*10 + qdig
    mov ax,quoc
    mov bx,10
    mul bx
    add ax,qdig
    mov quoc,ax

    call imprime_passo

    inc si
    jmp prox_dig

fim:
    lea dx,msgQuo
    mov ah,9
    int 21h
    mov ax,quoc
    call mostrar_numero

    lea dx,msgRes
    mov ah,9
    int 21h
    mov ax,resto
    call mostrar_numero
    jmp sair

erro:
    lea dx,msgErr
    mov ah,9
    int 21h

sair:
    mov ah,4Ch
    int 21h
main endp

; ler_digitos: le ate ENTER, guarda em digs[], devolve valor em AX
ler_digitos proc
    push bx
    push cx
    push dx
    xor bx,bx
    mov ndig,0
ld_loop:
    mov ah,1
    int 21h
    cmp al,13
    je ld_fim
    sub al,'0'
    mov ah,0
    mov dtmp,ax
    mov si,ndig
    cmp si,5
    jae ld_calc
    mov al,byte ptr dtmp
    mov digs[si],al
    inc ndig
ld_calc:
    mov ax,bx
    mov cx,10
    mul cx
    add ax,dtmp
    mov bx,ax
    jmp ld_loop
ld_fim:
    mov ax,bx
    pop dx
    pop cx
    pop bx
    ret
ler_digitos endp

; ler_valor: le um numero ate ENTER, devolve em AX
ler_valor proc
    push bx
    push cx
    push dx
    xor bx,bx
lv_loop:
    mov ah,1
    int 21h
    cmp al,13
    je lv_fim
    sub al,'0'
    mov ah,0
    mov dtmp,ax
    mov ax,bx
    mov cx,10
    mul cx
    add ax,dtmp
    mov bx,ax
    jmp lv_loop
lv_fim:
    mov ax,bx
    pop dx
    pop cx
    pop bx
    ret
ler_valor endp

; imprime_passo: le os arrays na posicao SI (DI = SI*2) e mostra o passo
imprime_passo proc
    push ax
    push dx
    push di
    mov di,si
    shl di,1

    lea dx,msgPasso
    mov ah,9
    int 21h
    mov ax,si
    inc ax
    call mostrar_numero

    lea dx,msgDig
    mov ah,9
    int 21h
    mov al,digs[si]
    mov ah,0
    call mostrar_numero

    lea dx,msgAt
    mov ah,9
    int 21h
    mov ax,atual_arr[di]
    call mostrar_numero

    lea dx,msgQ
    mov ah,9
    int 21h
    mov al,qdig_arr[si]
    mov ah,0
    call mostrar_numero

    lea dx,msgPr
    mov ah,9
    int 21h
    mov ax,prod_arr[di]
    call mostrar_numero

    lea dx,msgRs
    mov ah,9
    int 21h
    mov ax,resto_arr[di]
    call mostrar_numero

    lea dx,crlf
    mov ah,9
    int 21h
    pop di
    pop dx
    pop ax
    ret
imprime_passo endp

; mostrar_numero: imprime AX em decimal (DIV por 10, so apresentacao)
mostrar_numero proc
    push ax
    push bx
    push cx
    push dx
    mov bx,10
    mov cx,0
mn_conv:
    xor dx,dx
    div bx
    push dx
    inc cx
    cmp ax,0
    jne mn_conv
mn_imp:
    pop dx
    add dl,'0'
    mov ah,2
    int 21h
    loop mn_imp
    pop dx
    pop cx
    pop bx
    pop ax
    ret
mostrar_numero endp

end main
ret




