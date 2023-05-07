#import <Metal/Metal.h>
#include <iostream>
#include <vector>

int main(int argc, const char *argv[]) {
  // Data size and input data
  const int dataSize = 5;
  float inputData[dataSize] = {0.999, 0.5, 0.0, -0.3, -0.999};

  // Get the default Metal device
  id<MTLDevice> device = MTLCreateSystemDefaultDevice();

  // Compile the Metal shader
  NSError *error;
  NSString *shaderPath = [[NSBundle mainBundle] pathForResource:@"erfinv"
                                                         ofType:@"metallib"];
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
  float *outputData = static_cast<float *>(outputBuffer.contents);

  // Print the results
  std::cout << "Input values: ";
  for (int i = 0; i < dataSize; i++) {
    std::cout << inputData[i] << " ";
  }
  std::cout << std::endl;

  std::cout << "Inverse error function results: ";
  for (int i = 0; i < dataSize; i++) {
    std::cout << outputData[i] << " ";
  }
  std::cout << std::endl;

  return 0;
}