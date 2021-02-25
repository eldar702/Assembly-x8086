.data
.section .rodata
    error_message: .string "invalid input!\n"

.text 
    #####################################################      pstrlen       ################################################## 
    # the function get a pointer to pstring, and return the pstring length
.globl pstrlen 
    .type pstrlen, @ function # the label "pstrlen" representing the beginning of a function
pstrlen: 

        pushq %rbp                         # save the old frame pointer
        movq %rsp, %rbp                    # create the new frame pointers
        movq $0, %rax                      # %rax = 0
        movb (%r8), %al                    # rdi save the 1st argument, and the pstring's first byte represent the psring argument size
                                           # so save this value in the first byte of the register rax.
        movq %rbp, %rsp
        popq %rbp
        ret

   #####################################################      replaceChar       ################################################## 
   #the function get from the user old char and new char, and replace in the pstring all the occurance of the old char with the new
.globl replaceChar 
	.type replaceChar, @function # the label "replaceChar" representing the beginning of a function
replaceChar: 
    # start work:
    pushq %rbp                            # save the old frame pointer
    movq %rsp, %rbp                       # create the new frame pointer 
    movq %rdi, %r12                       # r12 = string (%rdi)

    # loop work:
   .Loop_replaceChar:
        cmpq $0, (%rdi)                   # check if we in the last letter of the string, if yes - go to end, if no - continue
        je .end_replaceChar
        cmpb (%rdi), %sil                 # check if pstr[i] = old char
        je .changeLetter                  # if yes - jump to changeletter case
        add $1, %rdi                      # int i += 1
        jmp .Loop_replaceChar

   # change letter work:
   .changeLetter: 
        movb %dl, (%rdi)                  # pstr[i] = new char 
        add $1, %rdi                      # int i += 1
        jmp .Loop_replaceChar

   # end work:
   .end_replaceChar:

        movq %r12, %rax                   # return str after change
        movq %rbp, %rsp
        popq %rbp
    ret
    
   #####################################################      pstrijcpy       ################################################## 
   # the function get for the user a start and end indexs, and replace the substring represent by 
   # those indexes of two pstrings (change the substring of sorce pstring with new pstring)
.globl pstrijcpy 
	.type pstrijcpy, @function
pstrijcpy: 
 # %rdi = dst string   %rsi = src string 
 # %rdx = int i        %rcx = int j
  # initiate work:
  pushq %rbp                             # save the old frame pointer
  movq %rsp, %rbp                        # create the new frame pointer 
  xorq %r8, %r8                          # %r8 = 0
  xorq %r9, %r9                          # %r9 = 0
  xorq %r10, %r10                        # %r10 = 0
  xorq %r11, %r11                        # %r11 = 0
  movb (%rdi), %r8b                      # %r8 = dst string length
  movb (%rsi), %r9b                      # %r9 = src string length 
  movq %rdi, %r10                        # %r10 = dst string 
  movq %rsi, %r11                        # %r11 = src string
  jmp .ifIsLegal_pstrijcpy

 # special cases work:
.ifIsLegal_pstrijcpy:                    # checks for special cases, if one occur - send error           
  incq %rcx                              # j += 1
  cmpq %rdx, %rcx                        # check if i > j
  jb .error_pstrijcpy                        
  cmpq %rcx, %r8                         # check if j > dst string.lenghth()
  jb .error_pstrijcpy               
  cmpq %rcx, %r9                         # check if j > src string.lenghth()
  jb .error_pstrijcpy
  cmpq %r8, %rdx                         # dealing with case of negative i
  jae .error_pstrijcpy
  cmpq %r9, %rdx                         # dealing with case of negative i
  jae .error_pstrijcpy
  
  jmp .loop_pstrijcpy

 # loop work:
.loop_pstrijcpy:
 incq %rdx                               # i += 1
 cmpq %rcx, %rdx                         # if j < i loop is finish
 ja .end_pstrijcpy
 leaq (%rdx, %r12), %rdi                 # make %rdi pointer to dst_string[i]
 leaq (%rdx, %r13), %rsi                 # make %rsi pointer to src_string[i]
 movq (%rsi), %r8                        # save in %r8 the letter in src_string[i]
 movb %r8b, (%rdi)                       # dst_string[i] = src_string[i]
 jmp .loop_pstrijcpy          

# special cases end:
.error_pstrijcpy:
  movq $error_message, %rdi              # move the error format to %rdi
  call printf
  jmp .end_pstrijcpy

.end_pstrijcpy:

 movq %r12, %rax                        # return dst str after change
 movq %rbp, %rsp
 popq %rbp
    ret

   #####################################################      swapCase       ################################################## 
   # the function gets pointer to pstring and change the small letters with capital letter and oposite.
.globl swapCase 
	.type swapCase, @function
swapCase:

  # start work:
  pushq %rbp                             # save the old frame pointer
  movq %rsp, %rbp                        # create the new frame pointer 
  movq %rdi, %r9                         # r9 = string (%rdi)
  add $1, %rdi                           # int i += 1

   # loop work:
  .Loop_SwapCase:
        cmpq $0, (%rdi)                 # check if we in the last letter of the string, if yes - go to end, if no - continue
        je .end_SwapCase

        cmpb $65, (%rdi) 	            # if str[i] >= 65 - continue to check, if not - skip to the next iteration
        jb .next_SwapCase               # jump to end if 65 > str[i]

        cmpb $122, (%rdi) 	            # if str[i] < 122 - continue to check, if not - skip to the next iteration
        ja .next_SwapCase               # jump to end if 122 < str[i]

        cmpb $91, (%rdi) 	            # if str[i] <= 90 - so it's upper letter, if not - skip to the next iteration
        jb .upperCase                   # str[i] is uppercase letter (64 < str[i] < 91)
        
        cmpb $96, (%rdi) 	            # if str[i] >= 97 - so it's lower letter, if not - skip to the next iteration
        ja .lowerCase                   # str[i] is lowercase letter (96 < str[i] < 123)
        jmp .next_SwapCase

  # next iteration work:
  .next_SwapCase: 
   add $1, %rdi                         # int i += 1
   jmp .Loop_SwapCase

  .lowerCase:
   subb $32, (%rdi) 			       # make lower letter upper letter by reduce 32 from her value (32 is the diffrence in ASCII between the cases)
   add $1, %rdi                        # int i += 1
   jmp .Loop_SwapCase

   .upperCase:
   add $32, (%rdi) 			           # make upper letter to lower by add 32 to her value (32 is the diffrence in ASCII between the cases)
   add $1, %rdi                        # int i += 1
   jmp .Loop_SwapCase
  # end work:
  .end_SwapCase:

        movq %r9, %rax                # %rax = new string
        movq %rbp, %rsp             
        popq %rbp
    ret

    #####################################################       pstrijcmp        ################################################## 
# the function compare 2 substring of 2 pstrings (created by i and j indexes given by the user) and declare which one is greater lexicographic.
.globl pstrijcmp 
	.type pstrijcmp, @function
pstrijcmp:
# initiate work:
 # %rdi = dst string   %rsi = src string 
 # %rdx = int i        %rcx = int j
  # start work:
  pushq %rbp                             # save the old frame pointer
  movq %rsp, %rbp                        # create the new frame pointer 
  xorq %r8, %r8                          # %r8 = 0
  xorq %r9, %r9                          # %r9 = 0
  movb (%rdi), %r8b                      # %r8 = str1 length
  movb (%rsi), %r9b                      # %r9 = str2 length 
  jmp .ifIsLegal_pstrijcmp

 # special cases work:
.ifIsLegal_pstrijcmp:                    # checks for special cases, if one occur - send error                      
  cmpq %rdx, %rcx                        # check if i > j
  jb .error_pstrijcmp                        
  cmpq %rcx, %r8                         # check if j >  str1.lenghth()
  jb .error_pstrijcmp               
  cmpq %rcx, %r9                         # check if j >  str2.lenghth()
  jb .error_pstrijcmp
  cmpq %r8, %rdx                         # dealing with case of negative i
  jae .error_pstrijcmp
  cmpq %r9, %rdx
  jae .error_pstrijcmp                   # dealing with case of negative i
  incq %rcx                              # j += 1
  xorq %r8, %r8                          # %r8 = 0
  xorq %r9, %r9                          # %r9 = 0
  jmp .loop_pstrijcmp

# special cases end:
.error_pstrijcmp:
  movq $error_message, %rdi             # move to %rdi the error message format
  call printf                               
  xorq %rax, %rax                       # %rax = 0
  movq $-2, %rax                        # %rax = (-2)
  jmp .end_pstrijcmp

# loop work:
.loop_pstrijcmp:
 incq %rdx                              # i += 1
 cmpq %rcx, %rdx                        # if j < i loop is finish
 ja .strs_are_equals                    # if happends - means that the two substrings are the same
 leaq (%rdx, %r12), %rdi                # make %rdi pointer to str1[i]
 leaq (%rdx, %r13), %rsi                # make %rsi pointer to str2[i]
 movb (%rdi), %r8b                      # %r8 = str1[i]
 movb (%rsi), %r9b                      # %r9 = str2[i]

 cmpq %r8, %r9                          # check which is greater - str1[i](=%r8)  or  str2[j](=%r9)
 jb .str1greater                        # str1 is greater lexicography than str2
 ja .str2greater                        # str2 is greater lexicography than str1
 jmp .loop_pstrijcmp

 # normal cases work:
 .str1greater:                          # str1 is greater lexicographic than str2             
  xorq %rax, %rax                       # rax = 0
  movq $1, %rax                         # rax = 1
  jmp .end_pstrijcmp

 .str2greater:                          # str2 is greater lexicographic than str1
  xorq %rax, %rax                       # rax = 0
  movq $-1, %rax                        # rax = -1
  jmp .end_pstrijcmp

                                        # str1 and str2 are the same 
  .strs_are_equals:
  xorq %rax, %rax                       # rax = 0
  jmp .end_pstrijcmp

  # end work:
.end_pstrijcmp:            
movq %rbp, %rsp                         
popq %rbp
   ret
