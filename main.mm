#import <Metal/Metal.h>
#include <iostream>
#include <vector>

// C-style function to compute the inverse error function using Metal
struct Uniforms {
  float a[4] = {0.886226899f, -1.645349621f, 0.914624893f, -0.140543331f};
  float b[4] = {-2.118377725f, 1.442710462f, -0.329097515f, 0.012229801f};
  float c[4] = {-1.970840454f, -1.624906493f, 3.429567803f, 1.641345311f};
  float d[2] = {3.543889200f, 1.637067800f};
};

extern "C" void compute_erfinv(const float *inputData, float *outputData,
                               int dataSize, const char *shader_path) {

  // Get the default Metal device
  id<MTLDevice> device = MTLCreateSystemDefaultDevice();

  // Compile the Metal shader
  NSError *error;
  NSString *shaderPath = [NSString stringWithUTF8String:shader_path];
  id<MTLLibrary> library = [device newLibraryWithFile:shaderPath error:&error];
  id<MTLFunction> kernelFunction =
      [library newFunctionWithName:@"compute_erfinv"];

  // Create a compute pipeline state
  id<MTLComputePipelineState> pipelineState =
      [device newComputePipelineStateWithFunction:kernelFunction error:&error];

  // Create a command queue
  id<MTLCommandQueue> commandQueue = [device newCommandQueue];

  // Create input and output buffers
  id<MTLBuffer> inputBuffer =
      [device newBufferWithBytes:inputData
                          length:dataSize * sizeof(float)
                         options:MTLResourceStorageModeShared];
  id<MTLBuffer> outputBuffer =
      [device newBufferWithLength:dataSize * sizeof(float)
                          options:MTLResourceStorageModeShared];

  // Create a command buffer
  id<MTLCommandBuffer> commandBuffer = [commandQueue commandBuffer];

  // Create a compute command encoder
  id<MTLComputeCommandEncoder> computeEncoder =
      [commandBuffer computeCommandEncoder];
  [computeEncoder setComputePipelineState:pipelineState];

  // Set the input and output buffers
//   struct Uniforms uniforms = {
//     .a = { 0.886226899f, -1.645349621f,  0.914624893f, -0.140543331f },
//     .b = { -2.118377725f,  1.442710462f, -0.329097515f,  0.012229801f },
//     .c = { -1.970840454f, -1.624906493f,  3.429567803f,  1.641345311f },
//     .d = { 3.543889200f,   1.637067800f }
//   };
  struct Uniforms uniforms;
  id<MTLBuffer> constantBuffer = [device newBufferWithLength:sizeof(Uniforms) options:MTLResourceOptionCPUCacheModeDefault];
  memcpy([constantBuffer contents], &uniforms, sizeof(Uniforms));
  [computeEncoder setBuffer:outputBuffer offset:0 atIndex:0];
  [computeEncoder setBuffer:inputBuffer offset:0 atIndex:1];
  [computeEncoder setBuffer:constantBuffer offset:0 atIndex:2];
  //[computeEncoder setBytes:&dataSize length:sizeof(uint) atIndex:3];
  // Dispatch the kernel
  MTLSize threadsPerGroup = MTLSizeMake(1, 1, 1);
  MTLSize numGroups = MTLSizeMake(dataSize, 1, 1);
  [computeEncoder dispatchThreadgroups:numGroups
                 threadsPerThreadgroup:threadsPerGroup];
  // End encoding and commit the command buffer
  [computeEncoder endEncoding];
  [commandBuffer commit];
  // Wait for the GPU to finish and get the output data
  [commandBuffer waitUntilCompleted];
  //*outputData = static_cast<float *>(outputBuffer.contents);
  memcpy(outputData, outputBuffer.contents, dataSize * sizeof(float));
}