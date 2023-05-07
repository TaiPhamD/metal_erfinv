import ctypes
import numpy as np
import os
import torch

# Load the shared library
lib = ctypes.CDLL("./build/libmetal_erfinv.dylib")
shader_path = os.path.abspath("./build/erfinv.metallib")

# Define input and output arrays
input_data = np.array([0.999, 0.5, 0.0, -0.3, -0.999], dtype=np.float32)
output_data = np.empty_like(input_data)

# Call the compute_erfinv function from the shared library
lib.compute_erfinv(
    input_data.ctypes.data_as(ctypes.POINTER(ctypes.c_float)),
    output_data.ctypes.data_as(ctypes.POINTER(ctypes.c_float)),
    len(input_data),
    shader_path.encode("utf-8"),
)
# Print the results
print("erfinv from metal: ", output_data)

# Compare with torch.erfinv
print("erfinv from torch: ", torch.erfinv(torch.from_numpy(input_data)))

# calculate mse
print(
    "erfinv result MSE (metal.erfinv vs torch.erfinv): ",
    np.square(output_data - torch.erfinv(torch.from_numpy(input_data))).mean(),
)
