
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h

; add your code here
   .model small
.stack 100h
.data
x  dw 3
y  dw 5
z  dw 5
T  dw 1
N  dw ?
D  dw ?
W  dw ?
R  dw ?

.code
main:
    mov ax, @data
    mov ds, ax

    ; N = (x+z) - T*(z-y) - x
    mov bx, z
    sub bx, y        ; BX = z-y
    mov ax, T
    mul bx           ; DX:AX = T*(z-y)
    mov cx, ax       ; CX = T*(z-y)
    mov ax, x
    add ax, z        ; AX = x+z
    sub ax, cx       ; AX = x+z-T*(z-y)
    sub ax, x        ; AX = N
    mov N, ax

    ; D = x + y - z - T
    mov ax, x
    add ax, y
    sub ax, z
    sub ax, T
    mov D, ax

    ; W = N / D
    mov ax, N
    mov bx, D
    mov dx, 0        ; DX:AX = N
    div bx           ; AX = quociente, DX = resto
    mov W, ax
    mov R, dx

    mov ah, 4Ch      ; terminar o programa
    int 21h
end main
ret




