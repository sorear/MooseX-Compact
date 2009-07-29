package MooseX::Compact;

# Much of this was cargo culted from MooseX::InsideOut by Hans Dieter Pearcy

use Moose ();
use Moose::Exporter;
use Moose::Util::MetaRole;
use MooseX::Compact::Role::Meta::Instance;

Moose::Exporter->setup_import_methods(
  also => [ 'Moose' ],
);

sub init_meta {
  shift;
  my %p = @_;
  Moose->init_meta(%p);
  Moose::Util::MetaRole::apply_metaclass_roles(
    for_class                => $p{for_class},
    instance_metaclass_roles => [ 'MooseX::InsideOut::Role::Meta::Instance' ],
  );
}

1;
__END__

=head1 NAME

MooseX::Compact - Moose backend which sacrifices speed for space efficiency

=head1 SYNOPSIS

  package My::Object;

  use MooseX::Compact;

  # ... normal Moose functionality

=head1 DESCRIPTION

When Perl is faced with a time/space tradeoff, it almost always throws memory
at the problem.  This module allows you to store objects in a more compact
form, off the Perl heap, at a small cost in performance.  See the documentation
of the sister module, L<Arena::Compact>, for implementation details.

=head1 TODO

This module will evolve as Arena::Compact does, and both modules are being
heavily influenced by the requirements of the other.

Both modules are very incomplete.

=head1 BUGS

No known bugs.

Please report any bugs through RT: email
C<bug-moosex-compact at rt.cpan.org>, or browse to
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=MooseX-Compact>.

=head1 SEE ALSO

=head1 AUTHOR

  Stefan O'Rear <stefanor at cox dot net>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2009 by Stefan O'Rear.

This is free software; you can redistribute it and/or modify it under
the same terms as perl itself.

=cut

1;
