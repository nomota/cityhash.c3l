// example.c3
// 
// Example usage of CityHash in C3

module example;

import cityhash;
import cityhashcrc;
import std::io;

fn void main()
{
    // Test strings
    String test1 = "Hello, World!";
    String test2 = "The quick brown fox jumps over the lazy dog";
    String test3 = "Lorem ipsum dolor sit amet, consectetur adipiscing elit";
    
    io::printfn("=== CityHash64 Examples ===\n");
    
    // CityHash64
    ulong hash1 = cityhash::CityHash64(test1.ptr, test1.len);
    io::printfn("CityHash64('%s') = 0x%016llx", test1, hash1);
    
    ulong hash2 = cityhash::CityHash64(test2.ptr, test2.len);
    io::printfn("CityHash64('%s') = 0x%016llx", test2, hash2);
    
    ulong hash3 = cityhash::CityHash64(test3.ptr, test3.len);
    io::printfn("CityHash64('%s') = 0x%016llx\n", test3, hash3);
    
    // CityHash64WithSeed
    io::printfn("=== CityHash64WithSeed Examples ===\n");
    ulong seed = 0x1234567890ABCDEF;
    ulong hash_seeded = cityhash::CityHash64WithSeed(test1.ptr, test1.len, seed);
    io::printfn("CityHash64WithSeed('%s', 0x%016llx) = 0x%016llx\n", test1, seed, hash_seeded);
    
    // CityHash128
    io::printfn("=== CityHash128 Examples ===\n");
    uint128 hash128_1 = cityhash::CityHash128(test1.ptr, test1.len);
    ulong low1 = cityhash::uint128_low64!(hash128_1);
    ulong high1 = cityhash::uint128_high64!(hash128_1);
    io::printfn("CityHash128('%s') = 0x%016llx%016llx", test1, high1, low1);
    
    uint128 hash128_2 = cityhash::CityHash128(test2.ptr, test2.len);
    ulong low2 = cityhash::uint128_low64!(hash128_2);
    ulong high2 = cityhash::uint128_high64!(hash128_2);
    io::printfn("CityHash128('%s') = 0x%016llx%016llx\n", test2, high2, low2);
    
    // CityHash128WithSeed
    io::printfn("=== CityHash128WithSeed Examples ===\n");
    uint128 seed128 = ((uint128)0xFEDCBA0987654321 << 64) | (uint128)0x1234567890ABCDEF;
    uint128 hash128_seeded = cityhash::CityHash128WithSeed(test1.ptr, test1.len, seed128);
    ulong low_s = cityhash::uint128_low64!(hash128_seeded);
    ulong high_s = cityhash::uint128_high64!(hash128_seeded);
    io::printfn("CityHash128WithSeed('%s', ...) = 0x%016llx%016llx\n", test1, high_s, low_s);
    
    // CityHashCrc (if SSE4.2 is available)
    io::printfn("=== CityHashCrc Examples (requires SSE4.2) ===\n");
    uint128 hash_crc = cityhashcrc::CityHashCrc128(test2.ptr, test2.len);
    ulong low_crc = cityhash::uint128_low64!(hash_crc);
    ulong high_crc = cityhash::uint128_high64!(hash_crc);
    io::printfn("CityHashCrc128('%s') = 0x%016llx%016llx", test2, high_crc, low_crc);
    
    // CityHashCrc256
    ulong[4] result256;
    cityhashcrc::CityHashCrc256(test3.ptr, test3.len, &result256);
    io::printfn("CityHashCrc256('%s') =", test3);
    io::printfn("  [0] = 0x%016llx", result256[0]);
    io::printfn("  [1] = 0x%016llx", result256[1]);
    io::printfn("  [2] = 0x%016llx", result256[2]);
    io::printfn("  [3] = 0x%016llx\n", result256[3]);
    
    // Demonstrate collision resistance
    io::printfn("=== Collision Resistance ===\n");
    String similar1 = "hash";
    String similar2 = "Hash";
    ulong hash_s1 = cityhash::CityHash64(similar1.ptr, similar1.len);
    ulong hash_s2 = cityhash::CityHash64(similar2.ptr, similar2.len);
    io::printfn("CityHash64('%s') = 0x%016llx", similar1, hash_s1);
    io::printfn("CityHash64('%s') = 0x%016llx", similar2, hash_s2);
    io::printfn("Different hashes for similar strings: %s\n", hash_s1 != hash_s2 ? "Yes" : "No");
    
    // Performance note
    io::printfn("=== Performance Notes ===");
    io::printfn("CityHash64 is optimized for x86-64 with high instruction-level parallelism");
    io::printfn("CityHash128 is faster than CityHash64 for strings > 2000 bytes");
    io::printfn("CityHashCrc variants require SSE4.2 and are fastest for very long strings");
    io::printfn("\nWarning: CityHash is NOT suitable for cryptographic purposes!");
}
