/*  Program.c  */
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <unistd.h>     /* 提供 ftruncate  */

int main(int argc, char *argv[]) {
	/* -------- 参数检查 -------- */
	if (argc != 2) {
		fprintf(stderr, "Usage: %s <Filename>\n", argv[0]);
		return 1;
	}

	/* -------- 打开文件 -------- */
	FILE *fp = fopen(argv[1], "rb+");
	if (!fp) {
		perror("fopen");
		return 2;
	}

	uint8_t buf[4];
	long    endc_pos = -1;          /* 记录 "ENDC" 的起始位置 */

	/* -------- 4 字节为单位扫描 -------- */
	while (1) {
		long pos = ftell(fp);
		size_t n = fread(buf, 1, 4, fp);
		if (n != 4)
			break;          /* 文件剩余不足 4 字节 */

		/* 小端机器上 0x45 4E 44 43 就是 "ENDC" */
		if (memcmp(buf, "ENDC", 4) == 0) {
			endc_pos = pos;
			break;
		}
	}

	/* -------- 未找到 ENDC -------- */
	if (endc_pos == -1) {
		fprintf(stderr, "ENDC marker not found\n");
		fclose(fp);
		return 3;
	}

	/* -------- 检查 ENDC 之后是否全为 0 -------- */
	int ch;
	int all_zero = 1;
	while ((ch = fgetc(fp)) != EOF) {
		if (ch != 0) {
			all_zero = 0;
			break;
		}
	}

	if (!all_zero) {
		fprintf(stderr, "Bytes after ENDC are not all zero\n");
		fclose(fp);
		return 4;
	}

	/* -------- 截断文件 -------- */
	if (ftruncate(fileno(fp), endc_pos + 4) != 0) {
		perror("ftruncate");
		fclose(fp);
		return 5;
	}

	fclose(fp);
	return 0;   /* 成功 */
}