	# 305079253 Naveh Benvensite 
	.data

   .section .rodata

ftc: 		.string "%c"
ftd:		.string "%d"
ftcc:		.string	" %c %c"

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

# case 50	
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
	
# case 52	
.L2:

	leaq	-39(%rbp), %rdx		
	leaq	-40(%rbp), %rsi			 
	leaq	ftcc(%rip), %rdi		
	movq	$0, %rax				
	call	scanf					
	
	movzbq	-39(%rbp), %rdx			
	movzbq	-40(%rbp), %rsi			
	movq	-56(%rbp), %rdi		
	xorq	%rax, %rax					
	call	replaceChar				

	movzbq	-39(%rbp), %rdx			
	movzbq	-40(%rbp), %rsi			
	movq	-48(%rbp), %rdi		
	xorq	%rax, %rax				
	call	replaceChar

	movq	-48(%rbp), %r8		
	leaq	1(%r8), %r8			
	movq	-56(%rbp), %rcx		
	leaq	1(%rcx), %rcx		
	movq	-39(%rbp), %rdx		
	movq	-40(%rbp), %rsi			
	leaq	newcharCase_print(%rip), %rdi	
	xorq	%rax, %rax			
	call	printf				
	

	jmp		.exit	
# case 53
.L3:


	leaq	-32(%rbp), %rsi		
	movq	$ftd, %rdi		
	movq	$0, %rax			
	call	scanf					
	
	
	leaq	-24(%rbp), %rsi			
	movq	$ftd, %rdi		
	xorq	%rax, %rax		
	call	scanf					

	movq	-24(%rbp), %rcx		
	movq	-32(%rbp), %rdx		
	movq	-48(%rbp), %rsi			
	movq	-56(%rbp), %rdi			
	call	pstrijcpy				

	movq	-56(%rbp), %rdx			
	leaq	1(%rdx), %rdx			
	movq	-56(%rbp), %rsi			
	movzbq	(%rsi), %rsi			
	movsbq	%sil, %rsi				
	movq	$pstrijcpy_print, %rdi	
	movq	$0, %rax			
	call	printf				
	

	movq	-48(%rbp), %rdx			
	leaq	1(%rdx), %rdx			
	movq	-48(%rbp), %rsi			
	movzbq	(%rsi), %rsi			
	movsbq	%sil, %rsi				
	movq	$pstrijcpy_print, %rdi	
	movq	$0, %rax				
	call	printf					
	
	jmp		.exit				
	
# case 54	
.L4:

	movq	-56(%rbp), %rdi		
	call	swapCase			
	movq	-48(%rbp), %rdi		
	call	swapCase			
	

	movq	-56(%rbp), %rdx		
	leaq	1(%rdx), %rdx
	movq	-56(%rbp), %rsi
	movzbq	(%rsi), %rsi
	movsbq	%sil, %rsi
	movq	$pstrijcpy_print, %rdi
	movq	$0, %rax
	call	printf
	

	movq	-48(%rbp), %rdx		
	leaq	1(%rdx), %rdx
	movq	-48(%rbp), %rsi
	movzbq	(%rsi), %rsi
	movsbq	%sil, %rsi
	movq	$pstrijcpy_print, %rdi
	movq	$0, %rax
	call	printf
	
	jmp		.exit	

	#case 55
.L5:

	leaq	-32(%rbp), %rsi			
	movq	$ftd, %rdi	
	movq	$0, %rax				# clear rax.
	call	scanf					# scan index i.

	leaq	-24(%rbp), %rsi			
	movq	$ftd, %rdi	
	movq	$0, %rax				
	call	scanf					
	
	movsbq	-24(%rbp), %rcx			
	movsbq	-32(%rbp), %rdx			
	movq	-56(%rbp), %rsi			
	movq	-48(%rbp), %rdi			
	movq	$0, %rax				
	call	pstrijcmp			
	

	movq	%rax, %rsi				
	movq	$pstrijcmp_print, %rdi	
	movq	$0, %rax				
	call	printf					
	
	jmp		.exit					

#Invalid option 
.default:
leaq invalidCase_print(%rip), %rdi  	
movq $0, %rax
call printf
 jmp  .exit
 

.exit:
	addq	$64, %rsp	
	movq	$0, %rax			
	popq	%rbp				
	ret								
	

