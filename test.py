import torch
x = torch.arange(-1, 1, 1e-8) # default cpu tensor
#measure CPU compute time by calling torch.erfinv

# print("CPU torch.erfinv time: ", cpu_time)

# x = x.to("mps")
# # measure MPS compute time
# time = %timeit -o -q -r 5 torch.erfinv(x)
# mps_time = time.average
# print("MPS torch.erfinv time: ", mps_time)
# print(f"MPS torch.erfinv is {cpu_time/mps_time*100} percent faster than CPU torch.erfinv")

# compute MSE between MPS and CPU torch.erfinv
x = x.to("cpu")
y_cpu = torch.erfinv(x)
x = x.to("mps")
y_mps = torch.erfinv(x)
y_mps = y_mps.to("cpu")
mask = torch.isfinite(y_cpu) & torch.isfinite(y_mps.to("cpu"))
y_mps = y_mps[mask]
y_cpu = y_cpu[mask]
x = x[mask]
print(f"length of y_mps: {len(y_mps)}, length of y_cpu: {len(y_cpu)}, length of x: {len(x)}")
mse = torch.square(y_cpu - y_mps).mean()
print("MSE between MPS and CPU torch.erfinv: ", mse)
diff = torch.abs(y_cpu - y_mps)
print("Largest difference")
print(f"x:  {x[torch.argmax(diff)]}, y_cpu: {y_cpu[torch.argmax(diff)]}, y_mps: {y_mps[torch.argmax(diff)]} , diff = {y_cpu[torch.argmax(diff)] - y_mps[torch.argmax(diff)]}")

