/******************************************************************************
*
*  Authors:   Chengyi Zhang
*     Date:   2023/4/20
*   Method:   
*  Version:   
*  Content:  
* 
******************************************************************************/

#include <stdio.h>
#include <stdlib.h>

#define IMG_SIZE 28
#define CONV_KERNEL_SIZE 3
#define CONV_STRIDE 1
#define CONV_OUTPUT_SIZE (IMG_SIZE - CONV_KERNEL_SIZE + 1) * (IMG_SIZE - CONV_KERNEL_SIZE + 1)
#define FC_INPUT_SIZE (IMG_SIZE - CONV_KERNEL_SIZE + 1) * (IMG_SIZE - CONV_KERNEL_SIZE + 1)
#define FC_OUTPUT_SIZE 10

// 输入图像
int input[IMG_SIZE][IMG_SIZE];

// 卷积层权重
__uint8_t conv_weights[CONV_KERNEL_SIZE][CONV_KERNEL_SIZE];

// 卷积层偏置
int conv_bias = 1;

// 全连接层权重
__uint8_t fc_weights[FC_OUTPUT_SIZE][FC_INPUT_SIZE];

void conv_layer(int input[IMG_SIZE][IMG_SIZE], int output[CONV_OUTPUT_SIZE]) {
    int idx = 0;
    for (int i = 0; i < IMG_SIZE - CONV_KERNEL_SIZE + 1; i++) {
        for (int j = 0; j < IMG_SIZE - CONV_KERNEL_SIZE + 1; j++) {
            int sum = conv_bias;
            for (int k = 0; k < CONV_KERNEL_SIZE; k++) {
                for (int l = 0; l < CONV_KERNEL_SIZE; l++) {
                    sum += (__uint32_t) input[i + k][j + l] * conv_weights[k][l];
                }
            }
            output[idx++] = sum;
            printf("Conv output[%d]: %x\n", idx-1, output[idx-1]);
        }
    }
}

void fc_layer(int input[FC_INPUT_SIZE], int output[FC_OUTPUT_SIZE]) {
    for (int i = 0; i < FC_OUTPUT_SIZE; i++) {
        int sum = 0;
        for (int j = 0; j < FC_INPUT_SIZE; j++) {
            sum += (__uint32_t)  input[j] * fc_weights[i][j];
            if ((j + 1) % 26 == 0) {
                printf("FC output[%d]: %x\n", i, sum);
            }
        }
        output[i] = sum;
    }
}

int main() {
    // 设置输入图像
    for (int i = 0; i < 28; i++) {
        for (int j = 0; j < 28; j++) {
            input[i][j] = j;
        }
    }

    // 设置卷积层权重
    for (int i = 0; i < 1; i++) {
        for (int j = 0; j < 9; j++) {
            conv_weights[i][j] = i + j;
        }
    }

    // 设置全连接层权重
    for (int i = 0; i < 10; i++) {
        for (int j = 0; j < 676; j++) {
            fc_weights[i][j] = j + 1;
        }
    }

    int conv_output[CONV_OUTPUT_SIZE];
    int fc_output[FC_OUTPUT_SIZE];

    // 卷积层
    conv_layer(input, conv_output);

    // 全连接层
    fc_layer(conv_output, fc_output);

    // 输出结果
    for (int i = 0; i < FC_OUTPUT_SIZE; i++) {
        printf("Output %d: %x\n", i, fc_output[i]);
    }

    return 0;
}