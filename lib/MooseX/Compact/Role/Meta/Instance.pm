package MooseX::Compact::Role::Meta::Instance;

use Moose::Role;

use Scalar::Util qw(weaken);
use Arena::Compact;
use namespace::clean -except => 'meta';

fieldhash our %attr;

sub _glob_for {
    my $name = shift;

    $name =~ s/([^0-9a-zA-Y_])/sprintf "Z%02X", ord($1)/eg;

    return __PACKAGE__ . "::Key::" . $name;
}

sub _key_for : lvalue { # they've been experimental since 2000
    no strict 'refs';

    return ${ _glob_for(shift) };
}

sub BUILD {
    my $self = shift;

    # XXX doing anything per slot here is O(n^2).
    for ($self->get_all_slots) {
        _key_for($_) = Arena::Compact::key($_);
    }
}

sub create_instance { Arena::Compact::new(); }

sub get_slot_value {
    my ($self, $instance, $slot_name) = @_;

    no strict 'refs';
    return Arena::Compact::get($instance, _key_for($slot_name));
}

sub set_slot_value {
    my ($self, $instance, $slot_name, $value) = @_;

    no strict 'refs';
    Arena::Compact::put($instance, _key_for($slot_name), $value);
}

sub deinitialize_slot {
    die "incompletely initialized slots unimplemented"
}

sub deinitialize_all_slots {
    die "incompletely initialized slots unimplemented"
}

sub is_slot_initialized {
    die "incompletely initialized slots unimplemented"
}

sub weaken_slot_value {
    die "weak references unimplemented"
}

sub inline_create_instance {
    my ($self, $class_variable) = @_;
    return "bless (Arena::Compact::bnew()), $class_variable"
}

sub inline_slot_access {
    my ($self, $instance, $slot_name) = @_;
    die "lvalue hooks for Arena::Compact not implemented yet";
}

sub inline_get_slot_value {
    my ($self, $instance, $slot_name) = @_;
    return "Arena::Compact::get($instance, \$" . _glob_for($slot_name) . ")";
}

sub inline_set_slot_value {
    my ($self, $instance, $slot_name, $value) = @_;
    return "Arena::Compact::put($instance, \$" . _glob_for($slot_name) . ", $value)";
}

1;

__END__

=head1 NAME

MooseX::Compact::Role::Meta::Instance - The glue between Moose and Arena::Compact

=head1 SYNOPSIS

  package My::Object;

  use MooseX::Compact;

  # ... normal Moose functionality

=head1 DESCRIPTION

No user-servicable parts inside.

=head1 BUGS

=head1 SEE ALSO

=head1 SUPPORT

See L<MooseX::Compact>.

=head1 AUTHOR

  Stefan O'Rear <stefanor at cox dot net>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2009 by Stefan O'Rear.

This is free software; you can redistribute it and/or modify it under
the same terms as perl itself.

=cut

1;
