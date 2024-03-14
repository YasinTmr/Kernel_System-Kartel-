     name "loader"
; this is a very basic example of a tiny operating system.

; directive to create boot file:
   #make_boot#

; this is an os loader only!
;
; it can be loaded at the first sector of a floppy disk:

;   cylinder: 0
;   sector: 1
;   head: 0



;=================================================
; how to test micro-operating system:
;   1. compile micro-os_loader.asm
;   2. compile micro-os_kernel.asm
;   3. compile writebin.asm
;   4. insert empty floppy disk to drive a:
;   5. from command prompt type:
;        writebin loader.bin
;        writebin kernel.bin /k
;=================================================


;
; The code in this file is supposed to load
; the kernel (micro-os_kernel.asm) and to pass control over it.
; The kernel code should be on floppy at:

;   cylinder: 0
;   sector: 2
;   head: 0

; memory table (hex):
; -------------------------------
; 07c0:0000 |   boot sector
; 07c0:01ff |   (512 bytes)
; -------------------------------
; 07c0:0200 |    stack
; 07c0:03ff |   (255 words)
; -------------------------------
; 0800:0000 |    kernel
; 0800:1400 | 
;           |   (currently 5 kb,
;           |    10 sectors are
;           |    loaded from
;           |    floppy)
; -------------------------------


; To test this program in real envirinment write it to floppy
; disk using compiled writebin.asm
; After sucessfully compilation of both files,
; type this from command prompt:   writebin loader.bin   

; Note: floppy disk boot record will be overwritten.
;       the floppy will not be useable under windows/dos until
;       you reformat it, data on floppy disk may be lost.
;       use empty floppy disks only.


; micro-os_loader.asm file produced by this code should be less or
; equal to 512 bytes, since this is the size of the boot sector.



; boot record is loaded at 0000:7c00
org 7c00h

; initialize the stack:
mov     ax, 07c0h
mov     ss, ax
mov     sp, 03feh ; top of the stack.


; set data segment:
xor     ax, ax
mov     ds, ax

; set default video mode 80x25:
mov     ah, 00h
mov     al, 03h
int     10h

; print welcome message:
lea     si, msg
call    print_string 

pusha

;--------------------------------************************************* 
mov ah, 0
mov al, 13h 
int 10h 

;----   

; en ustu:
    
    mov cx, 220  ; column sutun
    mov dx, 40     ; row    satir
    mov al, 15     ; white
a1: mov ah, 0ch    ; put pixel
    int 10h
    
    dec cx
    cmp cx, 100
    jae a1

; alt kisim:
    
    mov cx, 220  ; column sutun
    mov dx, 70    ; row    satir
    mov al, 15     ; white
a2: mov ah, 0ch    ; put pixel
    int 10h
    
    dec cx
    cmp cx, 100
    jae a2



; ic detay:

    mov cx, 120    ; column
    mov dx, 70   ; row
    mov al, 15     ; white
a3: mov ah, 0ch    ; put pixel
    int 10h
    
    dec dx
    cmp dx, 40
    ja a3

; en sol ust:

    mov cx, 100    ; column
    mov dx, 130   ; row
    mov al, 15     ; white
a4: mov ah, 0ch    ; put pixel
    int 10h
    
    dec dx
    cmp dx, 40
    ja a4

; tutma yeri sagi:

    mov cx, 130    ; column
    mov dx, 130   ; row
    mov al, 15     ; white
a5: mov ah, 0ch    ; put pixel
    int 10h
    
    dec dx
    cmp dx, 70
    ja a5

; en taban:
    
    mov cx, 130  ; column sutun
    mov dx, 130    ; row    satir
    mov al, 15     ; white
a6: mov ah, 0ch    ; put pixel
    int 10h
    
    dec cx
    cmp cx, 100
    jae a6
    
; namlu baslangic duz:

    mov cx, 220    ; column
    mov dx, 70   ; row
    mov al, 15     ; white
a7: mov ah, 0ch    ; put pixel
    int 10h
    
    dec dx
    cmp dx, 40
    ja a7
    
; uc kisim ust:
    
    mov cx, 260  ; column sutun
    mov dx, 50     ; row    satir
    mov al, 15     ; white
a8: mov ah, 0ch    ; put pixel
    int 10h
    
    dec cx
    cmp cx, 220
    jae a8
    
    ; uc kisim alt:
    
    mov cx, 260  ; column sutun
    mov dx, 60     ; row    satir
    mov al, 15     ; white
a9: mov ah, 0ch    ; put pixel
    int 10h
    
    dec cx
    cmp cx, 220
    jae a9
    
; ic detay:

    mov cx, 260    ; column
    mov dx, 60   ; row
    mov al, 15     ; white
a10: mov ah, 0ch    ; put pixel
    int 10h
    
    dec dx
    cmp dx, 50
    ja a10    

; nisangah detay:

    mov cx, 180    ; column
    mov dx, 40   ; row
    mov al, 15     ; white
a11: mov ah, 0ch    ; put pixel
    int 10h
    
    dec dx
    cmp dx, 35
    ja a11
    
     
    mov cx, 185    ; column
    mov dx, 40   ; row
    mov al, 15     ; white
a12: mov ah, 0ch    ; put pixel
    int 10h
    
    dec cx
    dec dx
    cmp dx, 35
    ja a12
;------------------------------------------- 

mov ah,02h
mov dh,15h   ;satir
mov dl, 9h  ;sutun
int 10h
mov si,0     
lea     si, msg2
call    print_string

;
; en taban2:
    
mov cx, 190  ; column sutun
    mov dx, 180    ; row    satir
    mov al, 15     ; white
a13: mov ah, 0ch    ; put pixel
    int 10h 
    dec cx
    cmp cx, 100
    jae a13

;
popa

mov     ah, 00h
mov     al, 03h
int     10h
;===================================
; load the kernel at 0800h:0000h
; 10 sectors starting at:
;   cylinder: 0
;   sector: 2
;   head: 0

; BIOS passes drive number in dl,
; so it's not changed:

mov     ah, 02h ; read function.
mov     al, 10  ; sectors to read.
mov     ch, 0   ; cylinder.
mov     cl, 2   ; sector.
mov     dh, 0   ; head.
; dl not changed! - drive number.

; es:bx points to receiving
;  data buffer:
mov     bx, 0800h   
mov     es, bx
mov     bx, 0

; read!
int     13h
;===================================

; integrity check:
cmp     es:[0000],0E9h  ; first byte of kernel must be 0E9 (jmp).
je     integrity_check_ok

; integrity check error
lea     si, err
call    print_string

; wait for any key...
mov     ah, 0
int     16h

; store magic value at 0040h:0072h:
;   0000h - cold boot.
;   1234h - warm boot.
mov     ax, 0040h
mov     ds, ax
mov     w.[0072h], 0000h ; cold boot.
jmp	0ffffh:0000h	     ; reboot!

;===================================

integrity_check_ok:
; pass control to kernel:
jmp     0800h:0000h

;===========================================



print_string proc near
push    ax      ; store registers...
push    si      ;
next_char:      
        mov     al, [si]
        cmp     al, 0
        jz      printed
        inc     si
        mov     ah, 0eh ; teletype function.
        int     10h
        jmp     next_char
printed:
pop     si      ; re-store registers...
pop     ax      ;
ret
print_string endp

                       
                       
                       
;==== data section =====================
msg2 db "Evinizin karteli  ",0dh,0ah,0
msg  db "Loading...",0Dh,0Ah, 0 
     
err  db "invalid data at sector: 2, cylinder: 0, head: 0 - integrity check failed.", 0Dh,0Ah
     db "refer to tutorial 11 - making your own operating system.", 0Dh,0Ah
     db "System will reboot now. Press any key...", 0
    
;======================================
