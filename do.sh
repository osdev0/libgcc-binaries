#! /bin/sh

set -ex

for target_arch in i386 i686 x86_64 arm aarch64 loongarch64 loongarch64-softfloat riscv64 riscv64-softfloat m68k; do
    case "${target_arch}" in
        arm)
            TARGET="arm-none-eabi" ;;
        loongarch64-softfloat)
            TARGET="loongarch64-elf" ;;
        riscv64-softfloat)
            TARGET="riscv64-elf" ;;
        *)
            TARGET="${target_arch}-elf" ;;
    esac

    CFLAGS_FOR_TARGET=""
    case "${target_arch}" in
        loongarch64-softfloat)
            CFLAGS_FOR_TARGET="-mabi=lp64s" ;;
        riscv64-softfloat)
            CFLAGS_FOR_TARGET="-march=rv64imac_zicsr_zifencei -mabi=lp64" ;;
    esac

    case "${target_arch}" in
        riscv64*)
            CFLAGS_FOR_TARGET="$CFLAGS_FOR_TARGET -mno-relax" ;;
    esac

        CFLAGS_FOR_TARGET="-O2 -pipe -fPIC -Wa,--noexecstack $CFLAGS_FOR_TARGET" \
        TARGET="$TARGET" \
    ./make_toolchain.sh

    cp toolchain/lib/gcc/$TARGET/*/libgcc.a ./libgcc-${target_arch}.a

    case "${target_arch}" in
        x86_64)
            cp toolchain/lib/gcc/$TARGET/*/no-red-zone/libgcc.a ./libgcc-x86_64-no-red-zone.a ;;
    esac
done
