#include "blocking_queue.hpp"
#include <iostream>
#include <stdlib.h>

int main(int argc, char **argv) {
    blocking_queue<float> queue(32);
    unsigned long put = 0;

    while(queue.put_one(rand() % 1000) > 0 && put < 16) {
        put++;
    }

    std::cout << "Put " << put << " elements." << std::endl;

    std::cout << "Queue = " << queue << std::endl;

    float temp[8];
    queue.take(temp, 8);
    std::cout << "Queue after take = " << queue << std::endl;

    put = 0;
    while(queue.put_one(rand() % 1000) > 0 && put < 20) {
        put++;
    }
    std::cout << "Queue after put_one = " << queue << std::endl;

    float temp2[16];
    queue.take(temp2, 16);
    std::cout << "Queue after take 2 = " << queue << std::endl;

    queue.put(temp2, 16);
    std::cout << "Queue after put 2 = " << queue << std::endl;
    return 0;
}