%include "asm_io.inc"

SECTION .data
errorStr: db "Bad arguments. Expects one integer argument between 2 and 9", 0
XStr: db "XXXXXXXXXXXXXXXXXXXXXXX", 0
initial: db "Initial configuration:", 0
final: db "Final configuration:", 0
peg: dd 0,0,0,0,0,0,0,0,0
total: dd 0

SECTION .bss

SECTION .text

global asm_main
asm_main:
	enter 0,0

	mov eax, [ebp+8]
	cmp eax, 2
	jne Error

Check_arg:
	mov ebx, [ebp+12]
	mov edx, [ebx+4]
	cmp [edx], byte '2'
	jb Error
	cmp [edx], byte '9'
	ja Error
	cmp [edx+1], byte 0
	jne Error
	jmp Main

Error:
	mov eax, errorStr
	call print_string
	call print_nl
	jmp ending

Main:
	mov ebx, [ebp+12]
	mov edx, [ebx+4]
	mov al, byte [edx]
	sub eax, dword '0'
	mov [total], eax

	mov eax, initial
	call print_string
	call print_nl

	mov eax, [total]
	push eax
	push peg
	call rconf
	add esp, 8

	mov eax, [total]
	push eax
	push peg
	call showp
	add esp, 8

	mov eax, [total]
	push eax
	push peg
	call sorthem
	add esp, 8

	mov eax, final
	call print_string
	call print_nl

	mov eax, [total]
	push eax
	push peg
	call showp
	add esp, 8

ending:
	leave
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
showp:
	mov ecx, [esp+8]
	mov ebx, [esp+4]

	call printDisks
	mov eax, XStr
	call print_string
	call print_nl
	call read_char
	ret

;;;;;;;;;;;
printDisks:
	cmp ecx, dword 1
	je printDisk
	push ecx
	push ebx
	dec ecx
	add ebx,4
	call printDisks
	pop ebx
	pop ecx

printDisk:
	mov ecx, dword 11
	sub ecx, [ebx]

disks_Loop:
	mov eax, ' '
	call print_char
	loop disks_Loop
	mov ecx, [ebx]

disks0Loop:
	mov eax, '0'
	call print_char
	loop disks0Loop
	mov eax, '|'
	call print_char
	mov ecx, [ebx]

disks0Loop2:
	mov eax, '0'
	call print_char
	loop disks0Loop2
	call print_nl
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
sorthem:
	mov ecx, [esp+8]
	mov ebx, [esp+4]

	push ebx
	push ecx
	mov eax, [total]
	push eax
	push peg
	call showp
	add esp, 8
	pop ecx
	pop ebx

	call sortRec
	ret

sortRec:
	cmp ecx, dword 2
	je diskSort
	push ecx
	push ebx
	dec ecx
	add ebx,4
	call sortRec
	pop ebx
	pop ecx


diskSort:

	mov eax, [ebx]
	cmp eax,[ebx+4]
	ja sortEnd

;swaps [ebx] and [ebx+4], found at: https://www.daniweb.com/programming/software-development/threads/355190/assembler-swap-2-integer-values
	mov eax,[ebx]
	mov edi,ebx
	add edi, 4
	mov edx,[edi]
	mov [ebx],edx
	mov [edi],eax

	add ebx, 4
	dec ecx
	cmp ecx, dword 1
	ja diskSort

sortEnd:
	push ebx
	push ecx
	mov eax, [total]
	push eax
	push peg
	call showp
	add esp, 8
	pop ecx
	pop ebx

	ret
