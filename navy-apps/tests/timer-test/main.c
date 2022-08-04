#include <unistd.h>
#include <stdio.h>
#include <sys/time.h>

int main() {
  struct timeval tv;
  __uint64_t last, now;
  int i;
  gettimeofday(&tv, NULL);
  now = tv.tv_sec * 1000 + tv.tv_usec / 1000;
  last = now;
  while (1) {
    printf("now:%d\n", now);
    gettimeofday(&tv, NULL);
    now = tv.tv_sec * 1000 + tv.tv_usec / 1000;
    if (now - last >= 1000) {
      last = now;
      printf("timer-test:%d\n", i);
    }
  }
  return 0;

}
