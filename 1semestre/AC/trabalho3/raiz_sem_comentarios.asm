.model small
.stack 100h

LEN  equ 26
MAXD equ 12

.data
    msgTit  db 13,10,'RAIZ QUADRADA COM ARRAYS',13,10,'$'
    msgN    db 13,10,'Numero (ex: 341,7): $'
    msgInv  db 13,10,'Numero invalido. Tente outra vez.$'
    msgNeg  db 13,10,'Um numero negativo nao tem raiz quadrada real. Tente outra vez.$'
    msgGr   db 13,10,13,10,'Grupos de 2 algarismos: $'
    msgVg   db ', $'
    msgEsp  db ' $'
    msgReg  db 13,10,'Em cada grupo: maior a com (2 x R x 10 + a) x a <= resto$'
    msgGrp  db 13,10,13,10,'Grupo $'
    msgAbre db ' ($'
    msgFech db '): resto = $'
    msgX100 db ' x 100 + $'
    msgIg   db ' = $'
    msgDob  db 13,10,'  2 x R = 2 x $'
    msgTab  db 13,10,'  $'
    msgVez  db ' x $'
    msgMai  db ' > $'
    msgUsa  db ' -> usar $'
    msgRes  db 13,10,'  resto = $'
    msgMen  db ' - $'
    msgRz   db 13,10,'  R = $'
    msgX10  db ' x 10 + $'
    msgFim  db 13,10,13,10,'RESULTADO$'
    msgRQ   db 13,10,'Raiz quadrada = $'
    msgR    db 13,10,'Resto = $'
    BUF     db LEN dup(0)
    GBUF    db LEN dup(0)
    RAIZ    db LEN dup(0)
    RESTO   db LEN dup(0)
    DOBRO   db LEN dup(0)
    TENT    db LEN dup(0)
    PROD    db LEN dup(0)
    PRODOK  db LEN dup(0)
    NDIG    dw ?
    NDEC    dw ?
    SINAL   db ?
    NG      dw ?
    NGI     dw ?
    NDECR   dw ?
    NDECR2  dw ?
    IDX     dw ?
    PASSO   db ?
    D1      db ?
    D2      db ?
    A       db ?
    MELHOR  db ?

.code
main:
    mov  ax, @data
    mov  ds, ax
    lea  dx, msgTit
    call texto

le:
    lea  dx, msgN
    call texto
    call ler_num
    jnc  le_ok
    lea  dx, msgInv
    call texto
    jmp  le
le_ok:
    mov  al, SINAL
    cmp  al, 0
    je   le_pos
    lea  dx, msgNeg
    call texto
    jmp  le
le_pos:

    lea  bx, GBUF
    call zera
    xor  di, di
    mov  ax, NDIG
    sub  ax, NDEC
    test al, 1
    jz   g_ipar
    mov  al, 0
    mov  [bx+di], al
    inc  di
g_ipar:
    xor  si, si
    mov  cx, NDIG
g_cp:
    mov  al, BUF[si]
    mov  [bx+di], al
    inc  si
    inc  di
    loop g_cp
    mov  ax, NDEC
    test al, 1
    jz   g_dpar
    mov  al, 0
    mov  [bx+di], al
    inc  di
    mov  ax, NDEC
    inc  ax
g_dpar:
    mov  NG, di
    mov  dx, di
    sub  dx, ax
    mov  NGI, dx
    mov  NDECR2, ax
    xor  cx, cx
g_meio:
    cmp  ax, 0
    je   g_meio_ok
    sub  ax, 2
    inc  cx
    jmp  g_meio
g_meio_ok:
    mov  NDECR, cx

    lea  dx, msgGr
    call texto
    xor  si, si
gp:
    cmp  si, NG
    jae  gp_fim
    cmp  si, NGI
    jne  gp_d
    cmp  si, 0
    je   gp_d
    lea  dx, msgVg
    call texto
gp_d:
    mov  al, GBUF[si]
    call escreve_dig
    inc  si
    mov  al, GBUF[si]
    call escreve_dig
    inc  si
    lea  dx, msgEsp
    call texto
    jmp  gp
gp_fim:
    lea  dx, msgReg
    call texto

    lea  bx, RAIZ
    call zera
    lea  bx, RESTO
    call zera
    mov  ax, 0
    mov  IDX, ax
    mov  al, 0
    mov  PASSO, al

gciclo:
    mov  al, PASSO
    inc  al
    mov  PASSO, al
    mov  si, IDX
    mov  al, GBUF[si]
    mov  D1, al
    inc  si
    mov  al, GBUF[si]
    mov  D2, al
    lea  dx, msgGrp
    call texto
    mov  al, PASSO
    call escreve_n8
    lea  dx, msgAbre
    call texto
    mov  al, D1
    call escreve_dig
    mov  al, D2
    call escreve_dig
    lea  dx, msgFech
    call texto
    mov  al, PASSO
    cmp  al, 1
    je   g_prim
    lea  si, RESTO
    xor  cx, cx
    call escreve_arr
    lea  dx, msgX100
    call texto
    mov  al, D1
    call escreve_dig
    mov  al, D2
    call escreve_dig
    lea  dx, msgIg
    call texto
g_prim:
    lea  bx, RESTO
    mov  al, D1
    call empurra
    mov  al, D2
    call empurra
    lea  si, RESTO
    xor  cx, cx
    call escreve_arr

    lea  si, RAIZ
    lea  di, DOBRO
    mov  al, 2
    call mul_dig
    lea  dx, msgDob
    call texto
    lea  si, RAIZ
    xor  cx, cx
    call escreve_arr
    lea  dx, msgIg
    call texto
    lea  si, DOBRO
    xor  cx, cx
    call escreve_arr

    lea  bx, PRODOK
    call zera
    mov  al, 0
    mov  MELHOR, al
    mov  al, 1
    mov  A, al
t_loop:
    lea  si, DOBRO
    lea  di, TENT
    call copia
    lea  bx, TENT
    mov  al, A
    call empurra
    lea  si, TENT
    lea  di, PROD
    mov  al, A
    call mul_dig
    lea  dx, msgTab
    call texto
    lea  si, TENT
    xor  cx, cx
    call escreve_arr
    lea  dx, msgVez
    call texto
    mov  al, A
    call escreve_dig
    lea  dx, msgIg
    call texto
    lea  si, PROD
    xor  cx, cx
    call escreve_arr
    lea  si, PROD
    lea  di, RESTO
    call compara
    ja   t_pass
    lea  si, PROD
    lea  di, PRODOK
    call copia
    mov  al, A
    mov  MELHOR, al
    cmp  al, 9
    je   t_fim
    inc  al
    mov  A, al
    jmp  t_loop
t_pass:
    lea  dx, msgMai
    call texto
    lea  si, RESTO
    xor  cx, cx
    call escreve_arr
    lea  dx, msgUsa
    call texto
    mov  al, MELHOR
    call escreve_dig
t_fim:

    lea  dx, msgRes
    call texto
    lea  si, RESTO
    xor  cx, cx
    call escreve_arr
    lea  dx, msgMen
    call texto
    lea  si, PRODOK
    xor  cx, cx
    call escreve_arr
    lea  dx, msgIg
    call texto
    lea  si, RESTO
    lea  di, PRODOK
    call subtrai
    lea  si, RESTO
    xor  cx, cx
    call escreve_arr

    lea  dx, msgRz
    call texto
    lea  si, RAIZ
    xor  cx, cx
    call escreve_arr
    lea  dx, msgX10
    call texto
    mov  al, MELHOR
    call escreve_dig
    lea  dx, msgIg
    call texto
    lea  bx, RAIZ
    mov  al, MELHOR
    call empurra
    lea  si, RAIZ
    xor  cx, cx
    call escreve_arr
    mov  ax, IDX
    add  ax, 2
    mov  IDX, ax
    cmp  ax, NG
    jae  g_fim
    jmp  gciclo
g_fim:

    lea  dx, msgFim
    call texto
    lea  dx, msgRQ
    call texto
    lea  si, RAIZ
    mov  cx, NDECR
    call escreve_arr
    lea  dx, msgR
    call texto
    lea  si, RESTO
    xor  cx, cx
    call e_zero
    je   r_esc
    mov  cx, NDECR2
r_esc:
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
