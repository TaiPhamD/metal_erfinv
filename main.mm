#import <Metal/Metal.h>
#include <iostream>
#include <vector>

// C-style function to compute the inverse error function using Metal
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
  [computeEncoder setBuffer:inputBuffer offset:0 atIndex:0];
  [computeEncoder setBuffer:outputBuffer offset:0 atIndex:1];
  [computeEncoder setBytes:&dataSize length:sizeof(uint) atIndex:2];
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