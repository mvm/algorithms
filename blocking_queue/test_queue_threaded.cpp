#include "blocking_queue.hpp"
#include <pthread.h>
#include <iostream>
#include <stdlib.h>
#include <unistd.h>

pthread_mutex_t iomutex = PTHREAD_MUTEX_INITIALIZER;

enum message_type {
    MSG_QUIT, // stop the thread
    MSG_SQUARE // send result as square of the input
};

struct message {
    enum message_type type;
    union {
        unsigned long data;
        unsigned int thread_id;
    };
};

struct thread_args {
    unsigned int thread_id;
};

blocking_queue<struct message> send;
blocking_queue<unsigned int> receive;

void *thread_run(void *args) {
    struct thread_args *t_args = (struct thread_args *) args;
    struct message msg;
    pthread_mutex_lock(&iomutex);
    std::cout << "Thread " << t_args->thread_id << " started." << std::endl;
    pthread_mutex_unlock(&iomutex);

    bool quit = false;
    while(!quit) {
        send.take(&msg, 1);

        if(msg.type == MSG_QUIT) {
            if(msg.thread_id == t_args->thread_id) {
                quit = true;
            } else {
                send.put_one(msg);
            }
        } else if(msg.type == MSG_SQUARE) {
            unsigned int result;
            result = msg.data * msg.data;
            receive.put_one(result);
            pthread_mutex_lock(&iomutex);
            std::cout << "Thread " << t_args->thread_id << " computed " << result << "." << std::endl;
            pthread_mutex_unlock(&iomutex);
            usleep(1000);
        } else {
            pthread_mutex_lock(&iomutex);
            std::cout << "Thread " << t_args->thread_id << " unknown message received." << std::endl;
            pthread_mutex_unlock(&iomutex);
        }
    }
    
    return NULL;
}

int main() {
    pthread_t thread1, thread2;
    struct thread_args args[2] = { {.thread_id = 1}, {.thread_id = 2}};
    int ret1, ret2;

    ret1 = pthread_create(&thread1, NULL, &thread_run, &args[0]);
    ret2 = pthread_create(&thread2, NULL, &thread_run, &args[1]);

    for(int i = 0; i < 16; i++) {
        struct message msg;
        msg.type = MSG_SQUARE;
        msg.data = rand() % 1000;
        send.put_one(msg);
    }
    struct message quit_msg;
    quit_msg.type = MSG_QUIT;
    quit_msg.thread_id = 1;
    send.put_one(quit_msg);
    quit_msg.thread_id = 2;
    send.put_one(quit_msg);

    pthread_join(thread1, NULL);
    pthread_join(thread2, NULL);

    std::cout << "Threads finished." << std::endl;
    std::cout << "Result: " << receive << std::endl;
    return 0;
}
