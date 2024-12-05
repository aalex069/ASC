.section .note.GNU-stack,"",@progbits

.data
	op: .long 0
	space: .space 1048576
	occupied: .space 2048
	size: .long 0
	id: .long 0
	nr_op: .long 0
	nrf: .long 0
	left: .long 0
	aux: .long 0
	x: .long 0
	line: .long 0
	linedel: .long 0
	column: .long 0
	sizedefrag: .long 0
	format_scanf: .asciz "%d"
	format_scanfstr: .asciz "%s"
	format_printf: .asciz "%d:((%d, %d), (%d, %d))\n"
	format_get: .asciz "((%d, %d), (%d, %d))\n"
	format_test: .asciz "%d\n"
	true: .long 0
	max: .long 0
	
.text
   	ADD:
		pushl %ebp
		movl %esp, %ebp
		pushl %ebx
		xorl %eax, %eax
		movl 8(%ebp), %ecx
		movl %ecx, aux
		xorl %ebx, %ebx
		xorl %esi, %esi
		movl $1024, %edx
		cmp %edx, %ecx
		ja impossible
		xorl %ecx, %ecx
		jmp ADDinterval
		
		ADDlineAux:
			movl $1024, %ebx
			xorl %edx, %edx
			movl %ecx, %eax
			divl %ebx
			movl %eax, %ecx
			incl %ecx
			xorl %edx, %edx
			movl %ecx, %eax
			mull %ebx
			movl %eax, %ecx
			xorl %ebx, %ebx
			movl $1024, %edx
			xorl %esi, %esi

		ADDline:
			cmp $1048576, %ecx
			jae ADDexit

		ADDinterval:
			xorl %eax, %eax
			cmp $0, %edx
			je ADDlineAux
			addl %esi, %ecx
			cmpb %bl, (%edi, %ecx, 1)
			je intervalSizeAux
			subl %esi, %ecx
			decl %edx
			incl %esi
			jmp ADDinterval

		intervalSizeAux:
			movl %esi, left

		ADDsubAux:
			subl %esi, %ecx

		intervalSize:
			cmp $1024, %esi
			je ADDlineAux
			incl %eax
			incl %esi
			cmp aux, %eax
			je stop 
			addl %esi, %ecx
			cmpb %bl, (%edi, %ecx, 1)
			je ADDsubAux
			subl %esi, %ecx
			jmp ADDinterval
			
		stop:
			movl left, %esi
			movl 12(%ebp), %eax
			movl 8(%ebp), %edx

		ADDloop:
			cmp $0, %edx
			je ADDstop
			addl %esi, %ecx
			movb %al, (%edi, %ecx, 1)
			subl %esi, %ecx
			incl %esi
			decl %edx
			jmp ADDloop

		ADDstop:
			xorl %edx, %edx
			movl %ecx, %eax
			movl $1024, %ebx
			divl %ebx
			movl %eax, x
			leal occupied, %edi
			movl 8(%ebp), %edx
			subw %dx, (%edi, %eax, 2)
			leal space, %edi
			xorl %edx, %edx
			movl %ecx, %eax
			addl left, %eax
			divl %ebx
			movl %edx, left
			movl aux, %ebx
			addl left, %ebx
			decl %ebx
			
			pushl %ebx
			pushl x
			pushl left
			pushl x
			pushl 12(%ebp)
			pushl $format_printf
			call printf
			popl %eax
			popl %eax
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
		
		ADDexit:
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
		xorl %eax, %eax
		jmp GETloop

		GETlineAux:
			movl $1024, %ebx
			xorl %edx, %edx
			divl %ebx
			incl %eax
			xorl %edx, %edx
			mull %ebx
			movl $-1, %ebx
			xorl %esi, %esi

		GETline:
			cmp $1048576, %eax
			jae notFound

		GETloop:
			cmp $1024, %esi
			je GETlineAux
			addl %esi, %eax
			cmpb %cl, (%edi, %eax, 1)
			je start
			subl %esi, %eax
			incl %esi
			jmp GETloop

		start:
			cmp $-1, %ebx
			je Left
			cmp $1024, %esi
			je GETstop
			addl %esi, %eax
			cmpb %cl, (%edi, %eax, 1)
			jne GETstop
			subl %esi, %eax
			incl %edx
			incl %esi
			jmp start

		Left:
			movl %esi, %ebx
			movl %esi, %edx
			subl %esi, %eax
			incl %esi
			jmp start

		GETstop:
			movl %ebx, left
			movl %edx, aux
			xorl %edx, %edx
			movl $1024, %esi
			divl %esi

			movl %eax, %ecx
			movl left, %eax
			xorl %edx, %edx
			divl %esi
			movl %edx, left

			movl aux, %eax
			xorl %edx, %edx
			divl %esi
			movl %edx, aux

		
			pushl aux
			pushl %ecx
			pushl left
			pushl %ecx
			pushl $format_get
			call printf
			popl %eax
			popl %eax
			popl %eax
			popl %eax
			popl %eax
			popl %ebp
			ret

		notFound:
			xorl %ebx, %ebx
			pushl %ebx
			pushl %ebx
			pushl %ebx
			pushl %ebx
			pushl $format_get
			call printf
			popl %eax
			popl %eax
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
		xorl %eax, %eax
		movl %eax, linedel
		jmp DELETEloop

		DELETElineAux:
			movl $1024, %ebx
			xorl %edx, %edx
			divl %ebx
			incl %eax
			movl %eax, linedel
			xorl %edx, %edx
			mull %ebx
			movl 8(%ebp), %ebx
			xorl %esi, %esi

		DELTEline:
			cmp $1048576, %eax
			jae DELETEstop

		DELETEloop:
			cmp $1024, %esi
			je DELETElineAux
			addl %esi, %eax
			cmpb %bl, (%edi, %eax, 1)
			je DELETEid
			movb (%edi, %eax, 1), %bl
			cmpb $0, %bl
			je zero
			movl 8(%ebp), %ebx
			jmp DELETEaux

		zero:
			movl 8(%ebp), %ebx
			subl %esi, %eax
			incl %esi
			jmp DELETEloop

		DELETEid:
			movb $0, (%edi, %eax, 1)
			subl %esi, %eax
			leal occupied, %edi
			movl linedel, %edx
			addw $1, (%edi, %edx, 2)
			leal space, %edi
			incl %esi
			jmp DELETEloop

		DELETEaux:
			movb (%edi, %eax, 1), %cl
			movl %eax, left
			movl %eax, %edx

		DELETEout:
			cmpb %cl, (%edi, %eax, 1)
			jne DELETEoutput
			cmp $1024, %esi
			je DELETElineAux
			subl %esi, %eax
			incl %esi
			addl %esi, %eax
			incl %edx
			jmp DELETEout

		DELETEoutput:
			subl %esi, %eax
			movl %eax, line
			movl %esi, column
			decl %edx
			movl %edx, aux
			xorl %edx, %edx
			movl $1024, %esi
			divl %esi
			movl %eax, x

			movl left, %eax
			xorl %edx, %edx
			divl %esi
			movl %edx, left

			movl aux, %eax
			xorl %edx, %edx
			divl %esi
			movl %edx, aux

			pushl aux
			pushl x
			pushl left
			pushl x
			pushl %ecx
			pushl $format_printf
			call printf
			popl %ebx
			popl %ebx
			popl %ebx
			popl %ebx
			popl %ebx
			popl %ebx
			movl 8(%ebp), %ebx
			movl line, %eax
			movl column, %esi
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
		xorl %eax, %eax
		movl $1, %ebx
		movl $1, true
		movl %eax, x
		movl $1024, linedel
		jmp DEFRAGMENTATIONloop

		DEFRAGMENTATIONlineAux:
			movl linedel, %eax
			movl $1024, %ebx
			xorl %edx, %edx
			divl %ebx
			movl %eax, linedel
			movl %eax, aux
			movl %eax, x

			incl linedel
			movl linedel, %eax
			xorl %edx, %edx
			movl $1024, %ebx
			mull %ebx
			movl %eax, linedel
			movl aux, %eax
			xorl %edx, %edx
			mull %ebx
			movl $1, %ebx
			xorl %esi, %esi
			cmp true, %ebx
			jne DEFRAGMENTATIONend
			movl $0, true

		DEFRAGMENTATIONline:
			cmp $1048576, %eax
			jae DEFRAGMENTATIONend

		DEFRAGMENTATIONloop:
			cmp $1, %ebx
			jne DEFRAGMENTATIONstop
			cmp $999, %esi
			jae DEFRAGMENTATIONstop
			addl %esi, %eax
			movb (%edi, %eax, 1), %dl
			cmpb $0, %dl
			je shiftLeftAux
			subl %esi, %eax
			incl %esi
			jmp DEFRAGMENTATIONloop
		
		shiftLeftAux:
			xorl %ebx, %ebx
			movl %eax, %ecx
			incl %ecx
			subl %esi, %eax

		shiftLeft:
			cmp linedel, %ecx
			je DEFRAGMENTATIONloop
			movb (%edi, %ecx, 1), %dl
			decl %ecx
			movb %dl, (%edi, %ecx, 1)
			incl %ecx
			incl %ecx
			cmpb $0, %dl
			jne testare
			jmp shiftLeft

		testare:
			movl $1, %ebx
			movl %ebx, true
			jmp shiftLeft

		DEFRAGMENTATIONstop:
			xorl %esi, %esi
		
		DEFRAGMENTATIONout:
			cmp $1024, %esi
			je DEFRAGMENTATIONloop2Aux
			movl $-1, %edx
			movb (%edi, %eax, 1), %bl
			cmpb $0, %bl
			je DEFRAGMENTATIONloop2Aux
			jmp DEFRAGMENTATIONinterval
		
		DEFRAGMENTATIONinterval:
			cmp $-1, %edx
			je DEFRAGMENTATIONleft
			addl %esi, %eax
			cmpb %bl, (%edi, %eax, 1)
			jne DEFRAGMENTATIONoutput
			subl %esi, %eax
			incl %esi
			incl %ecx
			jmp DEFRAGMENTATIONinterval

		DEFRAGMENTATIONleft:
			incl %edx
			movl %eax, left
			movl %eax, %ecx
			subl %esi, %eax
			incl %esi
			jmp DEFRAGMENTATIONinterval

		DEFRAGMENTATIONoutput:
			subl %esi, %eax
			pushl %eax
			pushl %esi
			movl $1024, %esi
			xorl %edx, %edx
			movl left, %eax
			divl %esi
			movl %edx, left
			xorl %edx, %edx
			movl %ecx, %eax
			divl %esi
			movl %edx, column

			pushl column
			pushl x
			pushl left
			pushl x
			pushl %ebx
			pushl $format_printf
			call printf
			popl %edx
			popl %edx
			popl %edx
			popl %edx
			popl %edx
			popl %edx
			popl %esi
			popl %eax
			xorl %edx, %edx
			addl %esi, %eax
			jmp DEFRAGMENTATIONout

		DEFRAGMENTATIONloop2Aux:
			movl %eax, aux
			subl %esi, %eax
			xorl %edx, %edx
			movl $1024, %ebx
			divl %ebx
			movl linedel, %ecx
			movl %ecx, line
			leal occupied, %ebx
			movl %ecx, max
			addl $1024, max
			xorl %esi, %esi
			xorl %edx, %edx
			jmp DEFRAGMENTATIONloop2

		DEFRAGMENTATIONloop2:
			xorl %edx, %edx
			cmp $1048576, %ecx
			jae DEFRAGMENTATIONend
			cmp max, %ecx
			jae DEFRAGMENTATIONlineAux
			cmp $1024, %esi
			je DEFRAGMENTATIONlineAux
			addl %esi, %ecx
			movb (%edi, %ecx, 1), %dl
			cmpb $0, %dl
			jne DEFRAGMENTATIONaddIntervalAux
			subl %esi, %ecx
			incl %esi
			jmp DEFRAGMENTATIONloop2
		
		DEFRAGMENTATIONaddIntervalAux:
			movl %edx, id
			movl $-1, %eax
		
		DEFRAGMENTATIONaddInterval:
			cmp $1024, %esi
			je DEFRAGMENTATIONaddIntervalStop2
			cmp $-1, %eax
			je DEFRAGMENTATIONaddIntervalLeft
			addl %esi, %ecx
			cmpb %dl, (%edi, %ecx, 1)
			jne DEFRAGMENTATIONaddIntervalStop1
			subl %esi, %ecx
			incl sizedefrag
			incl %esi
			jmp DEFRAGMENTATIONaddInterval

		DEFRAGMENTATIONaddIntervalLeft:
			movl %ecx, left
			movl $1, sizedefrag
			subl %esi, %ecx
			incl %eax
			incl %esi
			jmp DEFRAGMENTATIONaddInterval

		DEFRAGMENTATIONaddIntervalStop1:
			subl %esi, %ecx

		DEFRAGMENTATIONaddIntervalStop2:
			movl x, %eax
			movw (%ebx, %eax, 2), %dx
			movl sizedefrag, %eax
			movl x, %eax
			cmpw sizedefrag, %dx
			jae DEFRAGMENTATIONaddIntervalTrue
			jmp DEFRAGMENTATIONlineAux
		
		DEFRAGMENTATIONaddIntervalTrue:
			pushl %eax
			pushl %ecx
			pushl %edx
			pushl id
			call DELETEdefrag
			popl %eax
			popl %edx
			popl %ecx
			popl %eax

			pushl %eax
			pushl %ecx
			pushl %edx
			pushl id
			pushl sizedefrag
			call ADDdefrag
			popl %eax
			popl %eax
			popl %edx
			popl %ecx
			popl %eax

			jmp DEFRAGMENTATIONloop2

		DEFRAGMENTATIONend:
			popl %ebp
			ret

	ADDdefrag:
		pushl %ebp
		movl %esp, %ebp
		pushl %ebx
		pushl %esi
		xorl %eax, %eax
		movl 8(%ebp), %ebx
		xorl %ecx, %ecx
		movl 12(%ebp), %ecx
		movl x, %eax
		movl $1024, %esi
		mull %esi
		movl %eax, %esi

		ADDintervalDefrag:
			movb (%edi, %esi, 1), %dl
			cmp $0, %dl
			je ADDloopDefragAux
			incl %esi
			jmp ADDintervalDefrag

		ADDloopDefragAux:
			movl %esi, column
		
		ADDloopDefrag:
			cmp $0, %ebx
			je ADDdefragStop
			movb %cl, (%edi, %esi, 1)
			incl %esi
			decl %ebx
			jmp ADDloopDefrag

		ADDdefragStop:
			movl column, %eax
			movl $1024, %ebx
			xorl %edx, %edx
			divl %ebx
			movl %edx, column
			movl %edx, %esi
			addl 8(%ebp), %esi
			decl %esi
			
			pushl %esi
			pushl x
			pushl column
			pushl x
			pushl %ecx
			pushl $format_printf
			call printf
			popl %eax
			popl %eax
			popl %eax
			popl %eax
			popl %eax
			popl %eax

			xorl %edx, %edx
			leal occupied, %ebx
			movl x, %eax
			movw 8(%ebp), %cx
			subw %cx, (%ebx, %eax, 2)

			popl %esi
			popl %ebx
			popl %ebp
			ret

	DELETEdefrag:
		pushl %ebp
		movl %esp, %ebp
		pushl %ebx
		pushl %esi
		xorl %eax, %eax
		movl 8(%ebp), %ebx
		xorl %edx, %edx

		DELETEloopDefrag:
			cmpb %bl, (%edi, %ecx, 1)
			je DELETEintervalDefrag
			incl %ecx
			jmp DELETEloopDefrag

		DELETEintervalDefrag:
			cmpb %bl, (%edi, %ecx, 1)
			jne DELETEdefragStop
			movb $0, (%edi, %ecx, 1)
			incl %ecx
			incl %edx
			jmp DELETEintervalDefrag

		DELETEdefragStop:
			movl %edx, %ecx
			xorl %edx, %edx
			movl line, %eax
			movl $1024, %ebx
			divl %ebx
			leal occupied, %ebx
			movl %ecx, %edx
			addw %dx, (%ebx, %eax, 2)
			popl %esi
			popl %ebx
			popl %ebp
			ret
	clear_input_buffer:
    	movl $3, %eax             # syscall: read
    	movl $0, %ebx             # file descriptor: stdin
    	leal -1(%esp), %ecx   # buffer to store input
    	movl $1, %edx             # read one byte
		clear_loop:
    		int $0x80                 # syscall interrupt
    		cmpb $'\n', (%ecx)        # check if newline
    		je clear_done             # stop if newline
    		test %eax, %eax           # check for EOF
    		je clear_done
    		jmp clear_loop
		clear_done:
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
	xorl %ebx, %ebx
	
	loopArray:
		cmp $1048576, %ecx
		je loopArrayAux
		movb $0, (%edi, %ecx, 1)
		incl %ecx
		jmp loopArray

	loopArrayAux:
		xorl %ecx, %ecx
		leal occupied, %edi
	
	loopArray2:
		cmp $1024, %ecx
		je end
		movw $1024, (%edi, %ecx, 2)
		incl %ecx
		jmp loopArray2

	end:
		leal space, %edi	
		movl nr_op, %ecx

	operations:
		cmp $0, %ecx
		je exit

		pushl %ecx
		call clear_input_buffer
		pushl $op
		pushl $format_scanf
		call scanf
		popl %eax
		popl %eax
		popl %ecx

		movl op, %eax
		movl op, %ebx
		cmp $1, %ebx
		je add
		cmp $2, %ebx
		je get
		cmp $3, %ebx
		je delete
		cmp $4, %ebx
		je defragmentation
		cmp $5, %ebx
		je concrete

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
		pushl %eax
		pushl %ecx
		pushl %edx
		call DEFRAGMENTATION
		popl %edx
		popl %ecx
		popl %eax

		xorl %ebx, %ebx
		jmp oploop

	concrete:
		jmp exit
	exit:
		leal occupied, %eax
		movl $1, %eax
		xorl %ebx, %ebx
		int $0x80
		