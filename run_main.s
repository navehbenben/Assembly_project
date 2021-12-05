# 305079253 Naveh Benvensite 
#This program get Pstrings and divide them by definition as well  
.section .rodata
fts: 		.string "%s"
ftd:		.string "%d"

    .text
.globl run_main
	.type run_main, @function
run_main:
.main:

	    #initialize the stack frame
        pushq   %rbp      			     # Save address of previous stack frame
        movq    %rsp, %rbp 				 # Address of current stack frame
        subq    $528, %rsp  			 # Reserve 512 bytes for local variables

		#scan from user the length of pstring 
		leaq ftd(%rip), %rdi 			#load format string
		leaq 	-512(%rbp),	 %rsi		#leaq the alocation argument to scanf
		movq	$0,      %rax			# clear rax for scanf ret.
			call scanf					#call to scan
		
		#scan from user the pstring 
		leaq fts(%rip), %rdi  			# load format string
		leaq 	-511(%rbp),	 %rsi	 	#referance the address for scanf use.
		movq	$0,      %rax			# clear rax for scanf ret.	
			call scanf					#call to scan
		#scan from user the length of pstring 
		leaq ftd(%rip), %rdi  # load format string
		leaq 	-256(%rbp),	 %rsi	 	#leaq the alocation argument to scanf
		movq	$0,      %rax			# clear rax for scanf ret.
			call scanf					#call to scan
		
		#scan from user the pstring 
		leaq fts(%rip), %rdi  # load format string
		leaq 	-255(%rbp),	 %rsi	 	#referance the address for scanf use.
		movq	$0,      %rax			# clear rax for scanf ret.	
			call scanf					#call to scan
		# scaf from user the func number
		leaq ftd(%rip), %rdi  # load format string
		leaq 	-528(%rbp),	 %rsi	 	#referance the address for scanf use.
		movq	$0,      %rax		#clear rax before call func.
			call scanf
		leaq -512(%rbp), %rsi	#referance the address for rdi reg.
		leaq -256(%rbp), %rdx	#referance the address to rsi reg.
		movq -528(%rbp), %rdi
		movq $0, %rax			#clear rax for scanf ret.
		call run_func			# call run_func

		movq $0, %rax	# clear rax reg.
		leave	
		ret

