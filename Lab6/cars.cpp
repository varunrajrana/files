#include "car.h"

car::car() {
	carnum = 0;
	driver = "error";
	pitstop1 = 0;
	pitstop2 = 0;
	idx = -1;
	lap_time = rand() % 10 + 4;
	lapnum = 0;
	race_time = 0;
}

car::car(int index,int num, string name, int p1, int p2) {
	idx = index;
	carnum = num;
	driver = name;
	pitstop1 = p1;
	pitstop2 = p2;
	lap_time = idx+rand() % 10 + 4;
	lapnum = 0;
	race_time = 0;
}

car::~car() {}

int car::main() {
	CMutex console("F1");
	while (lapnum <= 67) {
		Sleep(lap_time*10);
		lapnum++;
		race_time = race_time+ (lap_time * 10);
		console.Wait();
		stat();
		console.Signal();
	}
	return 0;
};

void car::stat() {
	MOVE_CURSOR(0,idx+1);
	cout << "#" << carnum << endl;
	MOVE_CURSOR(5, idx+1);
	cout << driver << endl;
	MOVE_CURSOR(25, idx+1);
	cout << lapnum << endl;
	//test
	MOVE_CURSOR(30, idx + 1);
	cout << race_time << endl;
}

int car::racet() {
	return race_time;
}

string car::desc() {
	return "#" + to_string(carnum) + " " + driver;
}