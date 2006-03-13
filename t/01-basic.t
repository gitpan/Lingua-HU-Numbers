#!perl -T
use Lingua::HU::Numbers qw/num2hu/;
use Test::More tests => 12;

is (num2hu(0), "nulla");
is (num2hu(12), "tizenkettõ");
is (num2hu(100), "száz");
is (num2hu(1000), "ezer");
is (num2hu(1999), "ezerkilencszázkilencvenkilenc");
is (num2hu(2001), "kettõezer-egy");
is (num2hu(2110), "kettõezer-egyszáztíz");
is (num2hu(5000), "ötezer");
is (num2hu(123000),"százhuszonháromezer");
is (num2hu(1000000),"egymillió");
is (num2hu(1001000), "egymillió-ezer");
is (num2hu('999000000000000000000000000000000000000000000000000000000000000'),
	"kilencszázkilencvenkilenc decilliárd");
