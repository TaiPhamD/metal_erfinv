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

float evaluate_polynomial(constant const float *coefficients, int x, int count) {
  // Horner's implementation
  float result = coefficients[count-1];
  for (int i = count - 2; i >= 0; --i) {
    result = result * x + coefficients[i];
  }
}

kernel void compute_erfinv( device float *output [[buffer(0)]],
                               device float  *input [[buffer(1)]],
                               constant Uniforms& uniforms [[buffer(2)]],
                          uint index [[thread_position_in_grid]])  {

  float y = input[index];
  float y_abs = abs(y);
  if(y_abs > 1.0f) {
    output[index] = NAN;
    return;
  } 
  if(y_abs == 1.0f) {
    output[index] = copysign(INFINITY, y);
    return;
  }
  if(y_abs == 0.0f){
    output[index] = copysign(0.0f, y);
    return;
  }

  float p, q, s;
   if(y < 0)
   {
      p = -y;
      q = 1 - p;
      s = -1;
   }
   else
   {
      p = y;
      q = 1 - p;
      s = 1;
   }
  float Y, g, r, xs, x, R, result;
   if( p <= 0.5 ){
    Y = uniforms.Y1;
    g= p *(p+10);
    r = evaluate_polynomial(uniforms.P1, p, 8) / evaluate_polynomial(uniforms.Q1, p, 10);
    result = g * Y + g * r;
   }
   else if (q >= 0.25){
    Y = uniforms.Y2;
    float g  = sqrt(-2.0 * log(q));
    xs = q - 0.25;
    r = evaluate_polynomial(uniforms.P2, xs, 9) / evaluate_polynomial(uniforms.Q2, xs, 9);
    result = g/ (Y +r);
   } else {
    x = sqrt(-log(q));
    if (x < 3){
      Y = uniforms.Y3;
      xs = x - 1.125;
      R = evaluate_polynomial(uniforms.P3, xs, 11) / evaluate_polynomial(uniforms.Q3, xs, 8);
      result = Y * x + R * x;
    }
    else if ( x < 6){
      Y = uniforms.Y4;
      xs = x - 3.0;
      R = evaluate_polynomial(uniforms.P4, xs, 9) / evaluate_polynomial(uniforms.Q4, xs, 7);
      result = Y * x + R * x;
    }
    else if (x < 18){
      Y = uniforms.Y5;
      xs = x - 6.0;
      R = evaluate_polynomial(uniforms.P5, xs, 9) / evaluate_polynomial(uniforms.Q5, xs, 7);
      result = Y * x + R * x;
    }
    else if (x < 44){
      Y = uniforms.Y6;
      xs = x - 18.0;
      R = evaluate_polynomial(uniforms.P6, xs, 8) / evaluate_polynomial(uniforms.Q6, xs, 7);
      result = Y * x + R * x;
    } else {
      Y = uniforms.Y7;
      xs = x - 44.0;
      R = evaluate_polynomial(uniforms.P7, xs, 8) / evaluate_polynomial(uniforms.Q7, xs, 7);
      result = Y * x + R * x;
    }
   }
  output[index] = s * result; 
};