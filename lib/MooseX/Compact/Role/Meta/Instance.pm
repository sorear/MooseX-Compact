
package MooseX::Compact::Role::Meta::Instance;

use Moose::Role;

use Hash::Util::FieldHash::Compat qw(fieldhash);
use Scalar::Util qw(refaddr weaken);
use namespace::clean -except => 'meta';

fieldhash our %attr;

around create_instance => sub {
  my $next = shift;
  my $instance = shift->$next(@_);
  $attr{refaddr $instance} = {};
  return $instance;
};

sub get_slot_value {
  my ($self, $instance, $slot_name) = @_;

  return $attr{refaddr $instance}->{$slot_name};
}

sub set_slot_value {
  my ($self, $instance, $slot_name, $value) = @_;

  return $attr{refaddr $instance}->{$slot_name} = $value;
}

sub deinitialize_slot {
  my ($self, $instance, $slot_name) = @_;
  return delete $attr{refaddr $instance}->{$slot_name};
}

sub deinitialize_all_slots {
  my ($self, $instance) = @_;
  $attr{refaddr $instance} = {};
}

sub is_slot_initialized {
  my ($self, $instance, $slot_name) = @_;

  return exists $attr{refaddr $instance}->{$slot_name};
}

sub weaken_slot_value {
  my ($self, $instance, $slot_name) = @_;
  weaken $attr{refaddr $instance}->{$slot_name};
}

around inline_create_instance => sub {
  my $next = shift;
  my ($self, $class_variable) = @_;
  my $code = $self->$next($class_variable);
  $code = "do { my \$instance = ($code);";
  $code .= sprintf(
    '$%s::attr{Scalar::Util::refaddr($instance)} = {};',
    __PACKAGE__,
  );
  $code .= '$instance }';
  return $code;
};

sub inline_slot_access {
  my ($self, $instance, $slot_name) = @_;
  die "lvalue hooks for Arena::Compact not implemented yet";
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
