import ctypes
import numpy as np
import os
import torch

# Load the shared library
lib = ctypes.CDLL("./build/libmetal_erfinv.dylib")
shader_path = os.path.abspath("./build/erfinv.metallib")

# Define input and output arrays
x = np.array([1.1,1, 0.99999, 0.5, 0.4, 0.0, -0.1, -0.3, -0.99999, -1, -1.2], dtype=np.float32)
y_metal = np.empty_like(x)

# Call the compute_erfinv function from the shared library
lib.compute_erfinv(
    x.ctypes.data_as(ctypes.POINTER(ctypes.c_float)),
    y_metal.ctypes.data_as(ctypes.POINTER(ctypes.c_float)),
    len(x),
    shader_path.encode("utf-8"),
)
# Print the results
print("erfinv from metal: ", y_metal)

# Compare with torch.erfinv
y_torch = torch.erfinv(torch.from_numpy(x)).numpy()
print("erfinv from torch: ", y_torch)

# calculate mse
print(
    "erfinv result MSE (metal.erfinv vs torch.erfinv): ",
    np.square(y_metal - y_torch).mean(),
)
