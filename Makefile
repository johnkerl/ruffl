top: regression publish upload

regression:
	regress
publish:
	cd .. && tar zcf ruffl.tgz ruffl
upload:
	cd .. && pushpwd
