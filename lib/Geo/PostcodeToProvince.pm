package Geo::PostcodeToProvince;

use 5.006;
use strict;
use warnings FATAL => 'all';
use utf8;

use Carp qw(croak);
require Exporter;

our @ISA = qw(Exporter);
our @EXPORT_OK = qw(postcode_to_province);

=head1 NAME

Geo::PostcodeToProvince - Get a province name for a given postcode

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

Given a country name and a postcode, get the name of the province.

    use Geo::PostcodeToProvince qw(postcode_to_province);

    my $province = postcode_to_province("it", "rm");
    # $province is now "Rome"

=head1 SUBROUTINES/METHODS

=head2 postcode_to_province

Takes two string arguments, the first one being a two-letter ISO 3166-1 country
code, and the second one being a postcode in that country.

It returns the name of the province of that postcode if it can find it, or
undef if not.

If the wrong number of arguments is passed, this subroutine will die.

    my $province = postcode_to_province("it", "rm");

=cut

sub postcode_to_province {
    croak "Expected two arguments" if (@_ != 2);
    my ($country, $postcode) = @_;

    if ($country eq "it" && $postcode eq "rm") {
        return "Rome";
    }
    return;
}

=head1 AUTHOR

David D Lowe, C<< <daviddlowe.flimm at gmail.com> >>

=head1 BUGS

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Geo::PostcodeToProvince


You can also look for information at:

=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2016 David D Lowe.

=cut

1; # End of Geo::PostcodeToProvince
