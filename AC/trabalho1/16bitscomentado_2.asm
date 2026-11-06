
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h

; add your code here
   ; Tarefa 1.1 - Divisao inteira (algoritmo da aula, divisao "por digitos")
; Assembly x86 16 bits - EMU8086 (sintaxe MASM)
; Algoritmo: para cada algarismo d: atual = resto*10 + d;
; procura o maior q (0..9) com divisor*q <= atual; quociente = quociente*10 + q;
; resto = atual - divisor*q. Calculos so com MUL, ADD, SUB, CMP.
; DIV so na apresentacao (conversao para decimal).
.model small
.stack 100h

.data
msgDvd    db 13,10,'Dividendo (0-65535, max 5 digitos): $'
msgDvs    db 13,10,'Divisor (1-6553): $'
msgErr    db 13,10,'ERRO: divisor invalido (deve ser 1 a 6553).$'
msgCab    db 13,10,'Passos da divisao (digito a digito):',13,10,'$'
msgPasso  db 'Passo $'
msgDig    db ' | algarismo = $'
msgAt     db ' | atual = $'
msgQ      db ' | q = $'
msgPr     db ' | divisor*q = $'
msgRs     db ' | resto = $'
msgQuo    db 13,10,13,10,'Quociente = $'
msgRes    db 13,10,'Resto      = $'
crlf      db 13,10,'$'

digs      db 5 dup(0)          ; algarismos do dividendo
ndig      dw 0                 ; numero de algarismos lidos
dividendo dw 0
divisor   dw 0
quoc      dw 0                 ; quociente acumulado
resto     dw 0                 ; resto acumulado
atual     dw 0                 ; valor parcial (resto*10 + algarismo)
qdig      dw 0                 ; algarismo do quociente
prod      dw 0                 ; divisor * qdig
dtmp      dw 0                 ; algarismo lido (temporario)

.code
main proc
    mov ax,@data                 ; inicializa DS
    mov ds,ax

    lea dx,msgDvd                ; pede o dividendo
    mov ah,9
    int 21h
    call ler_digitos             ; le algarismos e calcula o valor em AX
    mov dividendo,ax

    lea dx,msgDvs                ; pede o divisor
    mov ah,9
    int 21h
    call ler_valor               ; le o divisor em AX
    mov divisor,ax

    cmp divisor,0                ; validacao do divisor
    je erro
    cmp divisor,6553
    ja erro

    lea dx,msgCab               ; titulo dos passos
    mov ah,9
    int 21h

    mov quoc,0
    mov resto,0
    mov si,0                     ; SI = indice do algarismo corrente

prox_dig:
    cmp si,ndig                  ; processados todos os algarismos?
    jae fim

    ; atual = resto*10 + algarismo
    mov ax,resto
    mov bx,10
    mul bx                       ; AX = resto*10
    mov bl,digs[si]
    mov bh,0
    add ax,bx                    ; AX = resto*10 + algarismo
    mov atual,ax

    ; procura o maior q (0..9) com divisor*q <= atual
    mov qdig,0
busca:
    mov ax,qdig
    inc ax                       ; candidato c = q + 1
    cmp ax,10
    jae achou                    ; c > 9: para
    mov bx,divisor
    mul bx                       ; AX = c * divisor (DX = 0)
    cmp ax,atual
    ja achou                     ; c * divisor > atual: para
    inc qdig                     ; aceita c como algarismo do quociente
    jmp busca

achou:
    ; prod = qdig * divisor ; resto = atual - prod
    mov ax,qdig
    mov bx,divisor
    mul bx
    mov prod,ax
    mov ax,atual
    sub ax,prod
    mov resto,ax

    ; quociente = quociente*10 + qdig
    mov ax,quoc
    mov bx,10
    mul bx
    add ax,qdig
    mov quoc,ax

    call imprime_passo           ; mostra o passo parcial

    inc si
    jmp prox_dig

fim:
    lea dx,msgQuo                ; resultado final
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
    mov ah,4Ch                   ; termina o programa
    int 21h
main endp

; ler_digitos: le algarismos ate ENTER, guarda-os em digs[] e devolve o valor em AX
ler_digitos proc
    push bx
    push cx
    push dx
    xor bx,bx                    ; BX = valor acumulado
    mov ndig,0
ld_loop:
    mov ah,1                     ; le um caracter com eco
    int 21h
    cmp al,13                    ; ENTER termina
    je ld_fim
    sub al,'0'                   ; caracter -> algarismo
    mov ah,0
    mov dtmp,ax                  ; guarda o algarismo
    mov si,ndig
    cmp si,5                     ; no maximo 5 algarismos
    jae ld_calc
    mov al,byte ptr dtmp
    mov digs[si],al
    inc ndig
ld_calc:
    mov ax,bx
    mov cx,10
    mul cx                       ; AX = valor * 10
    add ax,dtmp                  ; AX = valor*10 + algarismo
    mov bx,ax
    jmp ld_loop
ld_fim:
    mov ax,bx
    pop dx
    pop cx
    pop bx
    ret
ler_digitos endp

; ler_valor: le um numero e devolve em AX
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

; imprime_passo: mostra o passo corrente (indice SI)
imprime_passo proc
    push ax
    push dx
    lea dx,msgPasso
    mov ah,9
    int 21h
    mov ax,si
    inc ax                       ; numero do passo = SI + 1
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
    mov ax,atual
    call mostrar_numero

    lea dx,msgQ
    mov ah,9
    int 21h
    mov ax,qdig
    call mostrar_numero

    lea dx,msgPr
    mov ah,9
    int 21h
    mov ax,prod
    call mostrar_numero

    lea dx,msgRs
    mov ah,9
    int 21h
    mov ax,resto
    call mostrar_numero

    lea dx,crlf
    mov ah,9
    int 21h
    pop dx
    pop ax
    ret
imprime_passo endp

; mostrar_numero: imprime AX (0..65535) em decimal, usando DIV por 10 (apresentacao)
mostrar_numero proc
    push ax
    push bx
    push cx
    push dx
    mov bx,10
    mov cx,0                     ; contador de algarismos
mn_conv:
    xor dx,dx
    div bx                       ; AX = AX / 10 , DX = resto (algarismo)
    push dx
    inc cx
    cmp ax,0
    jne mn_conv
mn_imp:
    pop dx
    add dl,'0'                   ; algarismo -> ASCII
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




