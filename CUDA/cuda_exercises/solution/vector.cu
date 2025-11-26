#include <iostream>
#include <cuda_runtime.h>

// GPU Kernel: Each thread processes one element
__global__ void vectorAddGPU(float *a, float *b, float *c, int n) {
    int i = threadIdx.x + blockIdx.x * blockDim.x;
    if (i < n) {
        c[i] = a[i] + b[i];
    }
}

int main() {
    int n = 1000000;
    size_t bytes = n * sizeof(float);

    // 1. Allocate host memory
    float *h_a = (float*)malloc(bytes);
    float *h_b = (float*)malloc(bytes);
    float *h_c = (float*)malloc(bytes);

    // 2. Initialize data
    for (int i = 0; i < n; i++) {
        h_a[i] = i;
        h_b[i] = i * 2;
    }

    // 3. Allocate device memory
    float *d_a, *d_b, *d_c;
    cudaMalloc(&d_a, bytes);
    cudaMalloc(&d_b, bytes);
    cudaMalloc(&d_c, bytes);

    // 4. Copy data to device
    cudaMemcpy(d_a, h_a, bytes, cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, h_b, bytes, cudaMemcpyHostToDevice);

    // 5. Configure and launch kernel
    int blockSize = 256;
    int gridSize = (n + blockSize - 1) / blockSize;  // ceil(n/blockSize)

    vectorAddGPU<<<gridSize, blockSize>>>(d_a, d_b, d_c, n);

    // Wait for GPU to finish
    cudaDeviceSynchronize();

    // 6. Copy results back to host
    cudaMemcpy(h_c, d_c, bytes, cudaMemcpyDeviceToHost);

    // 7. Verify results
    bool correct = true;
    for (int i = 0; i < 5; i++) {
        std::cout << "h_c[" << i << "] = " << h_c[i] << std::endl;
    }

    for (int i = 0; i < n; i++) {
        if (h_c[i] != h_a[i] + h_b[i]) {
            correct = false;
            break;
        }
    }

    std::cout << (correct ? "Result is CORRECT\n" : "Result is WRONG\n");

    // 8. Free memory
    free(h_a);
    free(h_b);
    free(h_c);

    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_c);

    return 0;
}

