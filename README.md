# conv_accelerator
**A pipeline accelerator for convolultion neural network based on systolic array**
**Using valid-ready handshake protocol to perform correct communication between pipeline stages.**
## Input
28*28 input image
## im2col
Input image Packed into 26 grouops, each with size of 26*9
## conv layer
Each group flows into matu and gemm with conv weights, conv_output with size of 1*26
### matu
-Input Buffer

-Output Buffer

-Controller

-systolic array
## fc layer
Each group flows into matu and gemm with fc weight, fc_output with size of 1*10
## acc
26 groups accumulate and get the final result


