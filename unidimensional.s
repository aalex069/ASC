.section .note.GNU-stack,"",@progbits

.data
	space: .space 1000
	size: .long 0
	id: .long 0
	nr_op: .long 0
	op: .long 0
	nrf: .long 0
	left: .long 0
	format_scanf: .asciz "%d"
	format_printf: .asciz "%d: (%d, %d)\n"
	format_get: .asciz "(%d, %d)\n"
	error: .asciz "Not enough space\n"
.text
	ADD:
		pushl %ebp
		movl %esp, %ebp
		pushl %ebx
		xorl %eax, %eax
		movl 8(%ebp), %ecx
		xorl %ebx, %ebx
		movl $1000, %edx
		xorl %esi, %esi
		cmp %edx, %ecx
		ja impossible

		ADDinterval:
			xorl %eax, %eax
			cmp $0, %edx
			je impossible
			cmpb %bl, (%edi, %esi, 1)
			je intervalSizeAux
			decl %edx
			incl %esi
			jmp ADDinterval

		intervalSizeAux:
			movl %esi, left

		intervalSize:
			incl %eax
			incl %esi
			cmp %ecx, %eax
			je stop 
			cmpb %bl, (%edi, %esi, 1)
			je intervalSize
			jmp ADDinterval
			
		stop:
			movl 12(%ebp), %eax
			movl left, %edx
			movl left, %esi
			movl left, %ebx
			addl %ecx, %ebx

		ADDloop:
			cmp $0, %ecx
			je ADDstop
			movb %al, (%edi, %esi, 1)
			incl %esi
			loop ADDloop

		ADDstop:
			decl %ebx
			pushl %ebx
			pushl %edx
			pushl %eax
			pushl $format_printf
			call printf
			popl %eax
			popl %eax
			popl %eax
			popl %eax
			popl %ebx
			popl %ebp
			ret
		
		impossible:
			popl %ebx
			popl %ebp
			ret

	GET:
		pushl %ebp
		movl %esp, %ebp
		xorl %edx, %edx
		movl $-1, %ebx
		xorl %esi, %esi
		xorl %ecx, %ecx
		movl 8(%ebp), %ecx

		GETloop:
			cmp $999, %esi
			je notFound
			cmpb %cl, (%edi, %esi, 1)
			je start
			incl %esi
			jmp GETloop

		start:
			cmp $-1, %ebx
			je Left
			cmpb %cl, (%edi, %esi, 1)
			jne GETstop
			incl %edx
			incl %esi
			jmp start

		Left:
			movl %esi, %ebx
			movl %esi, %edx
			incl %esi
			jmp start

		GETstop:
			pushl %edx
			pushl %ebx
			pushl $format_get
			call printf
			popl %eax
			popl %eax
			popl %eax
			popl %ebp
			ret

		notFound:
			xorl %ebx, %ebx
			pushl %ebx
			pushl %ebx
			pushl $format_get
			call printf
			popl %eax
			popl %eax
			popl %eax
			popl %ebp
			ret

	DELETE:
		pushl %ebp
		movl %esp, %ebp
		movl 8(%ebp), %ebx
		xorl %esi, %esi

		DELETEloop:
			cmp $999, %esi
			je DELETEstop
			cmpb %bl, (%edi, %esi, 1)
			je DELETEid
			movb (%edi, %esi, 1), %al
			cmpb $0, %al
			je zero
			jmp aux

		zero:
			incl %esi
			jmp DELETEloop

		DELETEid:
			movb $0, (%edi, %esi, 1)
			incl %esi
			jmp DELETEloop

		aux:
			movb (%edi, %esi, 1), %cl
			movl %esi, %eax
			movl %esi, %edx

		DELETEout:
			cmpb %cl, (%edi, %esi, 1)
			jne DELETEoutput
			incl %esi
			incl %edx
			jmp DELETEout

		DELETEoutput:
			decl %edx
			pushl %edx
			pushl %eax
			pushl %ecx
			pushl $format_printf
			call printf
			popl %eax
			popl %eax
			popl %eax
			popl %eax
			jmp DELETEloop

		DELETEstop:
			popl %ebp
			ret

	DEFRAGMENTATION:
		pushl %ebp
		movl %esp, %ebp
		xorl %esi, %esi
		movl $1, %ebx
		xorl %edx, %edx

		DEFRAGMENTATIONloop:
			cmp $1, %ebx
			jne DEFRAGMENTATIONstop
			cmp $999, %esi
			jae DEFRAGMENTATIONstop
			movb (%edi, %esi, 1), %dl
			cmpb $0, %dl
			je shiftLeftAux
			incl %esi
			jmp DEFRAGMENTATIONloop

		shiftLeftAux:
			xorl %ebx, %ebx
			movl %esi, %ecx
			movl %esi, %eax
			incl %eax

		shiftLeft:
			cmp $999, %ecx
			jae DEFRAGMENTATIONloop
			cmp $999, %eax
			jae DEFRAGMENTATIONloop
			movb (%edi, %eax, 1), %dl
			movb %dl, (%edi, %ecx, 1)
			incl %ecx
			incl %eax
			cmpb $0, %dl
			jne testare
			jmp shiftLeft

		testare:
			movl $1, %ebx
			jmp shiftLeft

		DEFRAGMENTATIONstop:
			xorl %esi, %esi
		
		DEFRAGMENTATIONout:
			movl $-1, %eax
			movb (%edi, %esi, 1), %bl
			cmpb $0, %bl
			je DEFRAGMENTATIONend
			jmp DEFRAGMENTATIONinterval
		
		DEFRAGMENTATIONinterval:
			cmp $-1, %eax
			je DEFRAGMENTATIONleft
			cmpb %bl, (%edi, %esi, 1)
			jne DEFRAGMENTATIONoutput
			incl %esi
			incl %ecx
			jmp DEFRAGMENTATIONinterval

		DEFRAGMENTATIONleft:
			movl %esi, %eax
			movl %esi, %ecx
			incl %esi
			jmp DEFRAGMENTATIONinterval

		DEFRAGMENTATIONoutput:
			pushl %ecx
			pushl %eax
			pushl %ebx
			pushl $format_printf
			call printf
			popl %edx
			popl %edx
			popl %edx
			popl %edx
			jmp DEFRAGMENTATIONout

		DEFRAGMENTATIONend:
			popl %ebp
			ret

.global main
main:
	pushl $nr_op
	pushl $format_scanf
	call scanf
	popl %eax
	popl %eax

	leal space, %edi
	xorl %ecx, %ecx

	looparray:
		cmp $1000, %ecx
		je end 
		movb $0, (%edi, %ecx, 1)
		incl %ecx
		jmp looparray

	end:
		movl nr_op, %ecx

	operations:
		cmp $0, %ecx
		je exit

		pushl %ecx
		pushl $op
		pushl $format_scanf
		call scanf
		popl %eax
		popl %eax
		popl %ecx

		movl op, %ebx
		cmp $1, %ebx
		je add
		cmp $2, %ebx
		je get
		cmp $3, %ebx
		je delete
		cmp $4, %ebx
		je defragmentation

	add:
		pushl %ecx
		pushl $nrf
		pushl $format_scanf
		call scanf
		popl %eax
		popl %eax
		popl %ecx
		movl nrf, %ebx

	addloop:
		cmp $0, %ebx
		je oploop

		pushl %ecx
		pushl $id
		pushl $format_scanf
		call scanf
		popl %eax
		popl %eax
		popl %ecx

		pushl %ecx
		pushl $size
		pushl $format_scanf
		call scanf
		popl %eax
		popl %eax
		popl %ecx

		movl size, %eax
		xorl %edx, %edx
		movl $8, %esi
		divl %esi
		cmp $0, %edx
		ja calc

		pushl %ecx
		pushl id
		pushl %eax
		call ADD
		popl %edx
		popl %edx
		popl %ecx
		decl %ebx
		jmp addloop

	calc:
		incl %eax
		pushl %ecx
		pushl id
		pushl %eax
		call ADD
		popl %edx
		popl %edx
		popl %ecx
		decl %ebx
		jmp addloop

	oploop:
		decl %ecx
		jmp operations

	get:
		pushl %ecx
		pushl $id
		pushl $format_scanf
		call scanf
		popl %eax
		popl %eax
		popl %ecx

		movl id, %ebx
		pushl %ecx
		pushl %ebx
		call GET
		popl %eax
		popl %ecx
		jmp oploop

	delete:
		pushl %ecx
		pushl $id
		pushl $format_scanf
		call scanf
		popl %eax
		popl %eax
		popl %ecx

		movl id, %ebx
		pushl %ecx
		pushl %ebx
		call DELETE
		popl %eax
		popl %ecx
		jmp oploop

	defragmentation:
		pushl %ecx
		call DEFRAGMENTATION
		popl %ecx
		jmp oploop

	exit:
		movl $1, %eax
		xorl %ebx, %ebx
		int $0x80

	
