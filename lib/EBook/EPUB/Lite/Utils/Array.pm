package EBook::EPUB::Lite::Utils::Array;

use Moo;

use Types::Standard qw/ArrayRef Str/;


has array => (isa => ArrayRef[Str],
              is => 'ro',
              default => sub { [] });


sub elements {
    my $self = shift;
    my @elements = @{ $self->array };
    return @elements;
}

sub push {
    my ($self, @args) = @_;
    CORE::push @{$self->array}, @args;
}


1;
