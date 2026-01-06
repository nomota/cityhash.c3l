#!/bin/bash
# build.sh - Build script for CityHash C3 implementation

set -e

echo "=========================================="
echo "CityHash C3 Build Script"
echo "=========================================="

# Check if c3c is installed
if ! command -v c3c &> /dev/null; then
    echo "Error: c3c compiler not found!"
    echo "Please install C3 compiler from https://c3-lang.org/"
    exit 1
fi

echo "C3 compiler found: $(c3c --version)"
echo ""

# Build options
BUILD_TYPE=${1:-all}

case $BUILD_TYPE in
    lib)
        echo "Building CityHash library (without SSE4.2)..."
        c3c compile cityhash.c3 --lib -o libcityhash
        echo "✓ Library built: libcityhash.a"
        ;;
    
    lib-sse)
        echo "Building CityHash library (with SSE4.2)..."
        c3c compile cityhash.c3 cityhashcrc.c3 --lib -o libcityhash_sse \
            --target x86_64 --feature sse4.2
        echo "✓ Library built: libcityhash_sse.a"
        ;;
    
    example)
        echo "Building example program..."
        c3c compile cityhash.c3 cityhashcrc.c3 example.c3 -o cityhash_example \
            --target x86_64 --feature sse4.2 2>/dev/null || \
        c3c compile cityhash.c3 example.c3 -o cityhash_example
        echo "✓ Example built: cityhash_example"
        echo ""
        echo "Run with: ./cityhash_example"
        ;;
    
    test)
        echo "Building test program..."
        c3c compile cityhash.c3 test.c3 -o cityhash_test
        echo "✓ Test program built: cityhash_test"
        echo ""
        echo "Run with: ./cityhash_test"
        ;;
    
    vendor-example)
        echo "Building vendor example..."
        if [ -d "examples/simple" ]; then
            cd examples/simple
            c3c build
            echo "✓ Vendor example built: examples/simple/build/simple_example"
            echo ""
            echo "Run with: cd examples/simple && ./build/simple_example"
        else
            echo "Error: examples/simple directory not found"
            exit 1
        fi
        ;;
    
    clean)
        echo "Cleaning build artifacts..."
        rm -f libcityhash.a libcityhash_sse.a cityhash_example cityhash_test
        rm -rf build/
        [ -d "examples/simple/build" ] && rm -rf examples/simple/build
        echo "✓ Clean complete"
        ;;
    
    all)
        echo "Building all targets..."
        echo ""
        
        echo "[1/5] Building basic library..."
        c3c compile cityhash.c3 --lib -o libcityhash
        
        echo "[2/5] Building SSE4.2 library..."
        c3c compile cityhash.c3 cityhashcrc.c3 --lib -o libcityhash_sse \
            --target x86_64 --feature sse4.2 2>/dev/null || echo "  (SSE4.2 not available)"
        
        echo "[3/5] Building example..."
        c3c compile cityhash.c3 cityhashcrc.c3 example.c3 -o cityhash_example \
            --target x86_64 --feature sse4.2 2>/dev/null || \
        c3c compile cityhash.c3 example.c3 -o cityhash_example
        
        echo "[4/5] Building tests..."
        c3c compile cityhash.c3 test.c3 -o cityhash_test
        
        echo "[5/5] Building vendor example..."
        if [ -d "examples/simple" ]; then
            (cd examples/simple && c3c build) || echo "  (Vendor example skipped)"
        fi
        
        echo ""
        echo "=========================================="
        echo "✓ Build complete!"
        echo "=========================================="
        echo "Libraries:"
        echo "  - libcityhash.a (basic)"
        [ -f "libcityhash_sse.a" ] && echo "  - libcityhash_sse.a (with SSE4.2)"
        echo ""
        echo "Executables:"
        echo "  - cityhash_example (run examples)"
        echo "  - cityhash_test (run tests)"
        [ -f "examples/simple/build/simple_example" ] && echo "  - examples/simple/build/simple_example (vendor example)"
        echo ""
        echo "Try: ./cityhash_example"
        echo "     ./cityhash_test"
        [ -f "examples/simple/build/simple_example" ] && echo "     cd examples/simple && ./build/simple_example"
        ;;
    
    *)
        echo "Usage: $0 [target]"
        echo ""
        echo "Targets:"
        echo "  lib            - Build basic library (no SSE4.2)"
        echo "  lib-sse        - Build library with SSE4.2 support"
        echo "  example        - Build example program"
        echo "  test           - Build test program"
        echo "  vendor-example - Build vendor usage example"
        echo "  all            - Build everything (default)"
        echo "  clean          - Remove build artifacts"
        echo ""
        echo "Examples:"
        echo "  $0               # Build everything"
        echo "  $0 lib           # Build library only"
        echo "  $0 vendor-example # Build vendor example"
        echo "  $0 clean         # Clean build files"
        exit 1
        ;;
esac

echo ""
