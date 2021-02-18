# 205616634 eldar shlomi
.data
.section .rodata

.align 8 # Align address to multiple of 8
SwitchTable:
        .quad .case50_60                     # case 50/60: pstrlen function
        .quad .case52                        # case 52: replaceChar function
        .quad .case53                        # case 53: pstrijcpy function
        .quad .case54                        # case 54: swapCase function
        .quad .case55                        # case 55: pstrijcmp function
        .quad .caseDefault                   # case default

# message format:
case50_60_message: .string "first pstring length: %d, second pstring length: %d\n"
case52_message: .string "old char: %c, new char: %c, first string: %s, second string: %s\n"
case53_message: .string "length: %d, string: %s\n"
case54_message: .string "length: %d, string: %s\n"
case55_message: .string "compare result: %d\n"
strDefaultCase: .string "invalid option!\n"
format_int: .string "%d"
format_char: .string " %c"
format_unsignedChar: .string "%hhu"

   #####################################################     run_func     #########################################################
   # the switch case function 
	  .text                                 # beginning of the code:
.globl run_func                             # the label "run_func" is used to state the initial point of this program
	.type	run_func, @function             # the run_func function:
run_func:
  cmpq $50, %rdi                            # check if the given int argument is 50 
  je .case50_60                             # if yes, jump to case50_60
  cmpq $60, %rdi							# check if the given int argument is 60 
  je .case50_60								# if yes, jump to case50_60
  leaq -52(%rdi), %rcx                      # reduce 52 from the arg (x -= 52)
  cmpq $4, %rcx                             # comapre flag: 3 (check if the value is 52, 53, 54, 55)
  ja .caseDefault                           # if the given arg, x, is more than 60 or less than 50 - go the default case
  incq %rcx
  jmp *SwitchTable(,%rcx,8)                 # get the address in the SwitchTable

   ############################################     case 50_60    -     pstrlen       #############################################
   # 
  .case50_60:                                  
  pushq %rbp                                # save the old frame pointer
  movq %rsp, %rbp                           # create the new frame pointer
   
  movq %rsi, %r8                            # move the first pstring to %r8 (the register which pstrlen work on)
  call pstrlen
  movq %rax, %r10                           # save the lenght of the first pstring in %r10
  movq $0, %rax							    # initialize %rax = 0

  movq %rdx, %r8							# move the second pstring to %r8 (the register which pstrlen work on)
  call pstrlen
  movq %rax, %r11							# save the lenght of the seccond pstring in %r11

  movq $case50_60_message, %rdi             # move the string format to %rdi (the 1st arg for the printf func)
  movq %r10, %rsi                           # move the 1st pstring lenght to %rsi (the 2nd arg for the printf func)
  movq %r11, %rdx                           # move the 2nd pstring lenght to %rdx (the 3th arg for the printf func)
  xorq %rax, %rax                           # initialize %rax = 0
  call printf

  movq %rbp, %rsp                           # restore the frame pointer to be as before case 50
  popq %rbp
  ret 
  
    ############################################      case 52   -    replaceChar       #############################################
 #### replace all accurence of spacific char in the string with other char  
  .case52:
  #start work:
  pushq %rbp
  movq %rsp, %rbp 
  xorq %rax, %rax                           # initialize %rax = 0
  movq %rsi, %r12                           # move the first string to %r12
  movq %rdx, %r13                           # move the seccond string to %r13

  # scanf work:
  subq $1, %rsp                             # allocate 1 byte in the stack
  movq %rsp, %rsi                           
  movq $format_char, %rdi
  call scanf                                # ask the user for the old char
  movb (%rsp), %r14b                        # move the chosen char (old) to r14
  addq $1, %rsp                             # restore the %rsp to the previous situation

  subq $1, %rsp                             # allocate 1 byte in the stack
  movq %rsp, %rsi                           
  movq $format_char, %rdi
  xorq %rax, %rax                           # initialize %rax = 0
  call scanf
  movb (%rsp), %r15b                        # move the chosen char (new) to r15
  movq $0, %rax                             # initialize %rax = 0
  addq $1, %rsp                             # restore the %rsp to the previous situation

  # first string work:
  movq %r12, %rdi                           # move the first string to %rdi
  movq %r14, %rsi                           # move the old char to %rsi
  movq %r15, %rdx                           # move the new char to %rdx
  call replaceChar
  movq %rax, %r8                            # r8 = the new string (number 1)

  # second string work:
  movq $0, %rax                             # initialize %rax = 0
  movq %r13, %rdi                           # move the second string to %rdi
  movq %r14, %rsi                           # move the old char to %rsi
  movq %r15, %rdx                           # move the new char to %rdx
  call replaceChar
  movq %rax, %r9                            # r9 = the new string (number 2)
  xorq %rax, %rax                           # initialize %rax = 0

  # printf work:
  movq $case52_message, %rdi                # move the string format to %rdi
  movq %r14, %rsi                           # rsi = old char
  movq %r15, %rdx                           # rdx = new char
  movq %r8, %rcx                            # rcx = 1st string
  movq %r9, %r8                             # r8 = 2nd string
  add $1, %rcx                              # adding 1 to the register to ignore the str[0] which is the str's length
  add $1, %r8                               # adding 1 to the register to ignore the str[0] which is the str's length
  call printf

  #end work:
  movq %rbp, %rsp
  popq %rbp
  ret

    ############################################     case 53    -    pstrijcpy      ##############################################
    .case53: 
  #start work:
  pushq %rbp
  movq %rsp, %rbp 
  xorq %rax, %rax                           # initialize %rax = 0
  movq %rsi, %r12                           # %r12 = dst str (1st string)
  movq %rdx, %r13                           # %r13 = src str (2nd string)
  # scanf work:
  subq $1, %rsp                             # allocate 1 byte in the stack
  movq %rsp, %rsi                           
  movq $format_unsignedChar, %rdi
  call scanf                                # ask the user for int i
  xorq %r14, %r14
  movb (%rsp), %r14b                       # r14 = i
  addq $1, %rsp                             # restore the %rsp to the previous situation

  subq $1, %rsp                             # allocate 1 byte in the stack
  movq %rsp, %rsi                           
  movq $format_unsignedChar, %rdi
  xorq %rax, %rax                           # initialize %rax = 0
  call scanf                                # ask the user for int j
  xorq %r15, %r15
  movb (%rsp), %r15b                        # r15 = j
  movq $0, %rax                             # initialize %rax = 0
  addq $1, %rsp                             # restore the %rsp to the previous situation

  # string work:
  movq %r12, %rdi                           # %rdi = dst str
  movq %r13, %rsi                           # %rsi = src str
  movq %r14, %rdx                           # %rdx = i
  movq %r15, %rcx                           # %rdx = j
  call pstrijcpy
  movq %rax, %rdx                           # rdx = new string (dst after the changes, if occur)

  # printf dst string work:
  xorq %r14, %r14
  movq $case53_message, %rdi                # move the string format to %rdi
  movb (%rdx), %r14b                        # %r14 = dest string length
  movq %r14, %rsi
  xorq %rax, %rax                           # initialize %rax = 0
  add $1, %rdx                              # adding 1 to the register to ignore the str[0] which is the str's length
  call printf                                
  
  # printf src string work:
  xorq %rax, %rax                           # initialize %rax = 0
  xorq %r14, %r14
  movq $case53_message, %rdi                # move the string format to %rdi
  movb (%r13), %r14b                        # %r14 = src string length
  movq %r14, %rsi                           # %rsi = src string length
  movq %r13, %rdx                           # rdx = new string
  add $1, %rdx                              # adding 1 to the register to ignore the str[0] which is the str's length
  call printf      

  #end work:
  movq %rbp, %rsp                           # return the stack frame as before
  popq %rbp
  ret

      ############################################      case 54   -    swapCase       #############################################

    .case54: 
  # start work:
  pushq %rbp
  movq %rsp, %rbp 
  movq $0, %rax                             # initialize %rax = 0
  xorq %r14, %r14
  movb (%rsi), %r14b                        # %r14 = 1st string length
  movb (%rdx), %r15b                        # %r15 = 2nd string length 
  movq %rsi, %rdi                           # %rdi = 1st string
  movq %rdx, %r13                           # %r13 = 2nd string
  
  # 1st string work:
  call swapCase
  xorq %r8, %r8                             # %r8 = 0
  movq %rax, %r8                            # %r8 = new 1st string

  # printf work: 1st string
  movq $case54_message, %rdi                # move the string format to %rdi
  xorq %rsi, %rsi                           # %rsi = 0
  movq %r14, %rsi                           # %rsi = 1st string length
  movq %r8, %rdx                            # %rdx = new 1st string
  xorq %rax, %rax                           # initialize %rax = 0
  add $1, %rdx
  call printf

  # 2nd string work:
  movq $0, %rax                             # initialize %rax = 0
  movq %r13, %rdi                           # %rdi = 2nd string
  call swapCase
  movq %rax, %r13                           # %r9 = new 2nd string

  # printf work: 2st string
  movq $case54_message, %rdi                # move the string format to %rdi
  movq %r15, %rsi                           # %rsi = 2nd string length
  movq %r13, %rdx                           # %rdx = new 1nd string
  movq $0, %rax                             # initialize %rax = 0
  add $1, %rdx                              # adding 1 to the register to ignore the str[0] which is the str's length
  call printf

   #end work:
  movq %rbp, %rsp                           # return the stack frame as before
  popq %rbp
  ret

       ############################################      case 55   -    pstrijcmp       #############################################
    .case55:
  # start work:
  pushq %rbp
  movq %rsp, %rbp 
  movq $0, %rax                             # initialize %rax = 0
  movq %rsi, %r12                           # %r12 = dst str (1st string)
  movq %rdx, %r13                           # %r13 = src str (2nd string)

  # scanf work:
  subq $1, %rsp                             # allocate 1 byte in the stack
  movq %rsp, %rsi                           
  movq $format_unsignedChar, %rdi
  call scanf                                # ask the user for int i
  xorq %r14, %r14                           # %r14 = 0
  movb (%rsp), %r14b                        # r14 = i
  addq $1, %rsp                             # restore the %rsp to the previous situation

  subq $1, %rsp                             # allocate 1 byte in the stack
  movq %rsp, %rsi                           
  movq $format_unsignedChar, %rdi
  movq $0, %rax                             # initialize %rax = 0
  call scanf                                # ask the user for int j
  movb (%rsp), %r15b                        # r15 = j
  movq $0, %rax                             # initialize %rax = 0
  addq $1, %rsp                             # restore the %rsp to the previous situation

   # string work:
  movq %r12, %rdi                           # %rdi = dst str
  movq %r13, %rsi                           # %rsi = src str
  movq %r14, %rdx                           # %rdx = i
  movq %r15, %rcx                           # %rdx = j
  call pstrijcmp
  movq %rax, %rsi                           # rsi = compare result

  # printf work:
  movq $case55_message, %rdi                # move the string format to %rdi
  xorq %rax, %rax                           # initialize %rax = 0
  call printf     
  
    #end work:
  movq %rbp, %rsp                           # return the stack frame as before
  popq %rbp
  ret 

      ######################################        default case        ###############################################
     .caseDefault:
  xorq %rax, %rax                          # %rax = 0 
  movq $strDefaultCase, %rdi               # move the string pormat to %rdi
  call printf                              # print invalid input!
  ret

end:  
popq %rbx
movq %rbp, %rsp                            # return the stack frame as before
pop %rbp
   ret
