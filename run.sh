nasm -felf64 -g $1.asm -o $1.o
nasm -felf64 -g libs.asm -o libs.o
ld -o $1 $1.o libs.o
chmod +x $1
./$1

rm $1.o
rm libs.o
rm $1
