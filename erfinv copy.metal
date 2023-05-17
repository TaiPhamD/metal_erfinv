#include <metal_stdlib>
using namespace metal;

struct Uniforms {
      float Y1;= 0.0891314744949340820313f;
      float P1[8]; = {
         BOOST_MATH_BIG_CONSTANT(T, 64, -0.000508781949658280665617),
         BOOST_MATH_BIG_CONSTANT(T, 64, -0.00836874819741736770379),
         BOOST_MATH_BIG_CONSTANT(T, 64, 0.0334806625409744615033),
         BOOST_MATH_BIG_CONSTANT(T, 64, -0.0126926147662974029034),
         BOOST_MATH_BIG_CONSTANT(T, 64, -0.0365637971411762664006),
         BOOST_MATH_BIG_CONSTANT(T, 64, 0.0219878681111168899165),
         BOOST_MATH_BIG_CONSTANT(T, 64, 0.00822687874676915743155),
         BOOST_MATH_BIG_CONSTANT(T, 64, -0.00538772965071242932965)
      };
      static const T Q[] = {
         BOOST_MATH_BIG_CONSTANT(T, 64, 1.0),
         BOOST_MATH_BIG_CONSTANT(T, 64, -0.970005043303290640362),
         BOOST_MATH_BIG_CONSTANT(T, 64, -1.56574558234175846809),
         BOOST_MATH_BIG_CONSTANT(T, 64, 1.56221558398423026363),
         BOOST_MATH_BIG_CONSTANT(T, 64, 0.662328840472002992063),
         BOOST_MATH_BIG_CONSTANT(T, 64, -0.71228902341542847553),
         BOOST_MATH_BIG_CONSTANT(T, 64, -0.0527396382340099713954),
         BOOST_MATH_BIG_CONSTANT(T, 64, 0.0795283687341571680018),
         BOOST_MATH_BIG_CONSTANT(T, 64, -0.00233393759374190016776),
         BOOST_MATH_BIG_CONSTANT(T, 64, 0.000886216390456424707504)
      };
      T g = p * (p + 10);
      T r = tools::evaluate_polynomial(P, p) / tools::evaluate_polynomial(Q, p);
      result = g * Y + g * r;
   }
   else if(q >= 0.25)
   {
      //
      // Rational approximation for 0.5 > q >= 0.25
      //
      // x = sqrt(-2*log(q)) / (Y + R(q))
      //
      // Where Y is a constant, and R(q) is optimised for a low
      // absolute error compared to Y.
      //
      // double : Max error found: 7.403372e-17
      // long double : Max error found: 6.084616e-20
      // Maximum Deviation Found (error term) 4.811e-20
      //
      static const float Y = 2.249481201171875f;
      static const T P[] = {
         BOOST_MATH_BIG_CONSTANT(T, 64, -0.202433508355938759655),
         BOOST_MATH_BIG_CONSTANT(T, 64, 0.105264680699391713268),
         BOOST_MATH_BIG_CONSTANT(T, 64, 8.37050328343119927838),
         BOOST_MATH_BIG_CONSTANT(T, 64, 17.6447298408374015486),
         BOOST_MATH_BIG_CONSTANT(T, 64, -18.8510648058714251895),
         BOOST_MATH_BIG_CONSTANT(T, 64, -44.6382324441786960818),
         BOOST_MATH_BIG_CONSTANT(T, 64, 17.445385985570866523),
         BOOST_MATH_BIG_CONSTANT(T, 64, 21.1294655448340526258),
         BOOST_MATH_BIG_CONSTANT(T, 64, -3.67192254707729348546)
      };
      static const T Q[] = {
         BOOST_MATH_BIG_CONSTANT(T, 64, 1.0),
         BOOST_MATH_BIG_CONSTANT(T, 64, 6.24264124854247537712),
         BOOST_MATH_BIG_CONSTANT(T, 64, 3.9713437953343869095),
         BOOST_MATH_BIG_CONSTANT(T, 64, -28.6608180499800029974),
         BOOST_MATH_BIG_CONSTANT(T, 64, -20.1432634680485188801),
         BOOST_MATH_BIG_CONSTANT(T, 64, 48.5609213108739935468),
         BOOST_MATH_BIG_CONSTANT(T, 64, 10.8268667355460159008),
         BOOST_MATH_BIG_CONSTANT(T, 64, -22.6436933413139721736),
         BOOST_MATH_BIG_CONSTANT(T, 64, 1.72114765761200282724)
      };
      T g = sqrt(-2 * log(q));
      T xs = q - 0.25f;
      T r = tools::evaluate_polynomial(P, xs) / tools::evaluate_polynomial(Q, xs);
      result = g / (Y + r);
   }
   else
   {
      //
      // For q < 0.25 we have a series of rational approximations all
      // of the general form:
      //
      // let: x = sqrt(-log(q))
      //
      // Then the result is given by:
      //
      // x(Y+R(x-B))
      //
      // where Y is a constant, B is the lowest value of x for which
      // the approximation is valid, and R(x-B) is optimised for a low
      // absolute error compared to Y.
      //
      // Note that almost all code will really go through the first
      // or maybe second approximation.  After than we're dealing with very
      // small input values indeed: 80 and 128 bit long double's go all the
      // way down to ~ 1e-5000 so the "tail" is rather long...
      //
      T x = sqrt(-log(q));
      if(x < 3)
      {
         // Max error found: 1.089051e-20
         static const float Y = 0.807220458984375f;
         static const T P[] = {
            BOOST_MATH_BIG_CONSTANT(T, 64, -0.131102781679951906451),
            BOOST_MATH_BIG_CONSTANT(T, 64, -0.163794047193317060787),
            BOOST_MATH_BIG_CONSTANT(T, 64, 0.117030156341995252019),
            BOOST_MATH_BIG_CONSTANT(T, 64, 0.387079738972604337464),
            BOOST_MATH_BIG_CONSTANT(T, 64, 0.337785538912035898924),
            BOOST_MATH_BIG_CONSTANT(T, 64, 0.142869534408157156766),
            BOOST_MATH_BIG_CONSTANT(T, 64, 0.0290157910005329060432),
            BOOST_MATH_BIG_CONSTANT(T, 64, 0.00214558995388805277169),
            BOOST_MATH_BIG_CONSTANT(T, 64, -0.679465575181126350155e-6),
            BOOST_MATH_BIG_CONSTANT(T, 64, 0.285225331782217055858e-7),
            BOOST_MATH_BIG_CONSTANT(T, 64, -0.681149956853776992068e-9)
         };
         static const T Q[] = {
            BOOST_MATH_BIG_CONSTANT(T, 64, 1.0),
            BOOST_MATH_BIG_CONSTANT(T, 64, 3.46625407242567245975),
            BOOST_MATH_BIG_CONSTANT(T, 64, 5.38168345707006855425),
            BOOST_MATH_BIG_CONSTANT(T, 64, 4.77846592945843778382),
            BOOST_MATH_BIG_CONSTANT(T, 64, 2.59301921623620271374),
            BOOST_MATH_BIG_CONSTANT(T, 64, 0.848854343457902036425),
            BOOST_MATH_BIG_CONSTANT(T, 64, 0.152264338295331783612),
            BOOST_MATH_BIG_CONSTANT(T, 64, 0.01105924229346489121)
         };
         T xs = x - 1.125f;
         T R = tools::evaluate_polynomial(P, xs) / tools::evaluate_polynomial(Q, xs);
         result = Y * x + R * x;
      }
      else if(x < 6)
      {
         // Max error found: 8.389174e-21
         static const float Y = 0.93995571136474609375f;
         static const T P[] = {
            BOOST_MATH_BIG_CONSTANT(T, 64, -0.0350353787183177984712),
            BOOST_MATH_BIG_CONSTANT(T, 64, -0.00222426529213447927281),
            BOOST_MATH_BIG_CONSTANT(T, 64, 0.0185573306514231072324),
            BOOST_MATH_BIG_CONSTANT(T, 64, 0.00950804701325919603619),
            BOOST_MATH_BIG_CONSTANT(T, 64, 0.00187123492819559223345),
            BOOST_MATH_BIG_CONSTANT(T, 64, 0.000157544617424960554631),
            BOOST_MATH_BIG_CONSTANT(T, 64, 0.460469890584317994083e-5),
            BOOST_MATH_BIG_CONSTANT(T, 64, -0.230404776911882601748e-9),
            BOOST_MATH_BIG_CONSTANT(T, 64, 0.266339227425782031962e-11)
         };
         static const T Q[] = {
            BOOST_MATH_BIG_CONSTANT(T, 64, 1.0),
            BOOST_MATH_BIG_CONSTANT(T, 64, 1.3653349817554063097),
            BOOST_MATH_BIG_CONSTANT(T, 64, 0.762059164553623404043),
            BOOST_MATH_BIG_CONSTANT(T, 64, 0.220091105764131249824),
            BOOST_MATH_BIG_CONSTANT(T, 64, 0.0341589143670947727934),
            BOOST_MATH_BIG_CONSTANT(T, 64, 0.00263861676657015992959),
            BOOST_MATH_BIG_CONSTANT(T, 64, 0.764675292302794483503e-4)
         };
         T xs = x - 3;
         T R = tools::evaluate_polynomial(P, xs) / tools::evaluate_polynomial(Q, xs);
         result = Y * x + R * x;
      }
      else if(x < 18)
      {
         // Max error found: 1.481312e-19
         static const float Y = 0.98362827301025390625f;
         static const T P[] = {
            BOOST_MATH_BIG_CONSTANT(T, 64, -0.0167431005076633737133),
            BOOST_MATH_BIG_CONSTANT(T, 64, -0.00112951438745580278863),
            BOOST_MATH_BIG_CONSTANT(T, 64, 0.00105628862152492910091),
            BOOST_MATH_BIG_CONSTANT(T, 64, 0.000209386317487588078668),
            BOOST_MATH_BIG_CONSTANT(T, 64, 0.149624783758342370182e-4),
            BOOST_MATH_BIG_CONSTANT(T, 64, 0.449696789927706453732e-6),
            BOOST_MATH_BIG_CONSTANT(T, 64, 0.462596163522878599135e-8),
            BOOST_MATH_BIG_CONSTANT(T, 64, -0.281128735628831791805e-13),
            BOOST_MATH_BIG_CONSTANT(T, 64, 0.99055709973310326855e-16)
         };
         static const T Q[] = {
            BOOST_MATH_BIG_CONSTANT(T, 64, 1.0),
            BOOST_MATH_BIG_CONSTANT(T, 64, 0.591429344886417493481),
            BOOST_MATH_BIG_CONSTANT(T, 64, 0.138151865749083321638),
            BOOST_MATH_BIG_CONSTANT(T, 64, 0.0160746087093676504695),
            BOOST_MATH_BIG_CONSTANT(T, 64, 0.000964011807005165528527),
            BOOST_MATH_BIG_CONSTANT(T, 64, 0.275335474764726041141e-4),
            BOOST_MATH_BIG_CONSTANT(T, 64, 0.282243172016108031869e-6)
         };
         T xs = x - 6;
         T R = tools::evaluate_polynomial(P, xs) / tools::evaluate_polynomial(Q, xs);
         result = Y * x + R * x;
      }
      else if(x < 44)
      {
         // Max error found: 5.697761e-20
         static const float Y = 0.99714565277099609375f;
         static const T P[] = {
            BOOST_MATH_BIG_CONSTANT(T, 64, -0.0024978212791898131227),
            BOOST_MATH_BIG_CONSTANT(T, 64, -0.779190719229053954292e-5),
            BOOST_MATH_BIG_CONSTANT(T, 64, 0.254723037413027451751e-4),
            BOOST_MATH_BIG_CONSTANT(T, 64, 0.162397777342510920873e-5),
            BOOST_MATH_BIG_CONSTANT(T, 64, 0.396341011304801168516e-7),
            BOOST_MATH_BIG_CONSTANT(T, 64, 0.411632831190944208473e-9),
            BOOST_MATH_BIG_CONSTANT(T, 64, 0.145596286718675035587e-11),
            BOOST_MATH_BIG_CONSTANT(T, 64, -0.116765012397184275695e-17)
         };
         static const T Q[] = {
            BOOST_MATH_BIG_CONSTANT(T, 64, 1.0),
            BOOST_MATH_BIG_CONSTANT(T, 64, 0.207123112214422517181),
            BOOST_MATH_BIG_CONSTANT(T, 64, 0.0169410838120975906478),
            BOOST_MATH_BIG_CONSTANT(T, 64, 0.000690538265622684595676),
            BOOST_MATH_BIG_CONSTANT(T, 64, 0.145007359818232637924e-4),
            BOOST_MATH_BIG_CONSTANT(T, 64, 0.144437756628144157666e-6),
            BOOST_MATH_BIG_CONSTANT(T, 64, 0.509761276599778486139e-9)
         };
         T xs = x - 18;
         T R = tools::evaluate_polynomial(P, xs) / tools::evaluate_polynomial(Q, xs);
         result = Y * x + R * x;
      }
      else
      {
         // Max error found: 1.279746e-20
         static const float Y = 0.99941349029541015625f;
         static const T P[] = {
            BOOST_MATH_BIG_CONSTANT(T, 64, -0.000539042911019078575891),
            BOOST_MATH_BIG_CONSTANT(T, 64, -0.28398759004727721098e-6),
            BOOST_MATH_BIG_CONSTANT(T, 64, 0.899465114892291446442e-6),
            BOOST_MATH_BIG_CONSTANT(T, 64, 0.229345859265920864296e-7),
            BOOST_MATH_BIG_CONSTANT(T, 64, 0.225561444863500149219e-9),
            BOOST_MATH_BIG_CONSTANT(T, 64, 0.947846627503022684216e-12),
            BOOST_MATH_BIG_CONSTANT(T, 64, 0.135880130108924861008e-14),
            BOOST_MATH_BIG_CONSTANT(T, 64, -0.348890393399948882918e-21)
         };
         static const T Q[] = {
            BOOST_MATH_BIG_CONSTANT(T, 64, 1.0),
            BOOST_MATH_BIG_CONSTANT(T, 64, 0.0845746234001899436914),
            BOOST_MATH_BIG_CONSTANT(T, 64, 0.00282092984726264681981),
            BOOST_MATH_BIG_CONSTANT(T, 64, 0.468292921940894236786e-4),
            BOOST_MATH_BIG_CONSTANT(T, 64, 0.399968812193862100054e-6),
            BOOST_MATH_BIG_CONSTANT(T, 64, 0.161809290887904476097e-8),
            BOOST_MATH_BIG_CONSTANT(T, 64, 0.231558608310259605225e-11)
         };   
};

kernel void compute_erfinv( device float *output [[buffer(0)]],
                               device float  *input [[buffer(1)]],
                               constant Uniforms& uniforms [[buffer(2)]],
                          uint index [[thread_position_in_grid]])  {


  constant const float *a = uniforms.a;
  constant const float *b = uniforms.b;
  constant const float *c = uniforms.c;
  constant const float *d = uniforms.d;
  float y = input[index];
  float x, z, num, dem; /*working variables */
  /* coefficients in rational expansion */

  float y_abs = abs(y);
  if(y_abs > 1.0f){
    output[index] = NAN;
    return;
  }
  if(y_abs == 1.0f){
    output[index] = copysign(INFINITY, y);
    return;
  }
  if(y_abs <= 0.7f) {{
    z = y * y;
    num = (((a[3]*z + a[2])*z + a[1])*z + a[0]);
    dem = ((((b[3]*z + b[2])*z + b[1])*z +b[0]) * z + 1.0f);
    x = y * num / dem;
  }}
  else{
    z = sqrt(-1.0f*log((1.0-y_abs)/2.0));
    num = ((c[3]*z + c[2])*z + c[1]) * z + c[0];
    dem = (d[1]*z + d[0])*z + 1.0f;
    x = copysign(num, y) / dem;
  }

  // 2 round newton - erf(x)
  //

  output[index] = x;
}