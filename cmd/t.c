#include<stdio.h>
struct x{
	int _chuang_jian_shi_jian;
	char *_xing_ming;
	int _nian_ling;
};

int main(void){
	int _dan_jia = 30;
	int _jian_shu = 3;
	struct x _xiang = {
		_chuang_jian_shi_jian:1992,
		_xing_ming:"_mou_wei",
		_nian_ling:21
	};
	//printf("_zong_ji:%d\n", _dan_jia*_jian_shu);
	printf("%d %s %d\n", _xiang._chuang_jian_shi_jian, _xiang._xing_ming, _xiang._nian_ling);

}

void ip_zhong_zu(void){
		
}














