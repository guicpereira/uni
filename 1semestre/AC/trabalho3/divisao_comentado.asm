; =====================================================================
; TAREFA 3 - 1. DIVISAO INTEIRA COM ARRAYS (emu8086)
; Algoritmo da aula (divisao "a mao", algarismo a algarismo):
;   - o dividendo e o divisor sao lidos do teclado e guardados em arrays,
;     um algarismo por posicao; podem ser negativos e/ou ter virgula;
;   - as casas decimais sao igualadas (acrescentando zeros), ficando
;     uma divisao de inteiros;
;   - em cada passo: numero = numero anterior x 10 + algarismo seguinte;
;     faz-se a tabuada do divisor (divisor x 1, x 2, ...) ate passar o
;     numero e usa-se o algarismo anterior;
;     resto = numero - divisor x algarismo;
;     quociente = quociente x 10 + algarismo.
; As contas sobre os arrays usam apenas adicao, subtracao e multiplicacao
; (nao se usa a instrucao div).
; =====================================================================
.model small
.stack 100h

LEN  equ 26              ; tamanho de cada array (algarismos)
MAXD equ 12              ; maximo de algarismos que se podem escrever

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
    BUF     db LEN dup(0)    ; algarismos tal como foram escritos
    NUMA    db LEN dup(0)    ; dividendo (alinhado a direita)
    NUMB    db LEN dup(0)    ; divisor
    PARC    db LEN dup(0)    ; numero do passo atual / resto
    PROD    db LEN dup(0)    ; divisor x k (tabuada)
    PRODOK  db LEN dup(0)    ; maior produto que nao passa o numero
    QUO     db LEN dup(0)    ; quociente
    NDIG    dw ?             ; algarismos lidos
    NDEC    dw ?             ; casas decimais lidas
    SINAL   db ?             ; 1 se o numero lido for negativo
    SA      db ?             ; sinal do dividendo
    SB      db ?             ; sinal do divisor
    DECA    dw ?             ; casas decimais do dividendo
    DECB    dw ?             ; casas decimais do divisor
    NDECF   dw ?             ; casas decimais depois de igualar
    POS     dw ?             ; posicao do algarismo do dividendo a descer
    PASSO   db ?             ; numero do passo
    DIG     db ?             ; algarismo que desce
    K       db ?             ; algarismo do quociente

.code
main:
    mov  ax, @data
    mov  ds, ax
    lea  dx, msgTit
    call texto

; ---------- ler o dividendo para o array NUMA ----------
le_a:
    lea  dx, msgA
    call texto
    call ler_num             ; BUF, NDIG, NDEC, SINAL; CF = 1 se invalido
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
    call para_array          ; copia BUF para NUMA

; ---------- ler o divisor para o array NUMB ----------
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
    call e_zero              ; ZF = 1 se o divisor for 0
    jne  b_nz
    lea  dx, msgZero
    call texto
    jmp  le_b
b_nz:

; ---------- igualar as casas decimais (acrescentar zeros) ----------
    mov  ax, DECA
    mov  cx, DECB
    cmp  ax, cx
    jae  al_b                ; o dividendo tem mais (ou iguais) casas
    sub  cx, ax              ; CX = zeros a acrescentar ao dividendo
    lea  bx, NUMA
al_a:
    mov  al, 0
    call empurra             ; NUMA = NUMA x 10 + 0
    loop al_a
    mov  ax, DECB
    jmp  al_fim
al_b:
    mov  cx, ax
    sub  cx, DECB            ; CX = zeros a acrescentar ao divisor
    cmp  cx, 0
    je   al_fim0             ; nada a acrescentar
    lea  bx, NUMB
al_b2:
    mov  al, 0
    call empurra             ; NUMB = NUMB x 10 + 0
    loop al_b2
al_fim0:
    mov  ax, DECA
al_fim:
    mov  NDECF, ax
    cmp  ax, 0
    je   sem_dec
    lea  dx, msgSemV         ; mostra a divisao de inteiros equivalente
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

; ---------- divisao algarismo a algarismo ----------
    lea  bx, PARC
    call zera
    lea  bx, QUO
    call zera
    lea  si, NUMA            ; procura o 1.o algarismo diferente de 0
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
    lea  dx, msgPas          ; "Passo n: numero = "
    call texto
    mov  al, PASSO
    call escreve_n8
    lea  dx, msgNum
    call texto
    mov  bx, POS             ; algarismo que desce
    lea  si, NUMA
    mov  al, [si+bx]
    mov  DIG, al
    mov  al, PASSO
    cmp  al, 1
    je   c_prim              ; no 1.o passo nao ha numero anterior
    lea  si, PARC            ; "anterior x 10 + algarismo = "
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
    call empurra             ; numero = numero anterior x 10 + algarismo
    lea  si, PARC
    xor  cx, cx
    call escreve_arr

; ----- verificar numero >= divisor -----
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
    call compara             ; compara numero com divisor
    jae  c_sim
    lea  dx, msgNao
    call texto
    mov  al, 0
    mov  K, al               ; algarismo do quociente = 0
    jmp  c_quoc

; ----- tabuada do divisor: divisor x 1, x 2, ... -----
c_sim:
    lea  dx, msgSim
    call texto
    mov  al, 1
    mov  K, al
c_tab:
    lea  si, NUMB
    lea  di, PROD
    mov  al, K
    call mul_dig             ; PROD = divisor x K
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
    call compara             ; o produto passou o numero?
    ja   c_passou
    lea  si, PROD            ; ainda nao passou: guarda-o
    lea  di, PRODOK
    call copia
    mov  al, K
    cmp  al, 9
    je   c_sub               ; 9 e o maior algarismo
    inc  al
    mov  K, al
    jmp  c_tab
c_passou:
    lea  dx, msgMai          ; " > numero -> usar k-1"
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

; ----- resto = numero - divisor x algarismo -----
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
    call subtrai             ; PARC = PARC - PRODOK
    lea  si, PARC
    xor  cx, cx
    call escreve_arr

; ----- quociente = quociente x 10 + algarismo -----
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
    mov  bx, POS             ; passa ao algarismo seguinte
    inc  bx
    mov  POS, bx
    cmp  bx, LEN-1
    ja   fim_ciclo           ; ja nao ha algarismos
    jmp  ciclo
fim_ciclo:

; ---------- resultado final ----------
    lea  dx, msgFim
    call texto
    lea  dx, msgQ
    call texto
    lea  si, QUO
    call e_zero
    je   q_pos               ; quociente 0 nao leva sinal
    mov  al, SA
    mov  ah, SB
    cmp  al, ah
    je   q_pos               ; sinais iguais: positivo
    call menos
q_pos:
    lea  si, QUO
    xor  cx, cx
    call escreve_arr
    lea  dx, msgR
    call texto
    lea  si, PARC
    xor  cx, cx              ; resto 0: escreve so "0"
    call e_zero
    je   r_pos
    mov  cx, NDECF           ; o resto tem as casas decimais igualadas
    mov  al, SA              ; o resto tem o sinal do dividendo
    cmp  al, 0
    je   r_pos
    call menos
r_pos:
    lea  si, PARC
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
