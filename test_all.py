 python3 test/test_mps.py TestConsistencyCPU.test_output_match_grid_sampler_2d_cpu_float32
 python3 test/test_mps.py TestConsistencyCPU.test_output_grad_match_erfinv_cpu_float32
 python test/test_mps.py TestNLLLoss.test_unary_ops
 
667* python3 test/test_mps.py TestConsistencyCPU.test_output_match_grid_sampler_2d_cpu_float32
 8669* python3 test/test_mps.py TestConsistencyCPU.test_output_match_grid_sampler_2d_cpu_float32
 8670* np test/test_mps.py
 8671* code test/test_mps.py
 8686* history | grep test
 8687* python3 test/test_mps.py TestConsistencyCPU.test_output_match_grid_sampler_2d_cpu_float32
 8728* history | grep test
 8729* python3 test/test_mps.py TestConsistencyCPU.test_output_match_grid_sampler_2d_cpu_float32
 8730* test/test_mps.py TestConsistencyCPU.test_output_grad_match_erfinv_cpu_float32
 8731* python test/test_mps.py TestConsistencyCPU.test_output_grad_match_erfinv_cpu_float32
 8732* python3 test/test_mps.py TestNLLLoss.test_unary_ops
 8736* python3 test/test_mps.py TestConsistencyCPU.test_output_match_erfinv_cpu_uint8
 8746  git add aten test
 8748  git commit -m "add erfinv uint8 into expected fail test for macos 12.3. Update comments"
 8752  history | grep test
 8753  python test/test_mps.py TestConsistencyCPU.test_output_grad_match_erfinv_cpu_float32
 8756  python test/test_mps.py TestConsistencyCPU.test_output_grad_match_erfinv_cpu_float32
 8782  history | grep test
 8783  python3 test/test_mps.py TestConsistencyCPU.test_output_grad_match_erfinv_cpu_float32
 8784  python3 test/test_mps.py TestConsistencyCPU.test_output_match_erfinv_cpu_uint8
 8785  python test/test_mps.py TestNLLLoss.test_unary_ops