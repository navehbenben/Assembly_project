	# 305079253 Naveh Benvensite 
	.data

   .section .rodata

ftc: 		.string "%c"
ftd:		.string "%d"

invalidCase_print: 		.string "invalid option!\n"
lengthCase_print:		.string "first pstring length: %d, second pstring length: %d\n"
newcharCase_print: 		.string "old char: %c, new char: %c, first string: %s, second string: %s\n"
pstrijcpy_print:		.string "length: %d, string: %s\n"
pstrijcmp_print:	.string "compare result: %d\n"

	.align 8
.L10:
	.quad	.L0			# case 50
	.quad	.default	# default 
	.quad	.L2			# case 52 
	.quad	.L3			# case 53
	.quad	.L4			# case 54 
	.quad	.L5			# case 55 
	.quad	.default	# default 
	.quad	.default	# default  
	.quad	.default	# default 
	.quad	.default	# default 
	.quad	.L0			# case 60 
	.quad	.default	# default 
       
	.text
	.globl run_func
	.type run_func, @function
run_func:

push	%rbp
movq 	%rsp, %rbp
subq	$64, %rsp
movq 	%rdi, -64(%rbp)
movq	%rsi, -56(%rbp)
movq	%rdx, -48(%rbp)

leaq	-50(%rdi), %rcx
cmp 	$10, %rcx
ja      .default
jmp 	*.L10(,%rcx,8)
jmp		.exit		

#pstrlen_50/60
.L0:
movq -56(%rbp), %rdi
xorq %rax, %rax
call pstrlen
movsbq	%al, %rsi		

movq -48(%rbp), %rdi
xorq %rax, %rax
call pstrlen
movsbq	%al, %rdx	

leaq lengthCase_print(%rip), %rdi
xorq %rax, %rax
call printf
jmp .exit

.L2:

leaq ftd(%rip), %rdi
xorq %rax, %rax
call scanf
movq  %rax, %r8			#old Char

leaq ftd(%rip), %rdi
xorq %rax, %rax
call scanf
movq  %rax, %r9 		#new Char			

leaq -56(%rbp), %rdi
movq %r8, %rsi
movq %r9, %rdx
xorq %rax, %rax
call replaceChar
movq %rax, %r10				

leaq -48(%rbp), %rdi
movq %r8, %rsi
movq %r9, %rdx
xorq %rax, %rax
call replaceChar
movq %rax, %r11

movq %r8, %rsi
movq %r9, %rdx
movq %r10, %rcx
movq %r11, %r8
leaq newcharCase_print(%rip), %rdi
xorq %rax, %rax
call printf
jmp .exit


.L3:
	# case 53 - pstrijcpy.
		
	# scan for the 1st index i.
	leaq	-32(%rbp), %rsi			# 2nd arg of scanf - address to use.
	movq	$ftd, %rdi		# 1st arg of scanf - format-string.
	movq	$0, %rax				# clear rax.
	call	scanf					# scan for index.
	
	# scan for the 2nd index j.
	leaq	-28(%rbp), %rsi			# 2nd arg of scanf - address to use.
	movq	$ftd, %rdi		# 1st arg of scanf - format-string.
	movq	$0, %rax				# clear rax.
	call	scanf					# scan for index.
	
	# call pstrijcpy with 4 arguments.
	movq	-28(%rbp), %rcx			# put j in rcx.
	movq	-32(%rbp), %rdx			# put i in rdx.
	movq	-56(%rbp), %rsi			# put src in rsi.
	movq	-48(%rbp), %rdi			# put dst in rdi.
	call	pstrijcpy				# make the call.
	
	# print 1st message.
	movq	-48(%rbp), %rdx			# put the 1st pstring in rdx.
	leaq	1(%rdx), %rdx			# update to the string itself.
	movq	-48(%rbp), %rsi			# put the length in rsi.
	movzbq	(%rsi), %rsi			# read rsi as number and re-store it.
	movsbq	%sil, %rsi				# take the last byte.
	movq	$pstrijcpy_print, %rdi	# put a format-string in rdi.
	movq	$0, %rax				# clear rax.
	call	printf					# print.
	
	# print 2nd message.
	movq	-56(%rbp), %rdx			# put the 2nd pstring in rdx.
	leaq	1(%rdx), %rdx			# update to the string itself.
	movq	-56(%rbp), %rsi			# put the length in rsi.
	movzbq	(%rsi), %rsi			# read rsi as number and re-store it.
	movsbq	%sil, %rsi				# take the last byte.
	movq	$pstrijcpy_print, %rdi	# put a format-string in rdi.
	movq	$0, %rax				# clear rax.
	call	printf					# print.
	
	# exit.
	jmp		.exit					# End program orderly.

.L4:
	# case 54 - swapCase.
	
	# use swapCase function to edit the pstrings.
	movq	-48(%rbp), %rdi			# put the 1st psting in rdi.
	call	swapCase				# call swapCase for the 1st pstring.
	movq	-56(%rbp), %rdi			# do it again for the 2nd pstring.
	call	swapCase				# ...
	
	# print the 1st message.
	movq	-48(%rbp), %rdx			# the printig procedure works the same as above.
	leaq	1(%rdx), %rdx
	movq	-48(%rbp), %rsi
	movzbq	(%rsi), %rsi
	movsbq	%sil, %rsi
	movq	$pstrijcpy_print, %rdi
	movq	$0, %rax
	call	printf
	
	# print 2nd message.
	movq	-56(%rbp), %rdx			# same here...
	leaq	1(%rdx), %rdx
	movq	-56(%rbp), %rsi
	movzbq	(%rsi), %rsi
	movsbq	%sil, %rsi
	movq	$pstrijcpy_print, %rdi
	movq	$0, %rax
	call	printf
	
	# exit.
	jmp		.exit					# End program orderly.

.L5:
	# case 55 - pstrijcmp.

	# scan for the 1st index i.
	leaq	-32(%rbp), %rsi			# 2nd arg for scanf - address to use.
	movq	$ftd, %rdi		# 1st arg for scanf - format-string.
	movq	$0, %rax				# clear rax.
	call	scanf					# scan index i.
	
	# scan for the 2nd index j.
	leaq	-28(%rbp), %rsi			# 2nd arg for scanf - address to use.
	movq	$ftd, %rdi		# 1st arg for scanf - format-string.
	movq	$0, %rax				# clear rax.
	call	scanf					# scan index j.
	
	# cmpare string in [i:j] using pstrijcmp function.
	movsbq	-28(%rbp), %rcx			# 4th arg - index j - to rcx.
	movsbq	-32(%rbp), %rdx			# 3rd arg - index i - to rdx.
	movq	-56(%rbp), %rsi			# 2nd arg - pstring2 - to rsi.
	movq	-48(%rbp), %rdi			# 1st arg - pstring1 - to rdi.
	movq	$0, %rax				# clear rax.
	call	pstrijcmp				# call pstring [i,j] compare function.
	
	# print result.
	movq	%rax, %rsi				# put result in rsi.
	movq	$pstrijcmp_print, %rdi		# put format-string in rdi.
	movq	$0, %rax				# clear rax.
	call	printf					# print result.
	
	# exit.
	jmp		.exit					# End program orderly.	

#Invalid option 
.default:
leaq invalidCase_print(%rip), %rdi  			# load format string
movq $0, %rax
call printf
 jmp  .exit
 


.exit:
	addq	$64, %rsp	
	movq	$0, %rax			
	popq	%rbp				
	ret								
	

