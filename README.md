# Algorithms

These are just some simple algorithms and data structures I've written.

`blocking_queue` contains a simple queue implemented with a circular array.
The idea is to make it safe for multi-threaded programs in order to use it
as a message queue. In `blocking_queue` two sample programs are available
for testing the queue. `test_queue1` uses it in a single thread, to test the
basic functionality of the queue. `test_queue_threaded` uses it to send and
receive messages to a set of threads used as consumers, and the main thread
used as producer.

`fft` contains an implementation of the Tukey-Cooley FFT algorithm in Ruby.

License: Simplified BSD License
