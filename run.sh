nasm -felf64 -g $1.asm -o $1.o
ld -o $1 $1.o
chmod u+x $1
./hello

rm hello.o
rm hello
