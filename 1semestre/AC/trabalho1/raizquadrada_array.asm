
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h

; add your code here
 ; Tarefa 1.2 - Raiz quadrada inteira com arrays (algoritmo da aula)
.model small
.stack 100h

.data
msgRad    db 13,10,'Radicando (0-9999): $'
msgErr    db 13,10,'ERRO: valor fora do intervalo.$'
msgCab    db 13,10,'Passos da raiz quadrada:',13,10,'$'
msgPasso  db 'Par $'
msgP      db ' | par = $'
msgRem    db ' | rem = $'
msgX      db ' | x = $'
msgProd   db ' | (20*raiz+x)*x = $'
msgRz     db ' | raiz parcial = $'
msgFinal  db 13,10,13,10,'Raiz quadrada inteira = $'
msgRestoF db 13,10,'Resto final            = $'
crlf      db 13,10,'$'

pares     dw 2 dup(0)        ; array: pares de algarismos (0 = 1.o par, 2 = 2.o par)
par_arr   dw 2 dup(0)        ; array: par usado em cada passo
rem_arr   dw 2 dup(0)        ; array: rem em cada passo
x_arr     dw 2 dup(0)        ; array: x escolhido em cada passo
prod_arr  dw 2 dup(0)        ; array: (20*raiz+x)*x em cada passo
raiz_arr  dw 2 dup(0)        ; array: raiz parcial em cada passo

radicando dw 0
rem       dw 0
raiz      dw 0
xdig      dw 0
prod      dw 0
par       dw 0

.code
main proc
    mov ax,@data
    mov ds,ax

    lea dx,msgRad
    mov ah,9
    int 21h
    call ler_valor
    mov radicando,ax

    cmp ax,9999
    ja erro

    ; separa em pares com DIV: pares[0] = AX/100, pares[2] = AX mod 100
    xor dx,dx
    mov bx,100
    div bx
    mov pares[0],ax
    mov pares[2],dx

    mov rem,0
    mov raiz,0

    lea dx,msgCab
    mov ah,9
    int 21h

    mov si,0                     ; SI = 0 ou 2 (indice em arrays de words)
prox_par:
    ; rem = rem*100 + par
    mov ax,pares[si]
    mov par,ax
    mov par_arr[si],ax
    mov ax,rem
    mov bx,100
    mul bx
    add ax,par
    mov rem,ax

    ; maior x (0..9) com (20*raiz + x)*x <= rem
    mov xdig,0
busca:
    mov ax,xdig
    inc ax
    cmp ax,10
    jae achou
    mov cx,ax
    mov ax,raiz
    mov bx,20
    mul bx
    add ax,cx
    mul cx
    cmp ax,rem
    ja achou
    inc xdig
    jmp busca

achou:
    ; prod = (20*raiz + x)*x
    mov ax,raiz
    mov bx,20
    mul bx
    add ax,xdig
    mov bx,xdig
    mul bx
    mov prod,ax
    mov prod_arr[si],ax

    ; rem = rem - prod
    mov ax,rem
    sub ax,prod
    mov rem,ax
    mov rem_arr[si],ax

    ; guarda x
    mov ax,xdig
    mov x_arr[si],ax

    ; raiz = raiz*10 + x
    mov ax,raiz
    mov bx,10
    mul bx
    add ax,xdig
    mov raiz,ax
    mov raiz_arr[si],ax

    call imprime_passo

    add si,2
    cmp si,4
    jb prox_par

    lea dx,msgFinal
    mov ah,9
    int 21h
    mov ax,raiz
    call mostrar_numero

    lea dx,msgRestoF
    mov ah,9
    int 21h
    mov ax,rem
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

; ler_valor: le digitos ate ENTER, devolve em AX
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
    mov cx,ax
    mov ax,bx
    mov dx,10
    mul dx
    add ax,cx
    mov bx,ax
    jmp lv_loop
lv_fim:
    mov ax,bx
    pop dx
    pop cx
    pop bx
    ret
ler_valor endp

; imprime_passo: le os arrays na posicao SI
imprime_passo proc
    push ax
    push dx

    lea dx,msgPasso
    mov ah,9
    int 21h
    mov ax,si
    shr ax,1
    inc ax
    call mostrar_numero

    lea dx,msgP
    mov ah,9
    int 21h
    mov ax,par_arr[si]
    call mostrar_numero

    lea dx,msgRem
    mov ah,9
    int 21h
    mov ax,rem_arr[si]
    call mostrar_numero

    lea dx,msgX
    mov ah,9
    int 21h
    mov ax,x_arr[si]
    call mostrar_numero

    lea dx,msgProd
    mov ah,9
    int 21h
    mov ax,prod_arr[si]
    call mostrar_numero

    lea dx,msgRz
    mov ah,9
    int 21h
    mov ax,raiz_arr[si]
    call mostrar_numero

    lea dx,crlf
    mov ah,9
    int 21h
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




