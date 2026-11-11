; =====================================================================
; TAREFA 3 - 2. RAIZ QUADRADA COM ARRAYS (emu8086)
; Algoritmo da aula (raiz quadrada "a mao", algarismo a algarismo):
;   - o numero e lido do teclado e guardado num array, um algarismo por
;     posicao; pode ter virgula;
;   - os algarismos agrupam-se 2 a 2 a partir da virgula (para a esquerda
;     na parte inteira e para a direita na parte decimal); se faltar um
;     algarismo acrescenta-se um 0;
;   - para cada grupo: resto = resto x 100 + grupo; procura-se o maior
;     algarismo a tal que (2 x R x 10 + a) x a <= resto (R = raiz ja
;     calculada); resto = resto - (2 x R x 10 + a) x a; R = R x 10 + a.
; As contas sobre os arrays usam apenas adicao, subtracao e multiplicacao.
; =====================================================================
.model small
.stack 100h

LEN  equ 26              ; tamanho de cada array (algarismos)
MAXD equ 12              ; maximo de algarismos que se podem escrever

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
    BUF     db LEN dup(0)    ; algarismos tal como foram escritos
    GBUF    db LEN dup(0)    ; algarismos agrupados 2 a 2 (com zeros)
    RAIZ    db LEN dup(0)    ; raiz ja calculada (R)
    RESTO   db LEN dup(0)    ; resto
    DOBRO   db LEN dup(0)    ; 2 x R
    TENT    db LEN dup(0)    ; 2 x R x 10 + a
    PROD    db LEN dup(0)    ; (2 x R x 10 + a) x a
    PRODOK  db LEN dup(0)    ; maior produto que nao passa o resto
    NDIG    dw ?             ; algarismos lidos
    NDEC    dw ?             ; casas decimais lidas
    SINAL   db ?             ; 1 se o numero lido for negativo
    NG      dw ?             ; algarismos em GBUF (par)
    NGI     dw ?             ; algarismos da parte inteira em GBUF
    NDECR   dw ?             ; casas decimais da raiz (grupos decimais)
    NDECR2  dw ?             ; casas decimais do resto (2 x NDECR)
    IDX     dw ?             ; posicao do grupo em GBUF
    PASSO   db ?             ; numero do grupo
    D1      db ?             ; 1.o algarismo do grupo
    D2      db ?             ; 2.o algarismo do grupo
    A       db ?             ; algarismo a experimentar
    MELHOR  db ?             ; maior a que serve

.code
main:
    mov  ax, @data
    mov  ds, ax
    lea  dx, msgTit
    call texto

; ---------- ler o numero ----------
le:
    lea  dx, msgN
    call texto
    call ler_num             ; BUF, NDIG, NDEC, SINAL; CF = 1 se invalido
    jnc  le_ok
    lea  dx, msgInv
    call texto
    jmp  le
le_ok:
    mov  al, SINAL
    cmp  al, 0
    je   le_pos
    lea  dx, msgNeg          ; negativo: nao tem raiz real
    call texto
    jmp  le
le_pos:

; ---------- agrupar 2 a 2 a partir da virgula ----------
    lea  bx, GBUF
    call zera
    xor  di, di              ; DI = algarismos ja postos em GBUF
    mov  ax, NDIG
    sub  ax, NDEC            ; AX = algarismos da parte inteira
    test al, 1
    jz   g_ipar
    mov  al, 0               ; parte inteira impar: 0 a esquerda
    mov  [bx+di], al
    inc  di
g_ipar:
    xor  si, si
    mov  cx, NDIG
g_cp:
    mov  al, BUF[si]         ; copia os algarismos lidos
    mov  [bx+di], al
    inc  si
    inc  di
    loop g_cp
    mov  ax, NDEC
    test al, 1
    jz   g_dpar
    mov  al, 0               ; parte decimal impar: 0 a direita
    mov  [bx+di], al
    inc  di
    mov  ax, NDEC
    inc  ax                  ; AX = casas decimais (ja par)
g_dpar:
    mov  NG, di
    mov  dx, di
    sub  dx, ax
    mov  NGI, dx             ; algarismos da parte inteira (par)
    mov  NDECR2, ax          ; o resto tem estas casas decimais
    xor  cx, cx              ; NDECR = AX / 2, contando subtracoes de 2
g_meio:
    cmp  ax, 0
    je   g_meio_ok
    sub  ax, 2
    inc  cx
    jmp  g_meio
g_meio_ok:
    mov  NDECR, cx

; ----- mostra os grupos -----
    lea  dx, msgGr
    call texto
    xor  si, si
gp:
    cmp  si, NG
    jae  gp_fim
    cmp  si, NGI
    jne  gp_d
    cmp  si, 0
    je   gp_d                ; sem parte inteira nao ha virgula antes
    lea  dx, msgVg           ; virgula entre a parte inteira e a decimal
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

; ---------- calculo grupo a grupo ----------
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
    mov  si, IDX             ; os dois algarismos do grupo
    mov  al, GBUF[si]
    mov  D1, al
    inc  si
    mov  al, GBUF[si]
    mov  D2, al
    lea  dx, msgGrp          ; "Grupo n (d1d2): resto = "
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
    je   g_prim              ; no 1.o grupo nao ha resto anterior
    lea  si, RESTO           ; "resto anterior x 100 + grupo = "
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
    call empurra             ; resto = resto x 100 + grupo
    mov  al, D2
    call empurra
    lea  si, RESTO
    xor  cx, cx
    call escreve_arr

; ----- 2 x R -----
    lea  si, RAIZ
    lea  di, DOBRO
    mov  al, 2
    call mul_dig             ; DOBRO = 2 x R
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

; ----- experimentar a = 1, 2, ... : (2 x R x 10 + a) x a -----
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
    call empurra             ; TENT = 2 x R x 10 + a
    lea  si, TENT
    lea  di, PROD
    mov  al, A
    call mul_dig             ; PROD = TENT x a
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
    call compara             ; passou o resto?
    ja   t_pass
    lea  si, PROD            ; ainda serve: guarda-o
    lea  di, PRODOK
    call copia
    mov  al, A
    mov  MELHOR, al
    cmp  al, 9
    je   t_fim               ; 9 e o maior algarismo
    inc  al
    mov  A, al
    jmp  t_loop
t_pass:
    lea  dx, msgMai          ; " > resto -> usar a anterior"
    call texto
    lea  si, RESTO
    xor  cx, cx
    call escreve_arr
    lea  dx, msgUsa
    call texto
    mov  al, MELHOR
    call escreve_dig
t_fim:

; ----- resto = resto - produto escolhido -----
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
    call subtrai             ; RESTO = RESTO - PRODOK
    lea  si, RESTO
    xor  cx, cx
    call escreve_arr

; ----- R = R x 10 + a -----
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
    mov  ax, IDX             ; grupo seguinte
    add  ax, 2
    mov  IDX, ax
    cmp  ax, NG
    jae  g_fim               ; ja nao ha grupos
    jmp  gciclo
g_fim:

; ---------- resultado final ----------
    lea  dx, msgFim
    call texto
    lea  dx, msgRQ
    call texto
    lea  si, RAIZ
    mov  cx, NDECR           ; uma casa decimal por grupo decimal
    call escreve_arr
    lea  dx, msgR
    call texto
    lea  si, RESTO
    xor  cx, cx              ; resto 0: escreve so "0"
    call e_zero
    je   r_esc
    mov  cx, NDECR2          ; o resto tem duas casas por grupo decimal
r_esc:
    call escreve_arr
    mov  ah, 4Ch             ; termina
    int  21h

; =====================================================================
; ler_num: le um numero do teclado ate ENTER: '-' opcional, algarismos e
; uma virgula ('.' ou ','). Guarda os algarismos em BUF.
; Saida: NDIG, NDEC, SINAL; CF = 1 se o numero for invalido.
; =====================================================================
ler_num proc
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    lea  bx, BUF
    xor  cx, cx              ; CX = algarismos lidos
    xor  di, di              ; DI = casas decimais
    xor  dx, dx              ; DH = 1 se ja leu a virgula, DL = 1 se invalido
    mov  al, 0
    mov  SINAL, al
    mov  ah, 01h
    int  21h                 ; primeiro caracter
    cmp  al, '-'
    jne  ln_ver
    mov  al, 1
    mov  SINAL, al           ; numero negativo
ln_prox:
    mov  ah, 01h
    int  21h
ln_ver:
    cmp  al, 13              ; ENTER?
    je   ln_fim
    cmp  al, ','
    je   ln_virg
    cmp  al, '.'
    je   ln_virg
    sub  al, '0'
    cmp  al, 9
    ja   ln_prox             ; nao e algarismo: ignora
    cmp  cx, MAXD
    jae  ln_mau              ; algarismos a mais
    mov  si, cx
    mov  [bx+si], al         ; BUF[CX] = algarismo
    inc  cx
    cmp  dh, 0
    je   ln_prox
    inc  di                  ; depois da virgula: mais uma casa decimal
    jmp  ln_prox
ln_virg:
    cmp  dh, 0
    jne  ln_mau              ; segunda virgula
    mov  dh, 1
    jmp  ln_prox
ln_mau:
    mov  dl, 1
    jmp  ln_prox
ln_fim:
    cmp  cx, 0
    je   ln_inv              ; nenhum algarismo
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

; =====================================================================
; para_array: BX = array. Copia os NDIG algarismos de BUF para o array,
; alinhados a direita (array = array x 10 + algarismo, um a um).
; =====================================================================
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

; =====================================================================
; zera: BX = array. Poe todas as posicoes a 0.
; =====================================================================
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

; =====================================================================
; empurra: BX = array, AL = algarismo. array = array x 10 + AL
; (todos os algarismos andam uma posicao para a esquerda).
; =====================================================================
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
    mov  [bx+si], dl         ; ultima posicao = algarismo novo
    mov  al, dl
    pop  si
    pop  dx
    pop  cx
    ret
empurra endp

; =====================================================================
; copia: copia o array SI para o array DI.
; =====================================================================
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

; =====================================================================
; compara: compara o array SI com o array DI, do algarismo mais
; significativo para o menos. Sai com as flags como "cmp SI, DI":
; ja/jae/jb/je funcionam a seguir.
; =====================================================================
compara proc
    push ax
    push cx
    push si
    push di
    mov  cx, LEN
c_loop:
    mov  al, [si]
    cmp  al, [di]
    jne  c_fim               ; primeira diferenca decide
    inc  si
    inc  di
    loop c_loop
    cmp  al, al              ; iguais: ZF = 1 e CF = 0
c_fim:
    pop  di
    pop  si
    pop  cx
    pop  ax
    ret
compara endp

; =====================================================================
; subtrai: array SI = array SI - array DI (SI >= DI), com "e vai um".
; =====================================================================
subtrai proc
    push ax
    push bx
    mov  bx, LEN-1
    xor  ah, ah              ; AH = emprestimo
s_loop:
    mov  al, [si+bx]
    sub  al, ah
    sub  al, [di+bx]         ; algarismo - emprestimo - algarismo
    mov  ah, 0
    jns  s_ok
    add  al, 10              ; ficou negativo: pede 10 emprestado
    mov  ah, 1
s_ok:
    mov  [si+bx], al
    dec  bx
    jns  s_loop
    pop  bx
    pop  ax
    ret
subtrai endp

; =====================================================================
; mul_dig: array DI = array SI x AL (AL e um algarismo de 0 a 9).
; Em cada posicao: produto = algarismo x AL + transporte; as dezenas
; sao contadas subtraindo 10 (sem usar div).
; =====================================================================
mul_dig proc
    push ax
    push bx
    push dx
    mov  dl, al              ; DL = multiplicador
    xor  dh, dh              ; DH = transporte
    mov  bx, LEN-1
m_loop:
    mov  al, [si+bx]
    mul  dl                  ; AX = algarismo x multiplicador
    add  al, dh              ; + transporte
    xor  dh, dh
m_dez:
    cmp  al, 9
    jbe  m_un                ; ja e menor que 10
    sub  al, 10              ; tira uma dezena
    inc  dh                  ; e conta-a no transporte
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

; =====================================================================
; e_zero: SI = array. Sai com ZF = 1 se todos os algarismos forem 0.
; =====================================================================
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

; =====================================================================
; escreve_arr: escreve o array SI sem os zeros a esquerda.
; CX = casas decimais (escreve a virgula antes delas).
; =====================================================================
escreve_arr proc
    push ax
    push bx
    push dx
    push di
    mov  di, LEN-1
    sub  di, cx              ; DI = posicao das unidades
    xor  bx, bx
ea_proc:
    cmp  bx, di
    jae  ea_loop             ; as unidades escrevem-se sempre
    mov  al, [si+bx]
    cmp  al, 0
    jne  ea_loop
    inc  bx                  ; salta zero a esquerda
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
    mov  dl, ','             ; virgula depois das unidades
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

; =====================================================================
; escreve_dig: escreve o algarismo AL.
; =====================================================================
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

; =====================================================================
; escreve_n8: escreve AL (0 a 99); as dezenas contam-se subtraindo 10.
; =====================================================================
escreve_n8 proc
    push ax
    xor  ah, ah              ; AH = dezenas
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
    call escreve_dig         ; dezenas
    pop  ax
n8_un:
    call escreve_dig         ; unidades
    pop  ax
    ret
escreve_n8 endp

; =====================================================================
; menos: escreve o sinal '-'.
; =====================================================================
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

; =====================================================================
; texto: escreve o texto (terminado em '$') cujo endereco esta em DX.
; =====================================================================
texto proc
    push ax
    mov  ah, 09h
    int  21h
    pop  ax
    ret
texto endp

end main
