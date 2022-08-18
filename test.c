
#include <stdlib.h>
#include <stdio.h>
#include <ncurses.h>


/*
  blatant rip from
  https://tldp.org/HOWTO/NCURSES-Programming-HOWTO/init.html
  
*/

/*  let the pain begin ... we never actually finished
    we went back to common lisp sbcl n all that jazz

#define WIDTH 30
#define HEIGHT 10 

int startx = 0;
int starty = 0;
ulong tick = 0;

char *choices[] = { 
			"Choice 1",
			"Choice 2",
			"Choice 3",
			"Choice 4",
			"Exit",
		  };
int n_choices = sizeof(choices) / sizeof(char *);
void print_menu(WINDOW *menu_win, int highlight);
*/

static WINDOW *w;

// ncurses start -- 

void setup()
{
  /*
	w = initscr();
	clear();
	raw();
	noecho();
	nodelay(w , true);
	cbreak();	// Line buffering disabled. pass on everything 

	// clear screen ?
	
	//mvprintw(0, 0, " ticker = %ul \n", tick);
	mvprintw(0, 0, "--- ncurses sanity check --\n");
	refresh();
	*/
}

/*
extern WINDOW *initscr();
extern void endwin();
*/




void finish(){
  /*
	refresh();
	endwin();
  */
}



/* int dummy() */
/* { */
/*         WINDOW *menu_win; */
	
/* 	int highlight = 1; */
/* 	int choice = 0; */
/* 	int c; */
/* 	int msg = 6 ; */
/* 	unsigned long ptot = 0; */

	
/* 	startx = (80 - WIDTH) / 2; */
/* 	starty = (24 - HEIGHT) / 2; */


	
	
/* 	menu_win = newwin(HEIGHT, WIDTH, starty, startx); */
/* 	keypad(menu_win, TRUE); */
/* 	mvprintw(0, 0, "Use arrow keys to go up and down, Press enter to select a choice"); */
/* 	refresh(); */
/* 	print_menu(menu_win, highlight); */
	
/* 	while(1) */
/* 	{ */
/* 	  tick ++; */
/* 	  mvprintw(5, 5, " ticker = %ul \n", tick); */
/* 	  refresh(); */
	  
/* 	  //c = wgetch(menu_win); */
/* 	  c = wgetch(w); */
		    
/* 		switch(c) */
/* 		{ */

		  
/* 		case KEY_UP: */
		    
/* 		  msg++; */
/* 		  mvprintw(msg,0 , "key up pressed ....\n"); */
/* 		  refresh(); */
/* 				if(highlight == 1) */
/* 					highlight = n_choices; */
/* 				else */
/* 					--highlight; */
/* 				break; */
/* 			case KEY_DOWN: */
/* 				if(highlight == n_choices) */
/* 					highlight = 1; */
/* 				else  */
/* 					++highlight; */
/* 				break; */
/* 			case 10: */
/* 				choice = highlight; */
/* 				break; */

/* 		case 'p': */
/* 		  ptot++; */
/* 		  mvprintw(1, 30, "p total = %u ", ptot); */
		  
/* 		  break; */
				
/* 		case -1: */
/* 		  // no key */
/* 		  break; */
/* 			default: */
			  
/* 				mvprintw(24, 0, "Charcter pressed is = %3d Hopefully it can be printed as '%c'", c, c); */
/* 				refresh(); */
/* 				break; */
/* 		} */
/* 		//print_menu(menu_win, highlight); */
/* 		if(choice != 0) */
/* 		  // User did a choice come out of the infinite loop  */
/* 			break; */
/* 	}	 */
/* 	mvprintw(23, 0, "You chose choice %d with choice string %s\n", choice, choices[choice - 1]); */
/* 	clrtoeol(); */
/* 	refresh(); */
/* 	endwin(); */
/* 	return 0; */
/* } */



/* void print_menu(WINDOW *menu_win, int highlight) */
/* { */
/* 	int x, y, i;	 */

/* 	x = 2; */
/* 	y = 2; */
/* 	box(menu_win, 0, 0); */
/* 	for(i = 0; i < n_choices; ++i) */
/* 	{	if(highlight == i + 1) /\* High light the present choice *\/ */
/* 		{	wattron(menu_win, A_REVERSE);  */
/* 			mvwprintw(menu_win, y, x, "%s", choices[i]); */
/* 			wattroff(menu_win, A_REVERSE); */
/* 		} */
/* 		else */
/* 			mvwprintw(menu_win, y, x, "%s", choices[i]); */
/* 		++y; */
/* 	} */
/* 	wrefresh(menu_win); */
/* } */

