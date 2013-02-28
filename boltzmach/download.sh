#!/bin/sh

(for i in $(seq 0 9) ; do
	echo "http://www.cs.nyu.edu/~roweis/data/usps_$i.jpg"
done ) | xargs wget

