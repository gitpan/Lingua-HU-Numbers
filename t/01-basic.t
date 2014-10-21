#!perl -T
use Lingua::HU::Numbers qw/num2hu/;
use Test::More tests => 12;

is (num2hu(0), "nulla");
is (num2hu(12), "tizenkett�");
is (num2hu(100), "sz�z");
is (num2hu(1000), "ezer");
is (num2hu(1999), "ezerkilencsz�zkilencvenkilenc");
is (num2hu(2001), "kett�ezer-egy");
is (num2hu(2110), "kett�ezer-egysz�zt�z");
is (num2hu(5000), "�tezer");
is (num2hu(123000),"sz�zhuszonh�romezer");
is (num2hu(1000000),"egymilli�");
is (num2hu(1001000), "egymilli�-ezer");
is (num2hu('999000000000000000000000000000000000000000000000000000000000000'),
	"kilencsz�zkilencvenkilenc decilli�rd");
