import torch
x = torch.Tensor([[[ 0.5, 1,  2.],
         [ 3.,  .5,  5.],
         [ 6.,  -.5,  8.]],

        [[ 9., 0, 11.],
         [12., 1, 14.],
         [15., -1.2, 17.]]]).to('mps')
y = x.permute(1, 0, 2)[..., 1]
print(x)
print(y)

y1 = torch.erfinv(y)
print(y1)


y2 = torch.erfinv(x)
print(y2)