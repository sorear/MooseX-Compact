#!/usr/bin/env perl
use strict;
use warnings;
use Test::More tests => 1;

package Foo;
::use_ok('MooseX::Compact')
    or ::BAIL_OUT("couldn't load MooseX::Compact");
