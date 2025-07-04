# Cortex BSP Kit

A flexible build system framework for combining Bare Metal System Platform (BSP) libraries with benchmark applications for ARM Cortex-M microcontrollers.

## Overview

Cortex BSP Kit provides a modular approach to building embedded applications by allowing you to:
- Dynamically select BSP libraries for different microcontroller platforms
- Choose benchmark applications to run on the selected BSP
- Automatically link BSP and benchmark components
- Generate final executables, hex files, and size reports

## Architecture

```
cortex-bsp-kit/
├── CMakeLists.txt              # Main build configuration
├── cmake/
│   └── AddBenchmark.cmake      # Macro for benchmark library creation
├── bsp/                        # BSP libraries
│   └── <architecture>/
│       └── <board-name>/       # Specific BSP implementation
│           ├── CMakeLists.txt  # BSP library configuration
│           ├── src/            # BSP source files
│           ├── include/        # BSP header files
│           └── script/         # Linker scripts
└── benchmark/                  # Benchmark applications
    └── <benchmark-suite>/      # Benchmark suite (e.g., embench-2.0)
        ├── CMakeLists.txt     # Benchmark configuration
        ├── src/               # Benchmark source files
        └── support/           # Common support files
```

## Key Features

### 1. Dynamic BSP Selection
- Specify BSP using `-DBSP=<path>` parameter
- Automatic BSP target name extraction from path
- Support for multiple BSP platforms and architectures

### 2. Flexible Benchmark Integration
- Choose benchmark suite with `-DBENCHMARK=<name>`
- Select specific benchmark target with `-DBENCHMARK_TARGET=<name>`
- Automatic library creation and linking
- Support for any benchmark suite that follows the framework conventions

### 3. Modular Build System
- BSP components built as static libraries
- Benchmark components built as static libraries
- Final executable links both BSP and benchmark libraries
- Clean separation of concerns

### 4. Cross-Platform Support
- ARM Cortex-M toolchain support
- Configurable compiler flags and linker settings
- Support for different microcontroller architectures
- Extensible for new architectures

## Prerequisites

### Required Tools
- CMake 3.16 or higher
- ARM GCC toolchain (arm-none-eabi-gcc)
- Python 3.11.3 (for virtual environment)

### Environment Setup
```bash
# Activate Python virtual environment
source /nfs/teams/sw/share/swqa/venv/3.11.3/bin/activate

# Verify CMake version
cmake --version

# Verify ARM toolchain
arm-none-eabi-gcc --version
```

## Usage

### Modern CMake Build Process (Recommended)

This project uses out-of-source builds, keeping the project root clean.

#### 1. Configure the project
```bash
# Configure with specific BSP and benchmark
cmake -B build -S . -DBSP=<architecture>/<board-name> \
      -DBENCHMARK=<benchmark-suite> \
      -DBENCHMARK_TARGET=<target-name>
```

#### 2. Build targets
```bash
# Build specific target
cmake --build build --target <target-name>_with_bsp.elf

# Build all benchmarks
cmake --build build --target build_all_benchmarks

# List available targets
cmake --build build --target list_targets
```

### Traditional Build Process

#### 1. Create build directory
```bash
mkdir build
cd build
```

#### 2. Configure with CMake
```bash
cmake -DBSP=<architecture>/<board-name> \
      -DBENCHMARK=<benchmark-suite> \
      -DBENCHMARK_TARGET=<target-name> ..
```

#### 3. Build the project
```bash
make <target-name>_with_bsp.elf
```

### Demo Commands

```bash
# Example 1: Build with Renesas RA8M1 BSP and a specific benchmark
cmake -B build -S . -DBSP=cortex-m85/renesas-ra8m1 \
      -DBENCHMARK=embench-2.0 \
      -DBENCHMARK_TARGET=aha-mont64
cmake --build build --target aha-mont64_with_bsp.elf

# Example 2: Build with a different benchmark target
cmake -B build -S . -DBSP=cortex-m85/renesas-ra8m1 \
      -DBENCHMARK=embench-2.0 \
      -DBENCHMARK_TARGET=crc32
cmake --build build --target crc32_with_bsp.elf

# Example 3: Build all benchmarks (no specific target)
cmake -B build -S . -DBSP=cortex-m85/renesas-ra8m1 \
      -DBENCHMARK=embench-2.0
cmake --build build --target build_all_benchmarks

# Example 4: List all available targets
cmake -B build -S . -DBSP=cortex-m85/renesas-ra8m1 \
      -DBENCHMARK=embench-2.0
cmake --build build --target list_targets
```

### Available Parameters

| Parameter | Description | Example |
|-----------|-------------|---------|
| `BSP` | Path to BSP directory | `cortex-m85/renesas-ra8m1` |
| `BENCHMARK` | Benchmark suite name | `embench-2.0`, `coremark` |
| `BENCHMARK_TARGET` | Specific benchmark target | `aha-mont64`, `crc32` |

### Build Targets

After configuration, the following targets are available:

#### BSP Targets
- `<board-name>` - Build BSP library (e.g., `renesas-ra8m1`)

#### Benchmark Targets
- `<target-name>` - Build benchmark library (varies by selection)

#### Final Executable Targets
- `<target-name>_with_bsp.elf` - Final executable
- `<target-name>_hex` - Generate hex file
- `<target-name>_size` - Generate size report
- `<target-name>_all` - Build all outputs
- `build_all_benchmarks` - Build all benchmark executables

### Example Commands

```bash
# List all available targets
cmake --build build --target list_targets

# Build specific benchmark with BSP
cmake --build build --target <target-name>_with_bsp.elf

# Generate hex file
cmake --build build --target <target-name>_hex

# Generate size report
cmake --build build --target <target-name>_size

# Build everything
cmake --build build --target <target-name>_all
```

## Porting Guide

### Adding a New BSP

#### 1. Create BSP Directory Structure
```
bsp/<architecture>/<board-name>/
├── CMakeLists.txt
├── src/
│   ├── main.c
│   ├── board_init.c
│   └── [other source files]
├── include/
│   ├── board.h
│   └── [other header files]
└── script/
    └── <board-name>.ld
```

#### 2. Implement BSP CMakeLists.txt
```cmake
# BSP Library for <Board Name>
# This is a component library that will be used by the main project

# Source files for the BSP library
set(BSP_SOURCES
    src/main.c
    src/board_init.c
    # Add other source files here
)

# Create BSP library
add_library(<board-name> STATIC ${BSP_SOURCES})

# Set library properties
set_target_properties(<board-name> PROPERTIES
    OUTPUT_NAME "<board-name>"
    ARCHIVE_OUTPUT_NAME "<board-name>"
    PREFIX "lib"
    C_STANDARD 99
    C_STANDARD_REQUIRED ON
)

# Set include directories
target_include_directories(<board-name> PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}/include
    # Add other include directories here
)
```

#### 3. Key Requirements for BSP
- **Library Name**: Must match the last part of the BSP path
- **Static Library**: Must be built as static library
- **C Standard**: Should support C99
- **Include Directories**: Must be PUBLIC for benchmark access
- **Linker Script**: Should be placed in `script/` directory

#### 4. Use the New BSP
```bash
cmake -B build -S . -DBSP=<architecture>/<board-name> \
      -DBENCHMARK=<benchmark-suite> \
      -DBENCHMARK_TARGET=<target>
```

### Adding a New Benchmark Suite

#### 1. Create Benchmark Directory Structure
```
benchmark/<benchmark-suite>/
├── CMakeLists.txt
├── src/
│   ├── benchmark1/
│   │   ├── benchmark1.c
│   │   └── benchmark1.h
│   └── benchmark2/
│       ├── benchmark2.c
│       └── benchmark2.h
└── support/
    ├── common.h
    └── common.c
```

#### 2. Implement Benchmark CMakeLists.txt
```cmake
# Benchmark Suite: <Benchmark Suite Name>

# Common source files (if any)
set(COMMON_SRCS
    support/common.c
    # Add other common files
)

# Define benchmark targets
set(TARGETS
    benchmark1
    benchmark2
    # Add other benchmarks
)

# Define source files for each benchmark
set(benchmark1_SRCS
    src/benchmark1/benchmark1.c
    ${COMMON_SRCS}
)

set(benchmark2_SRCS
    src/benchmark2/benchmark2.c
    ${COMMON_SRCS}
)

# Common include directories
set(COMMON_INCLUDE_DIRS
    support
    # Add other common include directories
)

# Create each benchmark library
foreach(target ${TARGETS})
    set(TARGET_SRCS ${${target}_SRCS})
    
    # Use the add_benchmark macro
    add_benchmark(TARGET_NAME ${target} 
                  SOURCE_FILES ${TARGET_SRCS} 
                  INCLUDE_FOLDERS ${COMMON_INCLUDE_DIRS})
endforeach()

# Export target names to parent scope
set(ALL_BENCHMARK_TARGETS ${TARGETS} PARENT_SCOPE)
```

#### 3. Key Requirements for Benchmark Suite
- **Use add_benchmark Macro**: Must use the provided macro for consistency
- **Library Targets**: Each benchmark should be a separate library target
- **Common Files**: Share common code through COMMON_SRCS
- **Include Directories**: Set up proper include paths
- **Export Targets**: Must export ALL_BENCHMARK_TARGETS to parent scope

#### 4. Use the New Benchmark Suite
```bash
cmake -B build -S . -DBSP=<architecture>/<board-name> \
      -DBENCHMARK=<benchmark-suite> \
      -DBENCHMARK_TARGET=<benchmark-name>
```

### Adding a New Architecture

#### 1. Update Main CMakeLists.txt
Add architecture-specific toolchain settings:

```cmake
# Example for a new architecture
if(BSP MATCHES "cortex-m4")
    set(CMAKE_C_FLAGS "-mcpu=cortex-m4 -mthumb -mfloat-abi=hard -mfpu=fpv4-sp-d16")
    # Add architecture-specific flags
elseif(BSP MATCHES "cortex-m7")
    set(CMAKE_C_FLAGS "-mcpu=cortex-m7 -mthumb -mfloat-abi=hard -mfpu=fpv5-d16")
    # Add architecture-specific flags
endif()
```

#### 2. Create Architecture-Specific BSPs
Follow the BSP porting guide above, but organize under the new architecture directory.

## Build System Details

### CMake Configuration
The main `CMakeLists.txt` provides:
- Cross-compilation setup for ARM Cortex-M
- Global compiler and linker flags
- Preprocessor definitions
- Dynamic BSP and benchmark inclusion
- Automatic BSP target name extraction

### AddBenchmark Macro
The `cmake/AddBenchmark.cmake` macro:
- Creates static libraries from benchmark source files
- Sets include directories
- Configures C standard (C99)
- Enables easy benchmark integration without modifying source code
- Provides consistent interface across all benchmark suites

### BSP Library Structure
Each BSP provides:
- Static library target
- Include directories
- Source files
- Linker scripts
- Hardware-specific configurations

## Troubleshooting

### Common Issues

1. **ARM toolchain not found**
   ```bash
   # Install ARM GCC toolchain
   # Or set CMAKE_C_COMPILER to correct path
   ```

2. **CMake configuration errors**
   - Verify all required parameters are set
   - Check BSP and benchmark paths exist
   - Ensure CMake version is 3.16+

3. **Build errors**
   - Check ARM toolchain installation
   - Verify source files exist
   - Check include paths
   - Ensure BSP library name matches path

4. **Linking errors**
   - Verify BSP target name matches library name
   - Check that benchmark uses add_benchmark macro
   - Ensure all dependencies are properly linked

### Debug Information

Enable verbose output:
```bash
cmake --build build --verbose
```

View CMake configuration:
```bash
cmake --build build --target list_targets
```

Check available targets:
```bash
cmake --build build --target help
```
