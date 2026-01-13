
#COMPILER_GCC_10=gcc-arm-none-eabi-10-2020-q4-major-x86_64
COMPILER_GCC_13=arm-gnu-toolchain-13.3.rel1-x86_64-arm-none-eabi
root=$(pwd)
tool_dir="${root}/../tools"
cross_compiler=${COMPILER_GCC_13}

CROSS_PATH="$tool_dir/${cross_compiler}/bin"

export PATH=${CROSS_PATH}:$PATH
