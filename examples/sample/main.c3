// examples/simple/main.c3
// Simple example using CityHash as a vendor library
module simple_example;
import cityhash;
import std::io;

fn void main()
{
    io::printfn("=== CityHash Vendor Example ===\n");
    
    // Example 1: Basic hashing
    String text = "Hello, C3 Vendor!";
    ulong hash = cityhash::CityHash64(text.ptr, text.len);
    io::printfn("Text: '%s'", text);
    io::printfn("Hash: 0x%016llx\n", hash);
    
    // Example 2: Hash with seed
    ulong seed = 0xDEADBEEF;
    ulong hash_seeded = cityhash::CityHash64WithSeed(text.ptr, text.len, seed);
    io::printfn("Hash with seed 0x%016llx: 0x%016llx\n", seed, hash_seeded);
    
    // Example 3: 128-bit hash
    uint128 hash128 = cityhash::CityHash128(text.ptr, text.len);
    ulong low = cityhash::uint128_low64!(hash128);
    ulong high = cityhash::uint128_high64!(hash128);
    io::printfn("128-bit hash: 0x%016llx%016llx\n", high, low);
    
    // Example 4: Multiple strings
    io::printfn("=== Hashing Multiple Strings ===");
    String[] items = {
        "apple",
        "banana",
        "cherry",
        "date",
        "elderberry"
    };
    
    foreach (i, item : items) {
        ulong h = cityhash::CityHash64(item.ptr, item.len);
        io::printfn("[%d] '%s' -> 0x%016llx", i, item, h);
    }
    
    io::printfn("\n✓ CityHash vendor library working correctly!");
}
