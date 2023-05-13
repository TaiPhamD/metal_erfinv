import torch
x = torch.tensor([1 ,0.5, 0.3, 0.2, -0.1, -0.45, .880, .880, -1], dtype=torch.float32)
y_mps = torch.erfinv(x.to("mps"))
y_cpu = torch.erfinv(x.to("cpu"))
print(y_mps)
print(y_cpu)
print(y_mps.dtype)