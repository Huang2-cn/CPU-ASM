#include <stdio.h>
#include <stdlib.h>

int main(void) {
	FILE *file;
	unsigned char buf[768];          /* 256×3 */
	int i, r, g, b;
	unsigned short rgb15;

	file = fopen("palette.act", "rb");
	if (!file) {
		perror("无法打开 palette.act");
		return 1;
	}
	if (fread(buf, 1, 768, file) != 768) {
		perror("文件读取失败");
		fclose(file);
		return 1;
	}
	fclose(file);

	puts("palette_data_16bpp:");
	for (i = 0; i < 256; ++i) {
		r = buf[i * 3 + 0] >> 3;     /* 8→5 bit */
		g = buf[i * 3 + 1] >> 3;
		b = buf[i * 3 + 2] >> 3;
		rgb15 = (r << 10) | (g << 5) | b;   /* 15-bit 打包 */
		printf("    ;颜色 %02Xh:\n", i);
		printf("	dw 0%04Xh\n", rgb15);
	}
	return 0;
}