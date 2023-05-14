#include <metal_stdlib>
using namespace metal;

struct Uniforms {
  float Y1;
  float P1[8];
  float Q1[10];
  float Y2;
  float P2[9];
  float Q2[9];
  float Y3;
  float P3[11];
  float Q3[8];
  float Y4;
  float P4[9];
  float Q4[7];
  float Y5;
  float P5[9];
  float Q5[7];
  float Y6;
  float P6[8];
  float Q6[7];
  float Y7;
  float P7[8];
  float Q7[7];
};

kernel void compute_erfinv( device float *output [[buffer(0)]],
                               device float  *input [[buffer(1)]],
                               constant Uniforms& uniforms [[buffer(2)]],
                          uint index [[thread_position_in_grid]])  {


  constant const float *P1 = uniforms.P1;
  output[index] = P1[0];
};