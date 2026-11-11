.model small
.stack 100h

LEN  equ 26
MAXD equ 12

.data
    msgTit  db 13,10,'DIVISAO INTEIRA COM ARRAYS',13,10,'$'
    msgA    db 13,10,'Dividendo (ex: -125,5): $'
    msgB    db 13,10,'Divisor   (ex: 2,5): $'
    msgInv  db 13,10,'Numero invalido. Tente outra vez.$'
    msgZero db 13,10,'Erro: o divisor nao pode ser 0. Tente outra vez.$'
    msgSemV db 13,10,13,10,'Sem virgula (mesmas casas decimais): $'
    msgDiv  db ' / $'
    msgPas  db 13,10,13,10,'Passo $'
    msgNum  db ': numero = $'
    msgX10  db ' x 10 + $'
    msgIg   db ' = $'
    msgVer  db 13,10,'  Verificar $'
    msgMaig db ' >= $'
    msgSim  db ' ? Sim$'
    msgNao  db ' ? Nao -> algarismo do quociente = 0$'
    msgTab  db 13,10,'  $'
    msgVez  db ' x $'
    msgMai  db ' > $'
    msgUsa  db ' -> usar $'
    msgRes  db 13,10,'  resto = $'
    msgMen  db ' - $'
    msgQuo  db 13,10,'  quociente = $'
    msgFim  db 13,10,13,10,'RESULTADO$'
    msgQ    db 13,10,'Quociente inteiro = $'
    msgR    db 13,10,'Resto = $'
    BUF     db LEN dup(0)
    NUMA    db LEN dup(0)
    NUMB    db LEN dup(0)
    PARC    db LEN dup(0)
    PROD    db LEN dup(0)
    PRODOK  db LEN dup(0)
    QUO     db LEN dup(0)
    NDIG    dw ?
    NDEC    dw ?
    SINAL   db ?
    SA      db ?
    SB      db ?
    DECA    dw ?
    DECB    dw ?
    NDECF   dw ?
    POS     dw ?
    PASSO   db ?
    DIG     db ?
    K       db ?

.code
main:
    mov  ax, @data
    mov  ds, ax
    lea  dx, msgTit
    call texto

le_a:
    lea  dx, msgA
    call texto
    call ler_num
    jnc  a_ok
    lea  dx, msgInv
    call texto
    jmp  le_a
a_ok:
    mov  al, SINAL
    mov  SA, al
    mov  ax, NDEC
    mov  DECA, ax
    lea  bx, NUMA
    call para_array

le_b:
    lea  dx, msgB
    call texto
    call ler_num
    jnc  b_ok
    lea  dx, msgInv
    call texto
    jmp  le_b
b_ok:
    mov  al, SINAL
    mov  SB, al
    mov  ax, NDEC
    mov  DECB, ax
    lea  bx, NUMB
    call para_array
    lea  si, NUMB
    call e_zero
    jne  b_nz
    lea  dx, msgZero
    call texto
    jmp  le_b
b_nz:

    mov  ax, DECA
    mov  cx, DECB
    cmp  ax, cx
    jae  al_b
    sub  cx, ax
    lea  bx, NUMA
al_a:
    mov  al, 0
    call empurra
    loop al_a
    mov  ax, DECB
    jmp  al_fim
al_b:
    mov  cx, ax
    sub  cx, DECB
    cmp  cx, 0
    je   al_fim0
    lea  bx, NUMB
al_b2:
    mov  al, 0
    call empurra
    loop al_b2
al_fim0:
    mov  ax, DECA
al_fim:
    mov  NDECF, ax
    cmp  ax, 0
    je   sem_dec
    lea  dx, msgSemV
    call texto
    lea  si, NUMA
    xor  cx, cx
    call escreve_arr
    lea  dx, msgDiv
    call texto
    lea  si, NUMB
    xor  cx, cx
    call escreve_arr
sem_dec:

    lea  bx, PARC
    call zera
    lea  bx, QUO
    call zera
    lea  si, NUMA
    xor  bx, bx
pd:
    cmp  bx, LEN-1
    jae  pd_ok
    mov  al, [si+bx]
    cmp  al, 0
    jne  pd_ok
    inc  bx
    jmp  pd
pd_ok:
    mov  POS, bx
    mov  al, 0
    mov  PASSO, al

ciclo:
    mov  al, PASSO
    inc  al
    mov  PASSO, al
    lea  dx, msgPas
    call texto
    mov  al, PASSO
    call escreve_n8
    lea  dx, msgNum
    call texto
    mov  bx, POS
    lea  si, NUMA
    mov  al, [si+bx]
    mov  DIG, al
    mov  al, PASSO
    cmp  al, 1
    je   c_prim
    lea  si, PARC
    xor  cx, cx
    call escreve_arr
    lea  dx, msgX10
    call texto
    mov  al, DIG
    call escreve_dig
    lea  dx, msgIg
    call texto
c_prim:
    lea  bx, PARC
    mov  al, DIG
    call empurra
    lea  si, PARC
    xor  cx, cx
    call escreve_arr

    lea  dx, msgVer
    call texto
    lea  si, PARC
    xor  cx, cx
    call escreve_arr
    lea  dx, msgMaig
    call texto
    lea  si, NUMB
    xor  cx, cx
    call escreve_arr
    lea  si, PARC
    lea  di, NUMB
    call compara
    jae  c_sim
    lea  dx, msgNao
    call texto
    mov  al, 0
    mov  K, al
    jmp  c_quoc

c_sim:
    lea  dx, msgSim
    call texto
    mov  al, 1
    mov  K, al
c_tab:
    lea  si, NUMB
    lea  di, PROD
    mov  al, K
    call mul_dig
    lea  dx, msgTab
    call texto
    lea  si, NUMB
    xor  cx, cx
    call escreve_arr
    lea  dx, msgVez
    call texto
    mov  al, K
    call escreve_dig
    lea  dx, msgIg
    call texto
    lea  si, PROD
    xor  cx, cx
    call escreve_arr
    lea  si, PROD
    lea  di, PARC
    call compara
    ja   c_passou
    lea  si, PROD
    lea  di, PRODOK
    call copia
    mov  al, K
    cmp  al, 9
    je   c_sub
    inc  al
    mov  K, al
    jmp  c_tab
c_passou:
    lea  dx, msgMai
    call texto
    lea  si, PARC
    xor  cx, cx
    call escreve_arr
    lea  dx, msgUsa
    call texto
    mov  al, K
    dec  al
    mov  K, al
    call escreve_dig

c_sub:
    lea  dx, msgRes
    call texto
    lea  si, PARC
    xor  cx, cx
    call escreve_arr
    lea  dx, msgMen
    call texto
    lea  si, PRODOK
    xor  cx, cx
    call escreve_arr
    lea  dx, msgIg
    call texto
    lea  si, PARC
    lea  di, PRODOK
    call subtrai
    lea  si, PARC
    xor  cx, cx
    call escreve_arr

c_quoc:
    lea  dx, msgQuo
    call texto
    lea  si, QUO
    xor  cx, cx
    call escreve_arr
    lea  dx, msgX10
    call texto
    mov  al, K
    call escreve_dig
    lea  dx, msgIg
    call texto
    lea  bx, QUO
    mov  al, K
    call empurra
    lea  si, QUO
    xor  cx, cx
    call escreve_arr
    mov  bx, POS
    inc  bx
    mov  POS, bx
    cmp  bx, LEN-1
    ja   fim_ciclo
    jmp  ciclo
fim_ciclo:

    lea  dx, msgFim
    call texto
    lea  dx, msgQ
    call texto
    lea  si, QUO
    call e_zero
    je   q_pos
    mov  al, SA
    mov  ah, SB
    cmp  al, ah
    je   q_pos
    call menos
q_pos:
    lea  si, QUO
    xor  cx, cx
    call escreve_arr
    lea  dx, msgR
    call texto
    lea  si, PARC
    xor  cx, cx
    call e_zero
    je   r_pos
    mov  cx, NDECF
    mov  al, SA
    cmp  al, 0
    je   r_pos
    call menos
r_pos:
    lea  si, PARC
    call escreve_arr
    mov  ah, 4Ch
    int  21h

ler_num proc
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    lea  bx, BUF
    xor  cx, cx
    xor  di, di
    xor  dx, dx
    mov  al, 0
    mov  SINAL, al
    mov  ah, 01h
    int  21h
    cmp  al, '-'
    jne  ln_ver
    mov  al, 1
    mov  SINAL, al
ln_prox:
    mov  ah, 01h
    int  21h
ln_ver:
    cmp  al, 13
    je   ln_fim
    cmp  al, ','
    je   ln_virg
    cmp  al, '.'
    je   ln_virg
    sub  al, '0'
    cmp  al, 9
    ja   ln_prox
    cmp  cx, MAXD
    jae  ln_mau
    mov  si, cx
    mov  [bx+si], al
    inc  cx
    cmp  dh, 0
    je   ln_prox
    inc  di
    jmp  ln_prox
ln_virg:
    cmp  dh, 0
    jne  ln_mau
    mov  dh, 1
    jmp  ln_prox
ln_mau:
    mov  dl, 1
    jmp  ln_prox
ln_fim:
    cmp  cx, 0
    je   ln_inv
    cmp  dl, 0
    jne  ln_inv
    mov  NDIG, cx
    mov  NDEC, di
    clc
    jmp  ln_sai
ln_inv:
    stc
ln_sai:
    pop  di
    pop  si
    pop  dx
    pop  cx
    pop  bx
    pop  ax
    ret
ler_num endp

para_array proc
    push ax
    push cx
    push si
    call zera
    xor  si, si
    mov  cx, NDIG
pa_loop:
    mov  al, BUF[si]
    call empurra
    inc  si
    loop pa_loop
    pop  si
    pop  cx
    pop  ax
    ret
para_array endp

zera proc
    push ax
    push cx
    push si
    xor  si, si
    xor  al, al
    mov  cx, LEN
z_loop:
    mov  [bx+si], al
    inc  si
    loop z_loop
    pop  si
    pop  cx
    pop  ax
    ret
zera endp

empurra proc
    push cx
    push dx
    push si
    mov  dl, al
    xor  si, si
    mov  cx, LEN-1
e_loop:
    mov  al, [bx+si+1]
    mov  [bx+si], al
    inc  si
    loop e_loop
    mov  [bx+si], dl
    mov  al, dl
    pop  si
    pop  dx
    pop  cx
    ret
empurra endp

copia proc
    push ax
    push bx
    push cx
    xor  bx, bx
    mov  cx, LEN
cp_loop:
    mov  al, [si+bx]
    mov  [di+bx], al
    inc  bx
    loop cp_loop
    pop  cx
    pop  bx
    pop  ax
    ret
copia endp

compara proc
    push ax
    push cx
    push si
    push di
    mov  cx, LEN
c_loop:
    mov  al, [si]
    cmp  al, [di]
    jne  c_fim
    inc  si
    inc  di
    loop c_loop
    cmp  al, al
c_fim:
    pop  di
    pop  si
    pop  cx
    pop  ax
    ret
compara endp

subtrai proc
    push ax
    push bx
    mov  bx, LEN-1
    xor  ah, ah
s_loop:
    mov  al, [si+bx]
    sub  al, ah
    sub  al, [di+bx]
    mov  ah, 0
    jns  s_ok
    add  al, 10
    mov  ah, 1
s_ok:
    mov  [si+bx], al
    dec  bx
    jns  s_loop
    pop  bx
    pop  ax
    ret
subtrai endp

mul_dig proc
    push ax
    push bx
    push dx
    mov  dl, al
    xor  dh, dh
    mov  bx, LEN-1
m_loop:
    mov  al, [si+bx]
    mul  dl
    add  al, dh
    xor  dh, dh
m_dez:
    cmp  al, 9
    jbe  m_un
    sub  al, 10
    inc  dh
    jmp  m_dez
m_un:
    mov  [di+bx], al
    dec  bx
    jns  m_loop
    pop  dx
    pop  bx
    pop  ax
    ret
mul_dig endp

e_zero proc
    push ax
    push bx
    push cx
    xor  al, al
    xor  bx, bx
    mov  cx, LEN
ez_loop:
    or   al, [si+bx]
    inc  bx
    loop ez_loop
    cmp  al, 0
    pop  cx
    pop  bx
    pop  ax
    ret
e_zero endp

escreve_arr proc
    push ax
    push bx
    push dx
    push di
    mov  di, LEN-1
    sub  di, cx
    xor  bx, bx
ea_proc:
    cmp  bx, di
    jae  ea_loop
    mov  al, [si+bx]
    cmp  al, 0
    jne  ea_loop
    inc  bx
    jmp  ea_proc
ea_loop:
    mov  dl, [si+bx]
    add  dl, '0'
    mov  ah, 02h
    int  21h
    cmp  bx, di
    jne  ea_sv
    cmp  cx, 0
    je   ea_sv
    mov  dl, ','
    mov  ah, 02h
    int  21h
ea_sv:
    inc  bx
    cmp  bx, LEN-1
    jbe  ea_loop
    pop  di
    pop  dx
    pop  bx
    pop  ax
    ret
escreve_arr endp

escreve_dig proc
    push ax
    push dx
    mov  dl, al
    add  dl, '0'
    mov  ah, 02h
    int  21h
    pop  dx
    pop  ax
    ret
escreve_dig endp

escreve_n8 proc
    push ax
    xor  ah, ah
n8_dez:
    cmp  al, 9
    jbe  n8_esc
    sub  al, 10
    inc  ah
    jmp  n8_dez
n8_esc:
    cmp  ah, 0
    je   n8_un
    push ax
    mov  al, ah
    call escreve_dig
    pop  ax
n8_un:
    call escreve_dig
    pop  ax
    ret
escreve_n8 endp

menos proc
    push ax
    push dx
    mov  dl, '-'
    mov  ah, 02h
    int  21h
    pop  dx
    pop  ax
    ret
menos endp

texto proc
    push ax
    mov  ah, 09h
    int  21h
    pop  ax
    ret
texto endp

end main
