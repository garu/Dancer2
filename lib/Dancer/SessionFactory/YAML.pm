package Dancer::SessionFactory::YAML;

# ABSTRACT: YAML-file-based session backend for Dancer

use Moo;
use Dancer::Core::Types;
use YAML::Any;

has _suffix => (
    is      => 'ro',
    isa     => Str,
    default => sub {'.yml'},
);

with 'Dancer::Core::Role::SessionFactory::File';

sub _freeze_to_handle {
    my ($self, $fh, $data) = @_;
    print {$fh} YAML::Any::Dump($data);
    return;
}

sub _thaw_from_handle {
    my ($self, $fh) = @_;
    return YAML::Any::LoadFile($fh);
}

1;
__END__

=head1 DESCRIPTION

This module implements a session engine based on YAML files. Session are stored
in a I<session_dir> as YAML files. The idea behind this module was to provide a
human-readable session storage for the developer.

This backend is intended to be used in development environments, when digging
inside a session can be useful.

This backend an perfectly be used in production environments, but two things
should be kept in mind: The content of the session files is in plain text, and
the session files should be purged by a CRON job.

=head1 CONFIGURATION

The setting B<session> should be set to C<YAML> in order to use this session
engine in a Dancer application.

Files will be stored to the value of the setting C<session_dir>, whose default
value is C<appdir/sessions>.

Here is an example configuration that use this session engine and stores session
files in /tmp/dancer-sessions

    session: "YAML"

    engines:
      session:
        YAML:
          session_dir: "/tmp/dancer-sessions"

=head1 DEPENDENCY

This module depends on L<YAML>.

=head1 SEE ALSO

See L<Dancer::Session> for details about session usage in route handlers.

=cut
