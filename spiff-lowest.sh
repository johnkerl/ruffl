for d in `jot 1 32`; do
	echo -n "$d : "
	spiff f2pfind -1 -i $d
done
