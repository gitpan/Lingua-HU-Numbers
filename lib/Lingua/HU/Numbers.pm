package Lingua::HU::Numbers;

use 5.6.0;

use warnings;
use strict;

use Carp;

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT = ();
our @EXPORT_OK = qw( num2hu );

our $VERSION = '0.03';

our %dig;

@dig{ 0..30,40,50,60,70,80,90 } = qw( nulla egy kett� h�rom n�gy �t hat h�t
nyolc kilenc t�z tizenegy tizenkett� tizenh�rom tizenn�gy tizen�t tizenhat
tizenh�t tizennyolc tizenkilenc h�sz huszonegy huszonkett� huszonh�rom
huszonn�gy huszon�t huszonhat huszonh�t huszonnyolc huszonkilenc harminc
negyven �tven hatvan hetven nyolcvan kilencven );

our @desc = ('',qw(ezer milli� milli�rd billi� billi�rd trilli� trilli�rd 
	kvadrilli� kvadrilli�rd kvintilli� kvintilli�rd szextilli� szextilli�rd
	szeptilli� szeptilli�rd oktilli� oktilli�rd nonilli� nonilli�rd
	decilli� decilli�rd));

our @frac = ('',qw( ezred milliomod milli�rdod billiomod billi�rdod
	trilliomod trilli�rdod kvadrilliomod kvadrilli�rdod kvintilliomod
	kvintilli�rdod szextilliomod szextilli�rdod szeptilliomod szeptilli�rdod
	oktilliomod oktilli�rdod nonilliomod nonilli�rdod decilliomod 
	decilli�rdod ));

sub num2hu {
	my $num = $_[0];
	return $dig{'0'} if ($num =~ m/^[+-]0+$/s);
	return undef unless defined $num && length $num;
	croak("Number is not properly formatted!")
		if ($num !~ m/^[+-]?\d+(\.\d+)?$/s);
	my ($int,$frac) = $num =~ m/^[+-]?(\d+)(?:\.(\d+))?$/;
	croak("The number is too large, the module can't handle it!")
		if ($int && length($int) > 66 || $frac && length($frac) > 66);
	my $plusmin = '';
	$num =~ s/^([+-])/$plusmin = $1;''/es;
	$plusmin = ($plusmin eq '-') ? 'm�nusz ':'';
	if ($num =~ m/(\d+)\.(\d+)/) {
		if (_frac2hu($2)) { return $plusmin._int2hu($1).' eg�sz '._frac2hu($2)
		} else { return $plusmin._int2hu($1); }
	} else {
		return $plusmin._int2hu($num);
	}
}

sub _int2hu {
	my $num = $_[0];
	my $recur = $_[1];
	return $dig{$num} if ($dig{$num});
	my ($hun,$end,$pre);
	if ($num =~ m/^(\d)(\d)$/) {
		return $dig{$1.'0'} . $dig{$2}
	} elsif ($num =~ m/^(\d)(\d\d)$/) {
		($hun,$end) = ($1,$2);
		$hun = ($hun eq '1' && !$recur)? 'sz�z':"$dig{$hun}sz�z";
		return $hun if ($end eq '00');
		return $hun._int2hu($2 + 0);
	} elsif ($num <= 2000 && $num =~ m/^1(\d\d\d)$/) {
		return 'ezer' if ($1 eq '000');
		return 'ezer'._int2hu($1 + 0,1);
	} elsif ($num =~ m/^(\d{1,3})((?:000){1,2})$/) {
		($pre,$end) = ($1,(length($2) == 3)? $desc[1]:$desc[2]);
		return _int2hu($pre + 0).$end;
	} else {
		return _bigint2hu($num);
	}

}

sub _bigint2hu {
	my $num = $_[0];
	my @parts;
	my $count = 0;
	my $part;
	if ($num =~ m/001(\d{3})$/) {
		$num =~ s/00(1\d{3})$//;
		$part = $1;
		unshift @parts, [ $part, $count ];
		$count += 2;
	}
	while ($num =~ s/(\d{1,3})$//) {
		$part = $1 + 0;
		unshift @parts, [ $part, $count ] if ($part);
		$count++;
	}
	my @out;
	for (0..$#parts) {
		push @out, _int2hu($parts[$_]->[0],$_).
		(($parts[$_]->[1] > 8)? ' ':'').
		$desc[$parts[$_]->[1]];
	}
	return join('-',@out);
	
}

sub _frac2hu {
	my $num = $_[0];
	$num =~ s/0+$//;
	my $place = length($num);
	$num =~ s/^0+//;
	return undef if ($num eq '');
	if ($place < 3) { 
		$place = ($place == 1) ? 'tized':'sz�zad';
		return _int2hu($num).' '.$place;
	} else {
		my $rest = '';
		$rest = _int2hu('1'.('0' x ($place % 3))) if ($place % 3);
		$place = int( $place / 3 );
		return _int2hu($num).' '.$rest.$frac[$place];
	}


}
=head1 NAME

Lingua::HU::Numbers - converts numbers into Hungarian language text form.

=head1 SYNOPSIS


    use Lingua::HU::Numbers qw/num2hu/;

    my $number = "42";
    my $foo = num2hu($number);
    print $foo;

prints

    negyvenkett�

=head1 DESCRIPTION

Lingua::HU::Numbers is a module converting numbers (like "42") into their
Hungarian language representation ("negyvenkett�").

Currently the only function that can be exported is C<num2hu>.

Please see the README file for details of Hungarian grammar.

=head1 FUNCTIONS

=over

=item * num2hu

This function is the only available one at the moment.
It takes a scalar value which currently must be a real number smaller
than -+10**66. The return value is a scalar expressing the Hungarian text
version of the given number.

=cut

=back

=head1 LIMITATIONS

The module cannot handle numbers larger than -+10**66
at the moment.

=head1 FUTURE PLANS

Exponential notation, num2hu_ordinal, fraction
support will be added in the next few releases. Patches welcome.

The module aims to remain similar in structure to L<Lingua::EN::Numbers>,
so that those familiar with that module can use this one easily.

=head1 AUTHOR

B�lint Szilakszi, C<< <szbalint at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-lingua-hu-numbers at rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Lingua-HU-Numbers>.
I will be notified, and then you'll automatically be notified of progress on
your bug as I make changes.

=head1 SEE ALSO

L<Lingua::EN::Numbers>
L<Lingua::Num2Word>

=head1 ACKNOWLEDGEMENTS

Sean M. Burke for writing Lingua::EN::Numbers, which this module is modelled from.

=head1 COPYRIGHT & LICENSE

Copyright 2006 B�lint Szilakszi, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1;
