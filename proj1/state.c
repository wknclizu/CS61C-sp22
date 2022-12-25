#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "snake_utils.h"
#include "state.h"

/* Helper function definitions */
static char get_board_at(game_state_t* state, int x, int y);
static void set_board_at(game_state_t* state, int x, int y, char ch);
static bool is_tail(char c);
static bool is_snake(char c);
static char body_to_tail(char c);
static int incr_x(char c);
static int incr_y(char c);
static void find_head(game_state_t* state, int snum);
static char next_square(game_state_t* state, int snum);
static void update_tail(game_state_t* state, int snum);
static void update_head(game_state_t* state, int snum);

/* Helper function to get a character from the board (already implemented for you). */
static char get_board_at(game_state_t* state, int x, int y) {
  return state->board[y][x];
}

/* Helper function to set a character on the board (already implemented for you). */
static void set_board_at(game_state_t* state, int x, int y, char ch) {
  state->board[y][x] = ch;
}

static void print(game_state_t* now) {
  int i, j;
  printf("check board\n");
  for (i = 0; i < now->y_size; i++) {
    for (j = 0; j < now->x_size; j++)
      printf("%c", now->board[i][j]);
    printf("\n");
  }
  printf("\n");
}

/* Task 1 */
game_state_t* create_default_state() {
  int i, j;
  game_state_t *now = (game_state_t *) malloc(sizeof(game_state_t));

  if (now == NULL) {
    printf("Create state error\n");
    exit(0);
  }

  now->x_size = 14, now->y_size = 10;
  unsigned int wid = now->x_size;
  unsigned int hei = now->y_size;
  now->board = (char **) malloc(sizeof(char *) * hei);

  if (!now->board) {
    printf("Create board error\n");
    exit(0);
  }

  for (i = 0; i < now->y_size; i++) {
    now->board[i] = (char *) malloc(sizeof(char) * wid);
  }
  for (i = 0; i < hei; i++) {
    for (j = 0; j < wid; j++) {
      if (i == 0 || i == hei - 1 || j == 0 || j == wid - 1)
        now->board[i][j] = '#';
      else now->board[i][j] = ' ';
    }
  }

  now->num_snakes = 1;
  now->snakes = (snake_t *) malloc(sizeof(snake_t) * now->num_snakes);
  now->snakes->live = true;
  set_board_at(now, 4, 4, 'd');
  set_board_at(now, 5, 4, '>');
  set_board_at(now, 9, 2, '*');
  now->snakes->tail_x = 4;
  now->snakes->tail_y = 4;
  now->snakes->head_x = 5;
  now->snakes->head_y = 4;
  // print(now);

  return now;
}

/* Task 2 */
void free_state(game_state_t* state) {
  int i;

  for (i = 0; i < state->y_size; i++)
    free(state->board[i]);
  free(state->board);
  free(state->snakes);
  free(state);

  return;
}

/* Task 3 */
void print_board(game_state_t* state, FILE* fp) {
  int i, j;
  for (i = 0; i < state->y_size; i++) {
    for (j = 0; j < state->x_size; j++)
      fprintf(fp, "%c", state->board[i][j]);
    fprintf(fp, "\n");
  }
  return;
}

/* Saves the current state into filename (already implemented for you). */
void save_board(game_state_t* state, char* filename) {
  FILE* f = fopen(filename, "w");
  print_board(state, f);
  fclose(f);
}

/* Task 4.1 */
static bool is_tail(char c) {
  if (c == 'w' || c == 'a' || c == 's' || c == 'd')
    return true;
  return false;
}

static bool is_snake(char c) {
  if (is_tail(c)) return true;
  if (c == '^' || c == '<' || c == '>' || c == 'v')
    return true;
  if (c == 'x')
    return true;
  return false;
}

static char body_to_tail(char c) {
  switch(c) {
    case('^'): return 'w';
    case('<'): return 'a';
    case('>'): return 'd';
    case('v'): return 's';
  }
  return ' ';
}

static int incr_x(char c) {
  if (c == '>' || c == 'd')
    return 1;
  if (c == '<' || c == 'a')
    return -1;
  return 0;
}

static int incr_y(char c) {
  if (c == 'v' || c == 's')
    return 1;
  if (c == '^' || c == 'w')
    return -1;
  return 0;
}

/* Task 4.2 */
static char next_square(game_state_t* state, int snum) {
  int x = state->snakes[snum].head_x,
      y = state->snakes[snum].head_y,
      dir;

  dir = incr_x(state->board[y][x]);
  if (dir) {
    return state->board[y][x + dir];
  }
  dir = incr_y(state->board[y][x]);
  return state->board[y + dir][x];
}

/* Task 4.3 */
static void update_head(game_state_t* state, int snum) {
  int x = state->snakes[snum].head_x,
      y = state->snakes[snum].head_y,
      dir1, dir2;
  char ch = state->board[y][x];

  dir1 = incr_y(state->board[y][x]);
  dir2 = incr_x(state->board[y][x]);
  state->board[y + dir1][x + dir2] = ch;
  state->snakes[snum].head_y = y + dir1;
  state->snakes[snum].head_x = x + dir2;

  return;
}

/* Task 4.4 */
static void update_tail(game_state_t* state, int snum) {
  // print(state);
  int x = state->snakes[snum].tail_x,
      y = state->snakes[snum].tail_y,
      dir1, dir2;

  dir1 = incr_y(state->board[y][x]);
  dir2 = incr_x(state->board[y][x]);

  state->board[y][x] = ' ';
  state->board[y + dir1][x + dir2] = 
      body_to_tail(state->board[y + dir1][x + dir2]);
  state->snakes[snum].tail_y = y + dir1;
  state->snakes[snum].tail_x = x + dir2;

  // print(state);
  return;
}

/* Task 4.5 */
void update_state(game_state_t* state, int (*add_food)(game_state_t* state)) {
  int i, x, y;
  for (i = 0; i < state->num_snakes; i++) {
    if (!state->snakes[i].live) continue;
    char nx = next_square(state, i);

    if (nx == '*') {
      update_head(state, i);
      add_food(state);
    } else if (nx == ' ') {
      update_head(state, i);
      update_tail(state, i);
    } else {
      x = state->snakes[i].head_x, y = state->snakes[i].head_y;
      state->board[y][x] = 'x';
      state->snakes[i].live = false;
    }
  }
  return;
}

/* Task 5 */
game_state_t* load_board(char* filename) {
  int len, i, cnt, j;
  FILE *fp = fopen(filename, "r");
  game_state_t* now = (game_state_t *) malloc(sizeof(game_state_t));

  fseek(fp, 0, SEEK_END);
  len = ftell(fp);
  rewind(fp);

  char *mp = (char *) malloc(sizeof(char) * len);
  fread(mp, len, sizeof(char), fp);
  fclose(fp);
  // printf("%s", mp);

  for (i = 0; i < len; i++) {
    if (mp[i] == '\n') {
      now->x_size = i;
      break;
    }
  }
  now->y_size = len / (now->x_size + 1);
  // now->y_size = 0;
  // for (i = 0; i < len; i++) {
  //   if (mp[i] == '\n') {
  //     now->y_size++;
  //   }
  // }
  // printf("check size: %d %d\n", now->x_size, now->y_size);

  now->board = (char **) malloc(sizeof(char *) * now->y_size);
  cnt = 0;

  for (i = 0; i < now->y_size; i++) {
    now->board[i] = (char *) malloc(sizeof(char) * now->x_size);

    for (j = 0; j < now->x_size; j++) {
      while (mp[cnt] == '\n') {
        cnt++;
      }
      now->board[i][j] = mp[cnt];
      cnt++;
    }
  }
  free(mp);

  return now;
}

void dfs(game_state_t* state, snake_t* s, int x, int y, int prex, int prey) {
  char ch = state->board[y][x];
  if (!is_snake(ch)) {
    (*s).head_x = prex;
    (*s).head_y = prey;
    return;
  }
  dfs(state, s, x + incr_x(ch), y + incr_y(ch), x, y);
}

/* Task 6.1 */
static void find_head(game_state_t* state, int snum) {
  dfs(state, &state->snakes[snum],
      state->snakes[snum].tail_x, state->snakes[snum].tail_y, 0, 0);
}

/* Task 6.2 */
game_state_t* initialize_snakes(game_state_t* state) {
  int i, j, cnt = 0;
  int wid = state->x_size, hei = state->y_size;
  char ch;

  state->snakes = (snake_t *) malloc(sizeof(snake_t));
  for (i = 0; i < hei; i++) {
    for (j = 0; j < wid; j++) {
      ch = state->board[i][j];
      if (is_tail(ch)) {
        state->snakes = (snake_t *) realloc(state->snakes, sizeof(snake_t) * (cnt + 1));
        state->snakes[cnt].tail_x = j;
        state->snakes[cnt].tail_y = i;
        state->snakes[cnt].live = true;
        find_head(state, cnt);
        cnt++;
      }
    }
  }
  state->num_snakes = cnt;
  
  return state;
}
