#!perl -T

package main;

use strict;
use warnings;

use Test::More 'no_plan';

sub with::Mock::right { pass $_[1] }
sub with::Mock::wrong { fail $_[1] }
sub with::Mock::test  { is_deeply $_[1], $_[2], $_[3] }

use with \bless {}, 'with::Mock';

my $c = 0;
++$c for 1 .. 10;
test $c, 10, 'for';

$c = 0;
while ($c < 5) { ++$c; }
test $c, 5, 'while';

$c = undef;
test !defined($c), 1, 'undef, defined';

my @a = (1, 2);

my $x = pop @a;
my $y = shift @a;
push @a, $y;
unshift @a, $x;
test \@a, [ 2, 1 ], 'pop/shift/push/unshift';

@a = reverse @a;
test \@a, [ 1, 2 ], 'reverse';

open my $fh, '<', $0 or die "$!";
my $d = do { local $/; <$fh> };
$d =~ s/^(\S+).*/$1/s;
test $d, '#!perl', 'open/do/local';

@a = map { $_ + 1 } 0 .. 5;
test \@a, [ 1 .. 6 ], 'map';

@a = grep { $_ > 2 } 0 .. 5;
test \@a, [ 3 .. 5 ], 'grep';

my %h = (foo => 1, bar => 2);
@a = sort { $h{$a} <=> $h{$b} } keys %h;
test \@a, [ 'foo', 'bar' ], 'sort/keys';

print STDERR "# boo" if 0;
