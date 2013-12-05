package Deque;
use strict;
use warnings;

sub new {
   my ($class) = @_;
   return bless {}, $class;
}

sub push {
    my ($self, $value) = @_;

    my $element = Element->new(
       value   => $value, 
       prev_e  => $self->{last_e},
       next_e  => undef,
   );
   if ($self->{last_e}) {
      $self->{last_e}{next_e} = $element;
   }
   $self->{last_e} = $element;
   if (not $self->{first_e}) {
       $self->{first_e} = $element;
   }

   return;
}

sub pop {
    my ($self) = @_;

    my $element = $self->{last_e};
    die 'List is empty' if not $element;

    $self->{last_e} = $element->{prev_e};
	$self->{last_e}{next_e} = undef;

    return $element->{value};
}

sub shift {
    my ($self) = @_;

    my $element = $self->{first_e};
    die 'List is empty' if not $element;

    $self->{first_e} = $element->{next_e};
    $self->{first_e}{prev_e} = undef;

    return $element->{value};

}

sub unshift {
    my ($self, $value) = @_;

    my $element = Element->new(
       value   => $value, 
       prev_e  => undef,
       next_e  => $self->{first_e},
   );
   if ($self->{first_e}) {
      $self->{first_e}{prev_e} = $element;
   }
   $self->{first_e} = $element;
   if (not $self->{last_e}) {
       $self->{last_e} = $element;
   }
   return;
}


package Element;
use strict;
use warnings;

sub new {
   my ($class, %data) = @_;
   return bless \%data, $class;
}

1;

