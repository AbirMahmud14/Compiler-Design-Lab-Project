#include <stdio.h>
#include <stdlib.h>

/* This is a multi-line comment
   demonstrating comment extraction */

int global_var = 100; // Global variable declaration

// Function declaration
int calculate(int a, int b);

int main() {
    int local_var = 10; // Local variable
    float pi = 3.14159;
    char letter = 'A';
    char* message = "Hello, World!";
    
    /* Another multi-line comment
       with multiple lines */
    
    // Arithmetic operations
    int sum = local_var + global_var;
    int product = local_var * 2;
    float division = global_var / 3.0;
    
    // Comparison operators
    if (sum > 50) {
        printf("Sum is greater than 50\n");
    } else {
        printf("Sum is less than or equal to 50\n");
    }
    
    // Logical operators
    if (local_var > 5 && global_var < 200) {
        printf("Both conditions are true\n");
    }
    
    // Bitwise operations
    int bit_result = local_var << 2; // Left shift
    int bit_and = local_var & 0xFF;  // Bitwise AND
    
    // Loop with increment/decrement
    for (int i = 0; i < 10; i++) {
        printf("Count: %d\n", i);
    }
    
    // While loop
    int counter = 0;
    while (counter < 5) {
        counter++;
    }
    
    // Function call
    int result = calculate(local_var, global_var);
    printf("Result: %d\n", result);
    
    return 0;
}

// Function definition
int calculate(int a, int b) {
    int temp = a + b;
    temp *= 2; // Compound assignment
    return temp;
}
