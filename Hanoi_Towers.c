//Authors: Gustavo Rueda & salvador Briones
#include<stdio.h>
#include<stdlib.h>

#define n_disk 5

void printHanoi(int *tower);
void hanoiTower(int disk, int **start, int **finish, int **spare);
void move(int **towerATip, int **towerBTip);
void push(int disk, int **tower);
int pop(int **tower);

int main(){
	int * towerA;									//We need 3 Stacks for each tower (A, B and C).
	int * towerB;									//We need 3 Stacks for each tower (A, B and C).
	int * towerC;									//We need 3 Stacks for each tower (A, B and C).
	int * toPrint;

	towerA = (int *)calloc(n_disk, sizeof(int));	//Memory's reservation
	towerB = (int *)calloc(n_disk, sizeof(int));	//Memory's reservation
	towerC = (int *)calloc(n_disk, sizeof(int));	//Memory's reservation
	toPrint = towerC;

	for(int i = 0; i < n_disk; i++)					//Tower A fill. towerA = n_disk, n_disk - 1, n_disk - 2, ... , 0
		towerA[i] = n_disk - i;

	towerA += n_disk;								//The pointer increases by n_disk. (The stack works only with the top element)

	hanoiTower(n_disk, &towerA, &towerB, &towerC);	//Calling the function.
	printHanoi(toPrint);							//Print the result.
	system("pause");
	return 0;
}

/*
 * This is a recursive function that does the  Hanoi's Towers algorithm.
 * disk - The disk's number [0,n].
 * start - It refers to the tower's top where the disk is.
 * finish - It refers to the tower's top where the disk must end.
 * spare - It refers to the auxiliary tower's top.
 */
void hanoiTower(int disk, int **start, int **spare, int **finish){
	if(disk == 1){
		move(start,finish);
	}
	else{
		hanoiTower(disk - 1, start, finish, spare);	//Recursion's start
		move(start,finish);
		hanoiTower(disk - 1, spare, start, finish); //Recursion's start
	}
}

/*
 * This is a functions function removes to top element of an Stack A
 * and pushes it to the top of an Stack B.
 * towerATop - The tower's top to be "poped" and pushed to Tower B.
 * TowerBTop - The tower's top.
 */
void move(int **towerATop, int **towerBTop){
	int disk = pop(towerATop);
	push(disk, towerBTop);
}

/*
 * This function pushes an element to an Stack's top.
 * disk - The element to be pushed.
 * tower - The Stack's current top.
 */
void push(int disk, int **tower){
	**tower = disk;
	(*tower)++;
}

/*
 * This function pops an Stack's top and returns it.
 * tower - The Stack's current top that will be "poped".
 */
int pop(int **tower){
	(*tower)--;
	int number = **tower;
	return number;
}

/*
 * This function prints a Stack (tower).
 * tower - The stack to print.
 */
void printHanoi(int *tower){
	printf("[ ");
	for(int i = 0; i < n_disk; i++)
		printf("%d ",tower[i]);
	printf("]");
}
