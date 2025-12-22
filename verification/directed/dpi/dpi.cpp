//==============================================================================
// [Filename]     dpi.cpp
// [Project]      -
// [Author]       Ciro Bermudez - cirofabian.bermudez@gmail.com
// [Language]     C++
// [Created]      Dec 2025
// [Modified]     -
// [Description]  DPI (Direct Programming Interface) entry point
// [Notes]        -
// [Status]       stable
// [Revisions]    -
//==============================================================================

#include <iostream>
#include <cstdio>
#include <svdpi.h>

double f(double t, double y) {
  return t*y;
}

double euler_step(double tn, double yn, double h) {
  return yn + h * f(tn, yn);
}

extern "C" int ref_model(double a) {
  double h = 0.2;
  double y0 = 1.0;
  
  printf("[C++]  t      y\n");
  for (double t = 0.0; t <= 1.0; t += h) {
    printf("[C++] %5.2f, %5.2f\n", t, y0);
    y0 = euler_step(t, y0, h);
  }

  return 0;
}
