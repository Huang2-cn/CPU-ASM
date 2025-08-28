#include <stdio.h>
#include <stdlib.h>

int main() {
    FILE *file;
    unsigned char buffer[768]; // 256 colors * 3 bytes per color
    int i;
	int temp1;
	int temp2;
	int temp3;
    // 打开ACT文件
    file = fopen("palette.act", "rb");
    if (file == NULL) {
        perror("请将文件命名为palette.act放置在同路径下");
        return 1;
    }

    // 读取颜色数据
    size_t bytesRead = fread(buffer, sizeof(unsigned char), 768, file);
    if (bytesRead < 768) {
        perror("文件读取错误");
        fclose(file);
        return 1;
    }

    // 关闭文件
    fclose(file);
	printf("section .text\npalette_data:\n");
    // 以十六进制格式打印颜色值
    for (i = 0; i < 256; i++) {
    	temp1=buffer[i * 3];
    	temp2=buffer[i * 3 + 1];
    	temp3=buffer[i * 3 + 2];
    	if(temp1==255){
    		temp1=63;
		}
		else{
			temp1=temp1/4;
		}
    	if(temp2==255){
    		temp2=63;
		}
		else{
			temp2=temp2/4;
		}
		if(temp3==255){
    		temp3=63;
		}
		else{
			temp3=temp3/4;
		}
        printf("	;颜色 %02Xh: \n	db %03Xh, %03Xh, %03Xh \n",
               i,
               temp1,
               temp2,
               temp3);
    }

    return 0;
}

