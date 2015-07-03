struct foo{
	struct outside{
		int oa;
		char ob;
		unsigned oc;
	}m;
	struct outside1{
		int o1a;
		char o1b;
		unsigned o1c;
	}m1;
};

struct bfield{
	int x:7;
	int y:8;
	unsigned a;
	int z:17;
	int h:31;
};



