# We assume the underlying module works; any tests should go _there_
use warnings;
use strict;
use Test::More tests => 8;

{
    package Foo;

    use Moose;
    use MooseX::Compact;
}

ok(Foo->new->isa('Foo'), "construction succeeded");

{
    package Foo;

    has attr1 => ( is => 'bare' );
}

ok(Foo->new(attr1 => 1)->isa('Foo'), "non-inline writer works");

my $att = Foo->meta->get_attribute('attr1');

is($att->get_value(Foo->new(attr1 => 1)), 1, "non-inline reader works");

{
    package Foo;

    has attr2 => ( is => 'ro' );
}

is(Foo->new(attr2 => 2)->attr2, 2, "inline reader works");

{
    package Foo;

    has attr3 => ( is => 'rw' );
}

{
    my $foo = Foo->new;
    $foo->attr3(42);
    is($foo->attr3, 42, "inline writer works");
}

{
    package Foo;

    has attr4 => ( is => 'rw', predicate => 'has_a4', clearer => 'zap_a4' );
}

{
    my $foo = Foo->new;
    $foo->attr4(42);
    is($foo->has_a4, 1, "inline is_slot_initialized works");
    $foo->zap_a4;
    ok(!$foo->has_a4, "inline deinitialize_slot works");
}

Foo->meta->make_immutable;

ok(Foo->new->isa('Foo'), "inline constructor works");
