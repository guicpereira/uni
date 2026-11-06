
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h

; add your code here
       ; Tarefa 1.2 - Raiz quadrada inteira (algoritmo da aula, por pares)
; Assembly x86 16 bits - EMU8086 (sintaxe MASM)
; Para cada par P: rem = rem*100 + P; procura o maior x (0..9) com
; (20*raiz + x)*x <= rem; rem = rem - (20*raiz+x)*x; raiz = raiz*10 + x.
; Calculos so com MUL, ADD, SUB, CMP. DIV so para separar pares e apresentar.
; Limite: radicando de 0 a 9999 (dois pares).
.model small
.stack 100h

.data
msgRad    db 13,10,'Radicando (0-9999): $'
msgErr    db 13,10,'ERRO: valor fora do intervalo (0-9999).$'
msgCab    db 13,10,'Passos da raiz quadrada (par a par):',13,10,'$'
msgPasso  db 'Par $'
msgP      db ' | par = $'
msgRem    db ' | rem = $'
msgX      db ' | x = $'
msgProd   db ' | (20*raiz+x)*x = $'
msgRz     db ' | raiz parcial = $'
msgRsto   db ' | resto = $'
msgFinal  db 13,10,13,10,'Raiz quadrada inteira = $'
msgRestoF db 13,10,'Resto final            = $'
crlf      db 13,10,'$'

radicando dw 0
pares     dw 0,0               ; pares[0] = centenas (par 1), pares[1] = unidades (par 2)
rem       dw 0                 ; resto corrente
raiz      dw 0                 ; raiz parcial
xdig      dw 0                 ; algarismo x escolhido
prod      dw 0                 ; (20*raiz + x)*x
par       dw 0                 ; par corrente

.code
main proc
    mov ax,@data
    mov ds,ax

    lea dx,msgRad                ; pede o radicando
    mov ah,9
    int 21h
    call ler_valor
    mov radicando,ax

    cmp ax,9999                  ; validacao
    ja erro

    ; separa em pares com DIV: centenas = AX/100 ; unidades = AX mod 100
    xor dx,dx
    mov bx,100
    div bx
    mov pares[0],ax              ; primeiro par
    mov pares[2],dx              ; segundo par

    mov rem,0
    mov raiz,0

    lea dx,msgCab
    mov ah,9
    int 21h

    mov si,0                     ; SI = 0 (primeiro par) ou 2 (segundo par)
prox_par:
    mov ax,pares[si]
    mov par,ax

    ; rem = rem*100 + par
    mov ax,rem
    mov bx,100
    mul bx
    add ax,par
    mov rem,ax

    ; procura o maior x (0..9) com (20*raiz + x)*x <= rem
    mov xdig,0
busca:
    mov ax,xdig
    inc ax                       ; candidato c = x + 1
    cmp ax,10
    jae achou
    mov cx,ax                    ; CX = c
    mov ax,raiz
    mov bx,20
    mul bx                       ; AX = 20*raiz
    add ax,cx                    ; AX = 20*raiz + c
    mul cx                       ; AX = (20*raiz + c) * c   (DX = 0)
    cmp ax,rem
    ja achou                     ; ultrapassou rem: para
    inc xdig                     ; aceita c
    jmp busca

achou:
    ; prod = (20*raiz + x) * x
    mov ax,raiz
    mov bx,20
    mul bx
    add ax,xdig
    mov bx,xdig
    mul bx
    mov prod,ax

    ; rem = rem - prod
    mov ax,rem
    sub ax,prod
    mov rem,ax

    ; raiz = raiz*10 + x
    mov ax,raiz
    mov bx,10
    mul bx
    add ax,xdig
    mov raiz,ax

    call imprime_passo

    add si,2                     ; proximo par
    cmp si,4
    jb prox_par

    ; resultado final
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

; ler_valor: le digitos ate ENTER e devolve o valor em AX (valor = valor*10 + algarismo)
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
    mov cx,ax                    ; CX = algarismo
    mov ax,bx
    mov dx,10
    mul dx                       ; AX = valor*10
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

; imprime_passo: mostra o passo corrente
imprime_passo proc
    push ax
    push dx
    lea dx,msgPasso
    mov ah,9
    int 21h
    mov ax,si
    shr ax,1
    inc ax                       ; numero do par: 1 ou 2
    call mostrar_numero

    lea dx,msgP
    mov ah,9
    int 21h
    mov ax,par
    call mostrar_numero

    lea dx,msgRem
    mov ah,9
    int 21h
    mov ax,rem
    call mostrar_numero

    lea dx,msgX
    mov ah,9
    int 21h
    mov ax,xdig
    call mostrar_numero

    lea dx,msgProd
    mov ah,9
    int 21h
    mov ax,prod
    call mostrar_numero

    lea dx,msgRz
    mov ah,9
    int 21h
    mov ax,raiz
    call mostrar_numero

    lea dx,crlf
    mov ah,9
    int 21h
    pop dx
    pop ax
    ret
imprime_passo endp

; mostrar_numero: imprime AX (0..65535) em decimal (DIV por 10, apresentacao)
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




