#include <assert.h>
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>

struct time {
  int hours;
  int minutes;
};

struct time convert_to_time(int time_in_min) {
  struct time t = {0};
  t.hours = time_in_min / 60;
  t.minutes = time_in_min % 60;
  return t;
};

int calculte_distraction_time(const char *start_time_str,
                              const char *end_time_str) {
  struct time start_time = {0};
  sscanf(start_time_str, "%d:%d", &start_time.hours, &start_time.minutes);
  struct time end_time = {0};
  sscanf(end_time_str, "%d:%d", &end_time.hours, &end_time.minutes);
  int hour_diff = end_time.hours - start_time.hours;
  int hour_diff_min = hour_diff * 60;
  int min_diff = end_time.minutes - start_time.minutes;
  int total_time_min = hour_diff_min + min_diff;
  return total_time_min;
};

int calculate_total_time_min(const char *start_time_str,
                             const char *end_time_str) {
  struct time start_time = {0};
  sscanf(start_time_str, "%d:%d", &start_time.hours, &start_time.minutes);
  struct time end_time = {0};
  sscanf(end_time_str, "%d:%d", &end_time.hours, &end_time.minutes);
  assert(end_time.hours <= 12);
  int hour_diff = (end_time.hours + 12) - start_time.hours;
  int hour_diff_min = hour_diff * 60;
  int min_diff = end_time.minutes - start_time.minutes;
  int total_time_min = hour_diff_min + min_diff;
  return total_time_min;
};

int calculate_distraction_from_list(const char *distraction_list) {
  int comma_amount = 0;
  char c = ' ';
  for (int i = 0; c != '\0'; i++) {
    c = distraction_list[i];
    if (c == ',')
      comma_amount++;
  }
  // Now add all of them up
  int total_distraction = 0;
  int index = -1;
  for (int i = 0; i <= comma_amount; i++) {
    c = ' ';
    char buffer[32] = {0};
    for (int j = 0;; j++) {
      index++;
      c = distraction_list[index];
      if (c == '\0' || c == ',')
        break;
      assert(isdigit(c));
      buffer[j] = c;
    }
    int amount = atoi(buffer);
    total_distraction += amount;
  }
  return total_distraction;
};

int main(int argc, char *argv[]) {
  if (argc == 3) {
    int distraction_min = calculte_distraction_time(argv[1], argv[2]);
    struct time distraction = convert_to_time(distraction_min);
    printf("Distraction Time: %d min, %d:%d hrs\n", distraction_min,
           distraction.hours, distraction.minutes);
    return 0;
  }
  assert(argc == 4);
  int total_time_min = calculate_total_time_min(argv[1], argv[2]);
  struct time total_time = convert_to_time(total_time_min);
  printf("Total Time: %d min, %d:%d hrs\n", total_time_min, total_time.hours,
         total_time.minutes);
  int distraction_min = calculate_distraction_from_list(argv[3]);
  struct time distraction = convert_to_time(distraction_min);
  printf("Distraction: %d mins, %d:%d hrs\n", distraction_min,
         distraction.hours, distraction.minutes);
  int focus_min = total_time_min - distraction_min;
  struct time focus = convert_to_time(focus_min);
  printf("Focus: %d mins, %d:%d hrs\n", focus_min, focus.hours, focus.minutes);
  return 0;
}
