#ifndef _BLOCKING_QUEUE_HPP
#define _BLOCKING_QUEUE_HPP

#include <iostream>

template <typename T> class blocking_queue {
private:
    T *data;
    unsigned long head;
    unsigned long last;
    unsigned long size;
    unsigned long free;

    unsigned long inline idx(unsigned long _idx) {
        return (_idx % this->size);
    }

public:
    blocking_queue(unsigned long size = 32) {
        this->size = size;
        this->data = new T[size];
        this->free = size;
        this->head = 0;
        this->last = 0;
    }

    ~blocking_queue() {
        delete this->data;
    }

    unsigned long take(T *dst, unsigned long n) {
        unsigned long taken = 0;

        while(taken < n && free < size) {
            head = idx(head);
            *dst = data[head];
            dst++;
            taken++;
            free++;
            head++;
        }

        return taken;
    }

    unsigned long put(T *src, unsigned long n) {
        unsigned long written = 0;

        for(; free > 0 && written < n; free--) {
            last = idx(last);
            data[last] = *src;
            src++;
            written++;
            last++;
        }

        return written;
    }

    unsigned long put_one(T x) {
        if(this->free == 0)
            return 0;

        free--;
        last = idx(last);
        data[last] = x;
        last++;
        last = idx(last);
        return 1;
    }

    void print(std::ostream &o) {
        o << "[";
        unsigned long h = 0;
        while(h < size - free) {
            unsigned long i = idx(head + h);
            o << data[i];
            if(h < size - free - 1)
                o << ", ";
            h++;
        }
        o << "]";
    }
};

template <typename T> std::ostream &operator<<(std::ostream &o, blocking_queue<T> &q) {
    q.print(o);
    return o;
}

#endif