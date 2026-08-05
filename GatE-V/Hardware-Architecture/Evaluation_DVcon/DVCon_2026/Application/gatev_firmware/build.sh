EXE_NAME=gatev_test
export PATH=$PATH:../toolchain-bare/bin/:../Util
make clean
make
riscv64-unknown-elf-objdump -D build/$EXE_NAME > build/$EXE_NAME.dump  
riscv64-unknown-elf-objcopy  -I elf64-littleriscv -O binary --remove-section .got --remove-section .got.plt --remove-section .sdata --remove-section .sbss --remove-section .bss --remove-section .comment --gap-fill 0x00 build/$EXE_NAME build/$EXE_NAME.bin

bin2hex --bit-width 64 build/$EXE_NAME.bin build/$EXE_NAME.hex
bin2hex --bit-width 32 build/$EXE_NAME.bin build/$EXE_NAME_32.hex
hex2mif.sh build/$EXE_NAME.hex
hex2mif.sh build/$EXE_NAME_32.hex
hex2mem.sh build/$EXE_NAME.hex
cp build/$EXE_NAME.hex.mem build/$EXE_NAME.mem
