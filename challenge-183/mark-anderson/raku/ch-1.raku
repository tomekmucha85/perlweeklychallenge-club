#!/usr/bin/env raku
use Test;

is-deeply ([1,2], [3,4], [5,6], [1,2]).unique(:with(&[eqv])), ([1,2], [3,4], [5,6]);
is-deeply ([9,1], [3,7], [2,5], [2,5]).unique(:with(&[eqv])), ([9,1], [3,7], [2,5]);
