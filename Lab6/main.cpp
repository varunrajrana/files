#include "rt.h"
#include "car.h"
#include "technicians.h"

void create_racecars(car**,int,int);
void setup();
void podium(car**);

int main(void) {
	car* cars[10];
	const int laps = 67;
	const int pitstop1 = 20;
	const int pitstop2 = 40;
	CMutex console("F1");
	setup();

	create_racecars(cars,pitstop1,pitstop2);
	for (int i = 0; i < 10; i++) {
		cars[i]->Resume();
	}






	for (int i = 0; i < 10; i++) {
		cars[i]->WaitForThread();
	}
	console.Wait();
	podium(cars);
	console.Signal();
	for (int i = 0; i < 10; i++) {
		delete cars[i];
	}
	getchar();
	return 0;
}

void create_racecars(car* cars[], int pitstop1,int pitstop2) {
	cars[0] = new car(0,44,"Lewis Hamilton",pitstop1,pitstop2);
	cars[1] = new car(1,33, "Max Verstappen", pitstop1, pitstop2);
	cars[2] = new car(2,16, "Charles Leclerc", pitstop1 - 2, pitstop2 - 1);
	cars[3] = new car(3,5, "Sebastian Vettel", pitstop1 + 1, pitstop2 - 2);
	cars[4] = new car(4,4, "Lando Norris", pitstop1, pitstop2);
	cars[5] = new car(5,55, "Carlos Sainz", pitstop1 - 2, pitstop2 - 1);
	cars[6] = new car(6,3, "Daniel Ricciardo", pitstop1 + 1, pitstop2 - 2);
	cars[7] = new car(7,10, "Pierre Gasly", pitstop1 -1, pitstop2 +1);
	cars[8] = new car(8,7, "Kimi Raikkonnen", pitstop1 + 1, pitstop2 - 2);
	cars[9] = new car(9,11, "Sergio Perez", pitstop1, pitstop2);
	return;
}

void setup() {
	MOVE_CURSOR(0, 0);
	cout << "Car#" << endl;
	MOVE_CURSOR(5, 0);
	cout << "Driver" << endl;
	MOVE_CURSOR(25, 0);
	cout << "Lap#" << endl;
	MOVE_CURSOR(30, 0);
	cout << "Total time" << endl;
}

void podium(car* cars[]) {
	car* pod[3] = {cars[0],cars[1] ,cars[2] };
	int top[3] = {0,0,0};
	for (int i = 0; i < 10; i++) {
		if (cars[i]->racet() <= top[0]) {
			pod[2] = pod[1];
			pod[1] = pod[0];
			pod[0] = cars[i];
		}
		else if (cars[i]->racet() >= top[0] && cars[i]->racet() <= top[1]) {
			pod[2] = pod[1];
			pod[1] = cars[i];			
		}
		else if (cars[i]->racet() >= top[1] && cars[i]->racet() <= top[2]) {
			pod[2] = cars[i];
		}
		top[0] = pod[0]->racet();
		top[1] = pod[1]->racet();
		top[2] = pod[2]->racet();
	}
	MOVE_CURSOR(0, 15);
	cout << "Podium of the Grand Prix:" << endl;
	MOVE_CURSOR(0, 16);
	cout << "#1 " << pod[0]->desc() << endl;
	MOVE_CURSOR(0, 17);
	cout << "#2 " << pod[1]->desc() << endl;
	MOVE_CURSOR(0, 18);
	cout << "#3 " << pod[2]->desc() << endl;
	MOVE_CURSOR(0, 19);
	cout << "Press Return to end the Race Weekend" << endl;
}