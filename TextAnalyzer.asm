INCLUDE Irvine32.inc

.data
heading BYTE "========== TEXT ANALYZER ==========", 0
prompt BYTE 0Dh,0Ah, "Enter a string: ", 0
output1 BYTE 0Dh,0Ah, "Vowels: ", 0
output2 BYTE 0Dh,0Ah, "Consonants: ", 0
output3 BYTE 0Dh,0Ah, "Digits: ", 0
output4 BYTE 0Dh,0Ah, "Spaces: ", 0
output5 BYTE 0Dh,0Ah, "Most frequent character: ", 0
thankyou BYTE 0Dh,0Ah, "==================================", 0
stringInput BYTE 256 DUP(0)
freqArray DWORD 256 DUP(0)

vowelCount DWORD 0
consonantCount DWORD 0
digitCount DWORD 0
spaceCount DWORD 0
maxFreq DWORD 0
maxChar BYTE ?

.code
main PROC
    mov edx, OFFSET heading
    call WriteString

    mov edx, OFFSET prompt
    call WriteString

    mov edx, OFFSET stringInput
    mov ecx, 255
    call ReadString

    mov esi, OFFSET stringInput

NextChar:
    mov al, [esi]
    cmp al, 0
    je DoneProcessing

    movzx ebx, al
    mov edi, OFFSET freqArray
    add edi, ebx*4
    inc DWORD PTR [edi]

    mov ah, al
    and ah, 0DFh
    cmp ah, 'A'
    jb NotLetter
    cmp ah, 'Z'
    ja NotLetter

    cmp ah, 'A'
    je IsVowel
    cmp ah, 'E'
    je IsVowel
    cmp ah, 'I'
    je IsVowel
    cmp ah, 'O'
    je IsVowel
    cmp ah, 'U'
    je IsVowel

    inc consonantCount
    jmp NextCharAdvance

IsVowel:
    inc vowelCount
    jmp NextCharAdvance

NotLetter:
    cmp al, '0'
    jb CheckSpace
    cmp al, '9'
    ja CheckSpace
    inc digitCount
    jmp NextCharAdvance

CheckSpace:
    cmp al, ' '
    jne NextCharAdvance
    inc spaceCount

NextCharAdvance:
    inc esi
    jmp NextChar

DoneProcessing:
    mov ecx, 256
    mov edi, OFFSET freqArray
    xor ebx, ebx
FindMax:
    mov eax, [edi]
    cmp eax, maxFreq
    jbe SkipUpdate
    mov maxFreq, eax
    mov maxChar, bl
SkipUpdate:
    add edi, 4
    inc bl
    loop FindMax

    mov edx, OFFSET output1
    call WriteString
    mov eax, vowelCount
    call WriteDec

    mov edx, OFFSET output2
    call WriteString
    mov eax, consonantCount
    call WriteDec

    mov edx, OFFSET output3
    call WriteString
    mov eax, digitCount
    call WriteDec

    mov edx, OFFSET output4
    call WriteString
    mov eax, spaceCount
    call WriteDec

    mov edx, OFFSET output5
    call WriteString
    mov al, maxChar
    call WriteChar

    mov edx, OFFSET thankyou
    call WriteString

    exit
main ENDP
END main
