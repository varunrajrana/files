#ifndef __car__
#define __car__

#include "rt.h"
#include "technicians.h"

class car : public ActiveClass{
private:
	int lapnum;
	int lap_time;
	int carnum;
	int idx;
	int race_time;
	string driver;
	int pitstop1;
	int pitstop2;
	int main();
public:
	car();
	car(int index,int num,string name,int p1,int p2);
	~car();
	void stat();
	string desc();
	int racet();
};

#endif // !__car__