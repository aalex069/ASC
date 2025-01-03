.section .note.GNU-stack,"",@progbits

.data
	op: .long 0
	space: .space 1048576
	occupied: .space 2048
	fd: .space 256
	fd_close: .space 4096
	size: .long 0
	id: .long 0
	nr_op: .long 0
	nrf: .long 0
	left: .long 0
	aux: .long 0
	x: .long 0
	cnt: .long 0
	line: .long 0
	linedel: .long 0
	linemax: .long 0
	column: .long 0
	directory: .space 256
	directory_fd: .space 256
	file: .space 256
	file_fd: .space 256
	stat_buffer: .space 1024
	getdentsbuffer: .space 1024
	concat_string: .space 1024
	buffer_size: .space 1024
	current_dir: .asciz "."
	parent_dir: .asciz ".."
	sizegetdents: .space 256
	sizedefrag: .long 0
	name: .space 256
	concrete_error: .asciz "director invalid\n"
	format_scanf: .asciz "%d"
	format_scanfstr: .asciz "%s"
	format_printf: .asciz "%d: ((%d, %d), (%d, %d))\n"
	format_get: .asciz "((%d, %d), (%d, %d))\n"
	format_concrete: .asciz "(%d, %d)\n"
	format_test: .asciz "%s\n"
	true: .long 0
	max: .long 0
	rez: .long 0
	
.text
   	ADD:
		pushl %ebp
		movl %esp, %ebp
		pushl %ebx
		xorl %eax, %eax
		movl 8(%ebp), %ecx
		cmp $1, %ecx
		jle impossible
		movl %ecx, aux
		xorl %ebx, %ebx
		xorl %esi, %esi
		movl $1024, %edx
		cmp %edx, %ecx
		ja impossible
		leal fd , %edi
		xorl %ecx, %ecx
		movl 12(%ebp), %ecx
		cmpb (%edi, %ecx, 1), %cl
		jne impossible
		leal space, %edi
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
			jae impossible

		ADDinterval:
			xorl %eax, %eax
			cmp $0, %edx
			je ADDlineAux
			cmp $1024, %esi
			je ADDlineAux
			addl %esi, %ecx
			cmp $1048576, %ecx
			jae impossible
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
			cmp $1048576, %ecx
			jae impossible
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
			cmp $1048576, %ecx
			jae impossible
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
			xorl %ecx, %ecx
			leal fd, %edi
			movl 12(%ebp), %ecx
			movb $0, (%edi, %ecx, 1)
			leal space, %edi
			popl %ebx
			popl %ebp
			ret
		
		impossible:
			leal space, %edi
			pushl %ebx
			pushl %ebx
			pushl %ebx
			pushl %ebx
			pushl 12(%ebp)
			pushl $format_printf
			call printf
			popl %ebx
			popl %ebx
			popl %ebx
			popl %ebx
			popl %ebx
			popl %ebx
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
			leal fd, %edi
			movb %bl, (%edi, %ebx, 1)
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
		jmp DEFRAGMENTATIONloop

		DEFRAGMENTATIONloopAux:
			decl %ecx
			movb $0, (%edi, %ecx, 1)
			incl %ecx
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

		DEFRAGMENTATIONline:
			cmp $1048576, %eax
			jae DEFRAGMENTATIONend

		DEFRAGMENTATIONloop:
			cmp $1, %ebx
			jne DEFRAGMENTATIONstop
			cmp $1023, %esi
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
			pushl %eax
			pushl %edx
			movl $1024, %ebx
			xorl %edx, %edx
			divl %ebx
			movl %eax, linedel
			incl linedel
			xorl %edx, %edx
			movl linedel, %eax
			mull %ebx
			movl %eax, linedel
			popl %edx
			popl %eax
			xorl %ebx, %ebx

		shiftLeft:
			cmp linedel, %ecx
			je DEFRAGMENTATIONloopAux
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
			movl %eax, %ecx
			incl %ecx
			movl %ecx, line
			movl linedel, %ecx
			leal occupied, %ebx
			xorl %esi, %esi
			xorl %edx, %edx
			jmp DEFRAGMENTATIONloop2

		DEFRAGMENTATIONloop2line:
			movl true, %edx
			cmp $1, %edx
			jne DEFRAGMENTATIONlineAux
			movl %ecx, %eax
			xorl %edx, %edx
			movl $1024, %esi
			divl %esi
			movl %eax, %ecx
			incl %ecx
			movl %ecx, line
			movl %ecx, %eax
			xorl %edx, %edx
			mull %esi
			movl %eax, %ecx
			xorl %esi, %esi
			xorl %edx, %edx
			movl x, %eax
			movl $0, true

		DEFRAGMENTATIONloop2:
			xorl %edx, %edx
			cmp $1048576, %ecx
			jae DEFRAGMENTATIONlineAux
			cmp $1024, %esi
			je DEFRAGMENTATIONloop2line
			addl %esi, %ecx
			movb (%edi, %ecx, 1), %dl
			cmpb $0, %dl
			jne DEFRAGMENTATIONaddIntervalAux
			subl %esi, %ecx
			incl %esi
			jmp DEFRAGMENTATIONloop2
		
		DEFRAGMENTATIONaddIntervalAux:
			movl $1, true
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
			movl sizedefrag, %eax

		DEFRAGMENTATIONaddIntervalStop2:
			movl x, %eax
			xorl %edx, %edx
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
		movl line, %eax

		DELETEloopDefrag:
			cmpb %bl, (%edi, %ecx, 1)
			je DELETEintervalDefrag
			incl %ecx
			jmp DELETEloopDefrag

		DELETEintervalDefrag:
			cmpb %bl, (%edi, %ecx, 1)
			jne DELETEdefragStop
			movb $0, (%edi, %ecx, 1)
			leal occupied, %edi
			addw $1, (%edi, %eax, 2)
			leal space, %edi
			incl %ecx
			incl %edx
			jmp DELETEintervalDefrag

		DELETEdefragStop:
			popl %esi
			popl %ebx
			popl %ebp
			ret
	
	CONCRETE:
		pushl %ebp
		movl %esp, %ebp
		movl $0, cnt
		cmp $0, %edi
		jl CONCRETEerror

		movl %edi, directory_fd

		getdents:
			movl $141, %eax
			movl directory_fd, %ebx
			leal getdentsbuffer, %ecx
			movl $1024, %edx
			int $0x80

			cmp $0, %eax
			jl CONCRETEerror

			cmp $0, %eax
			je CONCRETEclose

			leal getdentsbuffer, %esi
			movl %eax, buffer_size

		CONCRETEloop:
			movl %esi, %edi
			addl $10, %esi
			leal (%esi), %ebx

			pushl %eax
			pushl %ecx
			pushl %edx
			pushl %ebx
			call CHECKdots
			movl %eax, true
			popl %eax
			popl %edx
			popl %ecx
			popl %eax

			movl true, %ecx
			cmp $0, %ecx
			je NextFile

			pushl %eax
			pushl %ecx
			pushl %edx
			call CONCAT
			popl %edx
			popl %ecx
			popl %eax

			pushl %eax
			pushl %ebx
			pushl %ecx
			pushl %edx

			movl $5, %eax
			leal concat_string, %ebx
			xorl %ecx, %ecx
			xorl %edx, %edx
			int $0x80

			movl %eax, file_fd
			movl cnt, %eax
			leal fd_close, %edi
			movl file_fd, %edx
			movl %edx, (%edi, %eax, 4)
			incl cnt
			movl file_fd, %eax
			xorl %edx, %edx
			movl $255, %ebx
			divl %ebx
			incl %edx
			movl %edx, fd

			movl $106, %eax
			leal concat_string, %ebx
			movl $stat_buffer, %ecx
			int $0x80

			movl stat_buffer+20, %eax
			movl $1024, %ecx
			xorl %edx, %edx
			divl %ecx
			
			movl %eax, size

			pushl size
			pushl fd
			pushl $format_concrete
			call printf
			popl %eax
			popl %eax
			popl %eax

			movl size, %eax
			movl $8, %ecx
			xorl %edx, %edx
			divl %ecx
			cmp $0, %edx
			ja INCREMENT
			jmp OUTPUT

			INCREMENT:
				incl %eax
				
			OUTPUT:

				pushl %esi
				pushl fd
				pushl %eax
				call ADD
				popl %eax
				popl %eax
				popl %esi

				popl %edx
				popl %ecx
				popl %ebx
				popl %eax

			NextFile:
				subl $10, %esi
				xorl %eax, %eax
				movw 8(%esi), %ax
				movw %ax, sizegetdents
				addw sizegetdents, %si

				movl buffer_size, %eax
				leal getdentsbuffer(%eax), %ebx
				cmp %ebx, %esi
				jl CONCRETEloop
				jmp getdents

			CONCRETEclose:
				leal fd_close, %edi
				xorl %ecx, %ecx

				CONCRETEcloseLoop:
					cmp cnt, %ecx
					je CONCRETEstop
					movl (%edi, %ecx, 4), %ebx
					movl $6, %eax
					int $0x80
					incl %ecx
					jmp CONCRETEcloseLoop

			CONCRETEstop:
				popl %ebp
				ret

			CONCRETEerror:
				pushl $concrete_error
				pushl $format_test
				call printf
				popl %eax
				popl %eax
				popl %ebp
				ret
	CHECKdots:
		pushl %ebp
		movl %esp, %ebp
		pushl %esi
		pushl %edi
		pushl %ebx
		xorl %eax, %eax
		xorl %ecx, %ecx
		movl $current_dir, %esi
		
		DOTsingleCmp:
			movb (%ebx), %al
			movb (%esi), %cl
			cmpb %al, %cl
			jne DOTdoubleCmpAux
			cmpb $0, %cl
			je CHECKdotsTrue
			incl %esi
			incl %ebx
			jmp DOTsingleCmp

		DOTdoubleCmpAux:
			decl %ebx
			movl $parent_dir, %esi

		DOTdoubleCmp:
			movb (%ebx), %al
			movb (%esi), %cl
			cmpb %al, %cl
			jne CHECKdotsFalse
			cmpb $0, %cl
			je CHECKdotsTrue
			incl %esi
			incl %ebx
			jmp DOTdoubleCmp

		CHECKdotsFalse:
			movl $1, %eax
			jmp CHECKdotsEnd

		CHECKdotsTrue:
			movl $0, %eax
			jmp CHECKdotsEnd
			
		CHECKdotsEnd:
			popl %ebx
			popl %edi
			popl %esi
			popl %ebp
			ret
	CONCAT:
		pushl %ebp
		movl %esp, %ebp
		pushl %ebx
		pushl %esi
		pushl %edi
		lea directory, %edi
		xorl %ecx, %ecx
		xorl %edx, %edx
		lea concat_string, %esi

		findDirectoryEnd:
			movb (%edi, %ecx, 1), %al
			cmpb $0, %al
			je copyFileName
			movb %al, (%esi, %ecx, 1)
			incl %ecx
			jmp findDirectoryEnd
		
		copyFileName:
			movb (%ebx, %edx, 1), %al
			movb %al, (%esi, %ecx, 1)
			cmpb $0, %al
			je CONCATend
			incl %edx
			incl %ecx
			jmp copyFileName

		CONCATend:
			popl %edi
			popl %esi
			popl %ebx
			popl %ebp
			ret

	TESTslash:
		pushl %ebp
		movl %esp, %ebp
		leal directory, %ebx
		xorl %ecx, %ecx
		xorl %edx, %edx
		
		TESTslashLoop:
			movb (%ebx, %ecx, 1), %al
			cmpb $0, %al
			je TESTslashCheck
			incl %ecx
			jmp TESTslashLoop

		TESTslashCheck:
			decl %ecx
			movb (%ebx, %ecx, 1), %dl
			cmpb $'/', %dl
			jne TESTslashAdd
			jmp TESTslashEnd
		
		TESTslashAdd:
			incl %ecx
			movb $'/', %dl
			movb %dl, (%ebx, %ecx, 1)
			incl %ecx
			movb %al, (%ebx, %ecx, 1)

		TESTslashEnd:
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
		je loopArrayAux2
		movw $1024, (%edi, %ecx, 2)
		incl %ecx
		jmp loopArray2
	
	loopArrayAux2:
		xorl %ecx, %ecx
		leal fd, %edi

	loopArray3:
		cmp $256, %ecx
		je end
		movb %cl, (%edi, %ecx, 1)
		incl %ecx
		jmp loopArray3
	end:
		leal space, %edi	
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
		cmp $5, %ebx
		je concrete
		jmp oploop
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
		leal space, %edi
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
		pushl %ecx
		pushl $directory
		pushl $format_scanfstr
		call scanf
		popl %ecx
		popl %ecx
		
		call TESTslash

		movl $5, %eax
		lea directory, %ebx
		movl $0, %ecx
		int $0x80
		movl %eax, %edi

		pushl %eax
		pushl %ecx
		pushl %edx
		pushl $directory
		call CONCRETE
		movl $6, %eax
		movl $4, %ebx
		int $0x80
		popl %eax
		popl %edx
		popl %ecx
		popl %eax
		popl %ecx
		jmp oploop

	exit:
		push $0
		call fflush
		pop %ebx
		movl $1, %eax
		xorl %ebx, %ebx
		int $0x80
		

