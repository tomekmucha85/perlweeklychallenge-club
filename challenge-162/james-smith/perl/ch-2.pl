#!nusr/local/bin/perl

use strict;

use warnings;
use feature qw(say);
use Test::More;
use Benchmark qw(cmpthese timethis);
use Data::Dumper qw(Dumper);

is( encrypt('playfair example', 'hide the gold in the tree stump'), 'bmodzbxdnabekudmuixmmouvif' );
is( decrypt('perl and raku',    'siderwrdulfipaarkcrw'),            'thewexeklychallengex' );

done_testing();

sub encrypt { return _crypt( 1,@_); }
sub decrypt { return _crypt(-1,@_); }

sub _crypt {
  my($off,$key,$p,$out,@r,%l) = (shift,shift,0,'');           ## Initialise variables and get mapping...
  ($_ eq 'j' && ($_='i')), exists $l{$_} || ($l{$_}=[int $p/5,($p++)%5]) for grep { /[a-z]/ } split(//,$key),'a'..'i','j'..'z';
  $r[$l{$_}[0]][$l{$_}[1]]=$_ for keys %l;

  my @seq = grep {/[a-z]/} split //, shift =~ s{j}{j}gr;      ## Prep sequence

  while(my($m,$n)=splice @seq,0,2) {                          ## Loop through letter pairs
    unshift(@seq,$n), $n='x' if $n && $n eq $m and $n ne 'x'; ## Deal with case when both letters the same
    $n ||= 'x';                                               ## Pad if required...
    $out.= $l{$m}[0] eq $l{$n}[0] ? $r[ $l{$m}[0]        ][($l{$m}[1]+$off)%5] . $r[ $l{$n}[0]        ][($l{$n}[1]+$off)%5]
         : $l{$m}[1] eq $l{$n}[1] ? $r[($l{$m}[0]+$off)%5][ $l{$m}[1]        ] . $r[($l{$n}[0]+$off)%5][ $l{$n}[1]        ]
         :                          $r[ $l{$m}[0]        ][ $l{$n}[1]        ] . $r[ $l{$n}[0]        ][ $l{$m}[1]        ]
         ;
  }
  $out;
}

