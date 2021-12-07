	# 305079253 Naveh Benvensite 

	.data
	
	.section	.rodata
fs_invalid:	.string	"invalid input!\n"
	
	.text
.globl	pstrlen	
.globl	replaceChar
.globl	pstrijcpy
.globl	swapCase
.globl	pstrijcmp


.type	pstrlen, @function
pstrlen:
    movzbq  (%rdi),%rax
    ret



.type	replaceChar, @function
replaceChar:

	pushq	%rbp
	movq	%rsp,	%rbp
	movq     %rdi,   %rax   
	leaq     1(%rdi), %rdi 
	cmpb     $0, (%rdi)   
 	je      .finish_replace
        
.loop_replace:
	cmpb      (%rdi),%sil 
	jne       .replace_rule
	movb      %dl, (%rdi)   
        
.replace_rule:
	leaq      1(%rdi), %rdi 
	cmpb      $0, (%rdi)  
	jne       .loop_replace
        
.finish_replace:
	movq	  %rbp, %rsp	
	popq	  %rbp		
	ret


.type	pstrijcpy, @function
pstrijcpy:

    pushq %rbp
    movq %rsp, %rbp
    movq %rdi, %rax

	#cmp the i-j in str1+str2

    cmpb %dl, %cl
    jl .invalid_case  
    cmpq $0, %rdx
    jl .invalid_case  
    cmpb %cl, (%rax)
    jle .invalid_case      
    cmpb %cl, (%rsi)
    jle .invalid_case     
	 addq $1, %rcx   

    .loop_cpy:     

        incq %rdx      
        cmpb %dl, %cl 
        jl .break_cpy
        leaq (%rdx, %rsi), %r11    
        leaq (%rdx, %rax), %r12 
        movq (%r11), %r8      
        movb %r8b, (%r12) 
        jmp .loop_cpy      

    .invalid_case:

        movq %rdi, %rbx
        movq $fs_invalid, %rdi   
        xorq %rax, %rax
        call printf   
        movq %rbx, %rax

    .break_cpy:

        movq %rbp, %rsp
        popq %rbp
        ret




.type	swapCase, @function
swapCase:
    pushq	%rbp		  
    movq    %rsp, %rbp	 
        
    movq    %rdi,  %rax          
        leaq    1(%rdi),  %rdi      
        movq    $1,    %rsi         
        cmpb    $0,    (%rax)       
        jle     .break_swap_func    
        
.loop_swapcase:
        cmpb     $65,  (%rdi)        
        jl      .goswap        
        cmpb     $90,(%rdi)       
        jg       .rules_swapcase
        addb     $32, (%rdi)             
        jmp      .goswap   
.rules_swapcase:    
        cmpb     $97,(%rdi)
        jl       .goswap  
        cmpb     $122,(%rdi)        
        jg       .goswap        
        subb     $32,(%rdi)    
.goswap:
        incl     %esi           
        incq     %rdi          
        cmpl     $0,(%rdi)    
        jne     .loop_swapcase
.break_swap_func:
        	movq	%rbp,%rsp	       
	popq	%rbp		      
	ret



	.type	pstrijcmp, @function
pstrijcmp:
	cmpb	%dl, %cl	
	jl		.invalid_cmp_func			
	cmpb	$0,	%dl		
	jl		.invalid_cmp_func				
	cmpb	 0(%rdi),%cl
	jg		.invalid_cmp_func
	cmpb	 0(%rdi),%dl
	jg		.invalid_cmp_func
	cmpb	 0(%rdi),%dl
	jg		.invalid_cmp_func
	cmpb	 0(%rsi),%dl
	jg		.invalid_cmp_func

	addq	$1, %rdi	
	addq	$1,	%rsi	
	addq	%rdx, %rdi	
	addq	%rdx, %rsi
	xorq	%rax,%rax

.loop_cmp_func:
	cmpb	%dl, %cl		
	jl		.break_cmp_func					

	movb	0(%rdi), %r8b	
	cmpb	%r8b,  0(%rsi)
	jl		.lower_cmp_func				
	jg		.grater_cmp_func
	addb	$1,	%dl		
	addq	$1,	%rdi	
	addq	$1, %rsi					
	jmp .loop_cmp_func

.grater_cmp_func:
	addq	$1,	%rax	
	addb	$1,	%dl		
	addq	$1,	%rdi	
	addq	$1, %rsi
	jmp		.loop_cmp_func

.lower_cmp_func:
	subq	$1, %rax
	addb	$1,	%dl		
	addq	$1,	%rdi	
	addq	$1, %rsi	
	jmp		.loop_cmp_func

.invalid_cmp_func:
	leaq	fs_invalid(%rip), %rdi	
	xorq	%rax, %rax	
	call	printf
	movq	$-2,  %rax

.break_cmp_func:			
	ret

