package Geo::LookupPostcode;

use 5.012;
use strict;
use warnings FATAL => 'all';
use utf8;

use Module::Load;
use Carp qw(croak);
require Exporter;

our @ISA = qw(Exporter);
our @EXPORT_OK = qw(lookup_postcode);

# These are initialised further down
my %lookup_table;
my %lookup_functions;

=encoding utf-8

=head1 NAME

Geo::LookupPostcode - Get province data for a given postcode

=head1 VERSION

Version 0.01_01

This is a developer release, as the API interface may change.

=cut

our $VERSION = '0.01_01';


=head1 SYNOPSIS

Given a country name and a postcode, get which province or region or area it
refers to.

    use Geo::LookupPostcode qw(lookup_postcode);

    my $province = lookup_postcode("it", "00118");
    # $province is now:
    # {
    #   region_code => 'IT-62',
    #   province_code => 'IT-RM',
    # }

If you prefer, you can use country-specific modules, it is the same result in
either case.

    use Geo::LookupPostcode::IT;
    my $province = lookup_it_postcode("00118");

=head1 Supported countries

=over 12

=item Italy

This includes the Vatican and the Republic of San Marino.

L<Geo::LookupPostcode::IT>

=item Spain

L<Geo::LookupPostcode::ES>

=back

=head1 SUBROUTINES/METHODS

=head2 lookup_postcode

Takes two character string arguments, the first one being a two-letter ISO
3166-1 country code, and the second one being a postcode in that country.

If successful, it returns a reference to a hash. The keys depend on the
country. In the case of Italy, it would return this structure:

    {
        region_code => $region_code,
        province_code => $province_code,
    }
    
If it cannot find the province, it returns undef.

Note that the names may be anglicised (eg: "Vatican City", not "Città del Vaticano").

This subroutine will die if the wrong number of arguments is passed or if an
unsupported country is passed.

    my $rh_province = lookup_postcode("it", "00118");

=cut

sub lookup_postcode {
    croak "Expected two arguments" if (@_ != 2);
    my ($country, $postcode) = @_;

    croak "Country $country in unexpected format" if $country !~ /^[a-z]{2}$/i;

    my $uc_country = uc($country);
    my $lc_country = lc($country);
    my $module = "Geo::LookupPostcode::$uc_country";
    load $module;
    my $subroutine = \&{"${module}::lookup_${lc_country}_postcode"};
    return $subroutine->($postcode);
}



=head1 AUTHOR

David D Lowe, C<< <daviddlowe.flimm at gmail.com> >>

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Geo::LookupPostcode

You can also look for information at:

=over 4

=item * GitHub issue tracker (report bugs here)

L<https://github.com/Flimm/lookup-postcode/issues>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Geo-LookupPostcode>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Geo-LookupPostcode>

=item * Search CPAN

L<http://search.cpan.org/dist/Geo-LookupPostcode/>

=back

=head1 SEE ALSO


L<Geo::Postcode>, L<Geo::UK::Postcode> and L<Address::PostCode::UK> provides UK
postcode validation and location.

L<Geo::PostalCode> provides USA postal code functions.

L<Geo::Postcodes> provides an abstract interface for looking up postcodes. The
only two implementations that I am aware of are L<Geo::Postcodes::NO> and
L<Geo::Postcodes::DK>, for Norway and Denmark.


=head1 ACKNOWLEDGEMENTS

Most of the data was sourced from Wikipedia.

=head1 LICENSE AND COPYRIGHT

Copyright 2016 David D Lowe and contributors.

This work is licensed under CC BY-SA 3.0.

=cut

1; # End of Geo::LookupPostcode
