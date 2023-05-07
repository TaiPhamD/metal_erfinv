#include <metal_stdlib>
using namespace metal;
constant constexpr float M_PI = 3.14159265358979323846264338327950288;
float erfinv(float x) {
  float a = 0.147;
  float x_squared = x * x;
  float log_term = log(1.0 - x_squared);

  float term = sqrt(sqrt((2.0 / (M_PI * a) + log_term / 2.0) *
                             (2.0 / (M_PI * a) + log_term / 2.0) -
                         log_term / a) -
                    (2.0 / (M_PI * a) + log_term / 2.0));

  float sign = x > 0.0 ? 1.0 : -1.0;
  return sign * term;
}

kernel void compute_erfinv(device float *input, device float *output,
                           uint index [[thread_position_in_grid]]) {

  output[index] = erfinv(input[index]);
}