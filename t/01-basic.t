#!perl -T
use Lingua::HU::Numbers qw/num2hu/;
use Test::More tests => 31;

## integers [1-12]
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
	"kilencsz�zkilencvenkilenc decilli�");

## -+ signs [13-18]
is (num2hu('-1100'), "m�nusz ezeregysz�z");
is (num2hu('-21000'), "m�nusz huszonegyezer");
is (num2hu('+1111'), "ezeregysz�ztizenegy");
is (num2hu('+23000'), "huszonh�romezer");
is (num2hu('-0'), "nulla");
is (num2hu('+0'), "nulla");

## real numbers [19-25]

is (num2hu('1.5'), "egy eg�sz �t tized");
is (num2hu('2001.2005'), "kett�ezer-egy eg�sz kett�ezer-�t t�zezred");
is (num2hu('11.10'), "tizenegy eg�sz egy tized");
is (num2hu('20.101'), "h�sz eg�sz sz�zegy ezred");
is (num2hu('120.000'), "sz�zh�sz");
is (num2hu('99.010'), "kilencvenkilenc eg�sz egy sz�zad");
is (num2hu('0.0101'), "nulla eg�sz sz�zegy t�zezred");

## combined cases [26-27]
is (num2hu('+0.0'), "nulla");
is (num2hu('-0.010'),"m�nusz nulla eg�sz egy sz�zad");

## formatting errors [28-31]

ok (! eval("num2hu('0.')") && $@);
ok (! eval("num2hu('0,')") && $@);
ok (! eval("num2hu('text')") && $@);
ok (! eval('$_="1" x 67;num2hu($_)') && $@);
