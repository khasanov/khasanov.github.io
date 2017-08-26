// GOTO label inside class method, do not use in production!!!
// g++ -Wno-pmf-conversions horror.cpp

#ifndef HORROR_H
#define HORROR_H

#include 
#include 

struct Foo {
    void foo() {
        void (Foo::*fptr)() = &Foo::foo;
        std::cout << "We are on foo() " << (void*)fptr << std::endl;
        
label1:
        std::cout << "We are on label1 " << &&label1 << std::endl;
        
label2:
        std::cout << "We are on label2 " << &&label2 << std::endl;
        std::cout << "enjoy!" << std::endl;
        std::exit(EXIT_FAILURE);
    }
};

int main() {
    void (Foo::*fptr)() = &Foo::foo;
    char* cptr = (char*)(void*)fptr;
    cptr += 0x9e;
    goto *((void*)cptr);
    return 0;
}

#endif // HORROR_H

