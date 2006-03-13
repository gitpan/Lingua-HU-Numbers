package Lingua::HU::Numbers;

use 5.6.0;

use warnings;
use strict;

use Carp;

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT = ();
our @EXPORT_OK = qw( num2hu );

our $VERSION = '0.01';

our %dig;

@dig{ 0..30,40,50,60,70,80,90 } = qw( nulla egy kettõ három négy öt hat hét
nyolc kilenc tíz tizenegy tizenkettõ tizenhárom tizennégy tizenöt tizenhat
tizenhét tizennyolc tizenkilenc húsz huszonegy huszonkettõ huszonhárom
huszonnégy huszonöt huszonhat huszonhét huszonnyolc huszonkilenc harminc
negyven ötven hatvan hetven nyolcvan kilencven );

our @desc = ('',qw(ezer millió milliárd billió billiárd trillió trilliárd 
	kvadrillió kvadrilliárd kvintillió kvintilliárd szextillió 
	szeptillió szeptilliárd oktillió oktilliárd nonillió nonilliárd
	decillió decilliárd));

sub num2hu {
	my $num = $_[0];
	return undef unless defined $num && length $num;
	croak("Currently the module only works with positive integers!") 
		if ($num !~ m/^\d+$/s);
	
	croak("The number is too large, the module can't handle it!")
		if (length($num) > 67);
	return _int2hu($num);
}

sub _int2hu {
	my $num = $_[0];
	my $recur = $_[1];
	return $dig{$num} if ($dig{$num});
	if ($num =~ m/^(\d)(\d)$/) {
		return $dig{$1.'0'} . $dig{$2}
	} elsif ($num =~ m/^(\d)(\d\d)$/) {
		my ($hun,$end) = ($1,$2);
		$hun = ($hun eq '1' && !$recur)? 'száz':"$dig{$hun}száz";
		return $hun if ($end eq '00');
		return $hun._int2hu($2 + 0);
	} elsif ($num <= 2000 && $num =~ m/^1(\d\d\d)$/) {
		return 'ezer' if ($1 eq '000');
		return 'ezer'._int2hu($1 + 0,1);
	} elsif ($num =~ m/^(\d{1,3})((?:000){1,2})$/) {
		my ($pre,$end) = ($1,(length($2) == 3)? $desc[1]:$desc[2]);
		return _int2hu($pre + 0).$end;
	} else {
		return _bigint2hu($num);
	}

}

sub _bigint2hu {
	my $num = $_[0];
	my @parts;
	my $count = 0;
	if ($num =~ m/001(\d{3})$/) {
		$num =~ s/00(1\d{3})$//;
		my $part = $1;
		unshift @parts, [ $part, $count ];
		$count += 2;
	}
	while ($num =~ s/(\d{1,3})$//) {
		my $part = $1 + 0;
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
=head1 NAME

Lingua::HU::Numbers - converts numbers into Hungarian language text form.

=head1 VERSION

Version 0.01

=cut

=head1 SYNOPSIS


Perhaps a little code snippet.

    use Lingua::HU::Numbers qw/num2hu/;

    my $number = "42";
    my $foo = num2hu($number);
    print $foo;

prints

    negyvenkettõ

=head1 DESCRIPTION

Lingua::HU::Numbers is a module converting numbers (like "42") into their 
Hungarian language representation ("negyvenkettõ").

Currently the only function that can be exported is C<num2hu>.

Please see the README file for details of Hungarian grammar.

=head1 FUNCTIONS

=over

=item * num2hu

This function is the only available one at the moment.
It takes a scalar value which currently must be a positive integer smaller
than 10**66. The return value is a scalar expressing the Hungarian text
version of the given number.

=cut

=back

=head1 LIMITATIONS

The module cannot handle anything but positive integers smaller than 10**66
at the moment.

=head1 FUTURE PLANS

Full integer, real number, exponential notation, num2hu_ordinal, fraction
support will be added in the next few releases. Patches welcome.

The module aims to remain similar in structure to L<Lingua::EN::Numbers>,
so that those familiar with that module can use this one easily.

=head1 AUTHOR

Bálint Szilakszi, C<< <szbalint at cpan.org> >>

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

Copyright 2006 Bálint Szilakszi, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1;
