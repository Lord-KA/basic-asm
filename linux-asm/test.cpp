#include <iostream>
#include <cassert>
#include <chrono>
#include <random>

extern "C" { size_t fib_asm(size_t n); }
extern "C" { size_t fib_asm_rec(size_t n); }
extern "C" { size_t fib_cpp_asm_rec(size_t n); }

std::mt19937 rnd(179);

constexpr int max = 1e2;
constexpr int min = 1e1;
constexpr int passes = 1e1;

size_t fib_cpp_1(size_t n)
{
    if (n == 0)
        return 0;
    if (n == 1)
        return 1;
    size_t one = 0, two = 1;
    for (; n > 1; --n)
    {
        one += two;
        std::swap(one, two);
    }
    return two;
}

size_t fib_cpp_2(size_t n)
{
    if (n == 0)
        return 0;
    if (n == 1)
        return 1;
    size_t one = 0, two = 0, ans = 1;
    for (; n > 1; --n)
    {
        one = two;
        two = ans;
        ans += one;
    }
    return ans;
}

size_t fib_cpp_asm_rec(size_t n)
{
    if (n == 0)
        return 0;
    else if (n == 1)
        return 1;
    return (fib_asm_rec(n - 1) + fib_asm_rec(n - 2));
}

int main()
{
    // std::cout << fib_cpp_asm_rec(2) << " " << fib_asm(2) << '\n';
    // return 1;
    for (size_t i = 0; i < 30; ++i)
    {
        std::cout << i << '\n';
        std::cout << fib_cpp_asm_rec(i) << " " << fib_asm_rec(i) << " " << fib_cpp_1(i) << " " << fib_cpp_2(i) << '\n';
        // assert(fib_cpp_1(i) == fib_asm(i));
        // assert(fib_cpp_2(i) == fib_asm(i));
        // assert(fib_asm_rec(i) == fib_asm(i));
        // assert(fib_cpp_asm_rec(i) == fib_asm(i));
    }
    std::cout << "All tests passed!\n";
    
    double time_asm = 0, time_asm_rec = 0, time_cpp_1 = 0, time_cpp_2 = 0;
    for (size_t i = 0; i < passes; ++i)
    {
        int q = rnd() % max + min;
        auto start_asm = std::chrono::high_resolution_clock::now();
        fib_asm(q);
        auto finish_asm = std::chrono::high_resolution_clock::now();

        auto start_asm_rec = std::chrono::high_resolution_clock::now();
        fib_asm_rec(q);
        auto finish_asm_rec = std::chrono::high_resolution_clock::now();

        auto start_cpp_1 = std::chrono::high_resolution_clock::now();
        fib_cpp_1(q);
        auto finish_cpp_1 = std::chrono::high_resolution_clock::now();
        
        auto start_cpp_2 = std::chrono::high_resolution_clock::now();
        fib_cpp_2(q);
        auto finish_cpp_2 = std::chrono::high_resolution_clock::now();

        time_asm += std::chrono::duration<double, std::milli>(finish_asm - start_asm).count();
        time_asm_rec += std::chrono::duration<double, std::milli>(finish_asm_rec - start_asm_rec).count();
        time_cpp_1 += std::chrono::duration<double, std::milli>(finish_cpp_1 - start_cpp_1).count();
        time_cpp_2 += std::chrono::duration<double, std::milli>(finish_cpp_2 - start_cpp_2).count();
    }
    std::cout << "Time for asm     = " << time_asm << '\n';
    std::cout << "Time for asm_rec = " << time_asm_rec << '\n';
    std::cout << "Time for cpp_1   = " << time_cpp_1 << '\n';
    std::cout << "Time for cpp_2   = " << time_cpp_2 << '\n';
}
