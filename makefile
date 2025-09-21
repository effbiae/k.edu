SHELL=bash
# FIXME https://reviews.llvm.org/D117798
I=-D__builtin_ia32_pmaxud512=__builtin_elementwise_max -D__builtin_ia32_pmaxub512=__builtin_elementwise_max
#S=-nostdlib -fno-builtin
V=-mavx512{f,dq,vbmi,vnni,vpopcntdq,bw} 
D=-O0 -g3 -fdebug-macro -fstandalone-debug
W=-Wno-int-conversion -Wno-parentheses -Wno-shift-op-parentheses -Wno-bitwise-conditional-parentheses -Wno-incompatible-pointer-types-discards-qualifiers
W2=-Wincompatible-pointer-types -Wno-multichar
#-Wno-incompatible-function-pointer-types

#tag:yyyy.mm.dd (+sha)
d=$(shell git log -1 --format="%at" | xargs -I{} date -d @{} +%Y.%m.%d)
h=$(shell git rev-parse --short HEAD)
T="\"$d\"" # $h

a:?.[ch] makefile
	clang-15 $W $(W2) -DTAG=$T -oa ?.c $S -f{unsigned-char,no-unwind-tables} $V $D $I
	#lldb-14 -o run -- ./a t.k
