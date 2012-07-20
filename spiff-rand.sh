for d in 8 20 49 88; do
	for x in `jot 1 10` ; do
		f=`spiff f2prandom $d`
		echo -n "$f : "
		spiff f2pfactor $f
	done
done
