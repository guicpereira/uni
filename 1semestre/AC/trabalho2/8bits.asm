
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h

; add your code here
    .model small
.stack 100h
.data
x  db 3
y  db 5
z  db 5
T  db 1
N  db ?
D  db ?
W  db ?
R  db ?

.code
main:
    mov ax, @data
    mov ds, ax

    ; N = (x+z) - T*(z-y) - x
    mov bl, z
    sub bl, y        ; BL = z-y
    mov al, T
    mul bl           ; AX = T*(z-y)
    mov cl, al       ; CL = T*(z-y)
    mov al, x
    add al, z        ; AL = x+z
    sub al, cl       ; AL = x+z-T*(z-y)
    sub al, x        ; AL = N
    mov N, al

    ; D = x + y - z - T
    mov al, x
    add al, y
    sub al, z
    sub al, T
    mov D, al

    ; W = N / D
    mov al, N
    mov bl, D
    mov ah, 0        ; AX = N
    div bl           ; AL = quociente, AH = resto
    mov W, al
    mov R, ah

    mov ah, 4Ch      ; terminar o programa
    int 21h
end main
ret




