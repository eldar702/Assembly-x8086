
.data
.section .rodata

# message format:
format_str_length: .string "%d"
format_str: .string "%s"
format_switchCase_value: .string "%d"

#####################################################     run_main     #########################################################
# main for the assigment, the main ask the user for 2 strings and their length and a switchCase value 
# (values 50, 52, 53, 54, 55, 60 are legal). every legal value cause different function which operate on the strings
.text
.global run_main
.type run_main, @function
run_main:
# start work:
pushq %rbp                                # save the old frame pointer
movq %rsp, %rbp                           # create the new frame pointer

# registers initial:
 xorq %r12, %r12					      # r12 = 0 (later r12 = str1.length && str2.length))
 xorq %r13, %r13					      # r13 = 0 (later r13 = str1)
 xorq %r14, %r14					      # r14 = 0 (later r14 = str2)
 xorq %r15, %r15					      # r15 = 0 (later r15 = switchcase value)
 xorq %rax, %rax						  # rax = 0
 # scanf for str1.length() work:
 subq $4, %rsp                            # allocate 1 bytes in the stack
 movq %rsp, %rsi						                   
 movq $format_str_length, %rdi
 call scanf                               # ask the user for the str2 length
 movb (%rsp), %r12b                       # %r12 = str2.length 
 addq $4, %rsp                            # restore the %rsp to the previous situation
 subq $1, %rsp							  # add 1 byte in the stack for null char
 movb $0, (%rsp)						  # add the null char to the stack
  
 # scanf for str1 work:
 xorq %rax, %rax						  # rax = 0
 subq %r12, %rsp						  # add str1.length to the stack
 movq %rsp, %rsi
 movq $format_str, %rdi
 call scanf                               # ask the user for the str1

 # add str1 to the stack work:
subq $1, %rsp                             # allocate 1 bytes in the stack for the str1 length 
movb %r12b, (%rsp)                        # add the str1 length to the stack
movq %rsp, %r13                           # add str1 to the stack

# scanf for str2.length() work:
 xorq %rax, %rax
 xorq %r12, %r12
 subq $4, %rsp                            # allocate 1 bytes in the stack for str2.length number (represent by int)
 movq %rsp, %rsi						                   
 movq $format_str_length, %rdi
 call scanf                               # ask the user for the str2 length
 movb (%rsp), %r12b                       # %r12 = str2.length 
 addq $4, %rsp                            # restore the %rsp to the previous situation
 subq $1, %rsp							  # add 1 byte in the stack for null char
 movb $0, (%rsp)						  # add the null char to the stack
  
 # scanf for str2 work:
 xorq %rax, %rax						  # rax = 0
 subq %r12, %rsp						  # add str1.length to the stack
 movq %rsp, %rsi
 movq $format_str, %rdi
 call scanf                               # ask the user for the old char

 # add str2 to the stack work:
 subq $1, %rsp                           # allocate 1 bytes in the stack for the str1 length 
 movb %r12b, (%rsp)                      # add the str2 length to the stack
 movq %rsp, %r14                         # add str2 to the stack




 # scanf for switchCase value work:
 xorq %rax, %rax						  # rax = 0
 subq $4, %rsp                            # allocate 1 byte in the stack
 movq %rsp, %rsi                           
 movq $format_str_length, %rdi
 call scanf                               # ask the user for the old char
 movb (%rsp), %r15b                       # %r12 = str1.length 
 addq $4, %rsp                            # restore the %rsp to the previous situation

 # func_select work:
 movq %r15, %rdi						  # %rdi = switchCase value             
 movq %r13, %rsi						  # %rsi = str1    
 movq %r14, %rdx						  # %rdx = str2    
 xor %rax, %rax                           # init %rax
 call run_func
 movq %rbp, %rsp                          # return the stack frame as before
 popq %rbp                                
 ret
