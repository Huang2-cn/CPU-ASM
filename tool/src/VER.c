#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

int main(int argc, char *argv[]) {
	const char *path = (argc > 1) ? argv[1] : ".\\src\\include\\compile_info.asm";
	int major = 3, minor = 0, patch = 0;   /* 缺省版本，首次运行若没文件就用它 */

	/* 读取旧文件，解析出版本号 x.y.z */
	FILE *fp = fopen(path, "r");
	if (fp) {
		char line[256];
		while (fgets(line, sizeof(line), fp)) {
			char *p = strstr(line, "db \"");
			if (p) {
				int a, b, c;
				if (sscanf(p + 4, "%d.%d.%d", &a, &b, &c) == 3) {
					major = a;
					minor = b;
					patch = c;
				}
			}
		}
		fclose(fp);
	}

	patch++;   /* 自增小版本 */

	/* 取当前系统时间 */
	time_t t = time(NULL);
	struct tm *tm = localtime(&t);

	char date_str[32], time_str[32];
	/* 日期不补零 */
	sprintf(date_str, "%d/%d/%d", tm->tm_year + 1900, tm->tm_mon + 1, tm->tm_mday);
	/* 时间补零，末尾留空格 */
	sprintf(time_str, "%02d:%02d ", tm->tm_hour, tm->tm_min);

	/* 写回 compile_info.asm */
	fp = fopen(path, "w");
	if (!fp) {
		fprintf(stderr, "无法写入 %s\n", path);
		return 1;
	}

	fprintf(fp, "compile_info:\n");
	fprintf(fp, "db \"Compiled on:\"\n");
	fprintf(fp, "db \"%s\",20h\n", date_str);
	fprintf(fp, "db \"at %s VER \"\n", time_str);
	fprintf(fp, "db \"%d.%d.%d\",0ah,0dh\n", major, minor, patch);
	fprintf(fp, "db \"Copyright (c) Huang2.cn\" ,0ah,0dh,0\n");

	fclose(fp);
	printf("Updated to v%d.%d.%d  (%s %s)\n", major, minor, patch, date_str, time_str);
	return 0;
}