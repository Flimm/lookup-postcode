package Geo::LookupPostcode::FI;

use 5.012;
use strict;
use warnings FATAL => 'all';
use utf8;

use Carp qw(croak);
require Exporter;

our @ISA = qw(Exporter);
our @EXPORT_OK = qw(lookup_fi_postcode);

my %geo_areas;

=encoding utf-8

=head1 NAME

Geo::LookupPostcode::FI - Get province and region codes for a Finnish postcode

=head1 SUBROUTINES/METHODS

=head2 lookup_fi_postcode

Takes one character string argument: a postcode.

If successful, it returns a reference to a hash, with this structure:


    my $rh_area = lookup_fi_postcode("01430");
    {
        area_name => $area_name,
    }
    
If it cannot find the area, it returns undef.

Note that the names may be anglicised. Note that the areas given here are
approximate, as real postal code districts seldom follow administrative region
or province boundaries, and sometimes even a single municipality can be located
in multiple postal code districts.

=cut

sub lookup_fi_postcode {
    croak "Expected one argument" if (@_ != 1);
    my ($postcode) = @_;

    # Do some cleanup of postcode:
    utf8::upgrade $postcode;
    $postcode =~ s/\s*//g;

    return if $postcode !~ /^[0-9]+$/;

    $postcode = sprintf("%05d", $postcode);

    my $area_code = substr($postcode, 0, 2);

    my $area_name = $geo_areas{$area_code};
    if (defined($area_name)) {
        return { area_name => $area_name };
    }
    return;
}

# Data from https://en.wikipedia.org/wiki/List_of_postal_codes_in_Finland

BEGIN { %geo_areas = (
    '00' => 'Helsinki',
    '01' => 'Vantaa',
    '02' => 'the Espoo',
    '03' => 'north-western Uusimaa',
    '04' => 'north-eastern Uusimaa',
    '05' => 'Hyvinkää',
    '06' => 'Porvoo',
    '07' => 'the rest of Eastern Uusimaa',
    '08' => 'Lohja',
    '09' => 'the rest of the Lohja region',
    '10' => 'South Western Uusimaa, Hanko',
    '11' => 'Riihimäki',
    '12' => 'the rest of the Riihimäki region',
    '13' => 'Hämeenlinna',
    '14' => 'the rest of Tavastia Proper',
    '15' => 'the Lahti region',
    '16' => 'southern Päijänne Tavastia',
    '17' => 'the west bank of Lake Päijänne',
    '18' => 'Heinola',
    '19' => 'north-eastern Päijänne Tavastia',
    '20' => 'Turku',
    '21' => 'the rest of the Turku region',
    '22' => 'Åland',
    '23' => 'the Uusikaupunki region (Vakka-Suomi)',
    '24' => 'Salo, Finland',
    '25' => 'the rest of western Southwest Finland',
    '26' => 'Rauma, Finland',
    '27' => 'the rest of southern Satakunta',
    '28' => 'Pori',
    '29' => 'the rest of northern Satakunta',
    '30' => 'Forssa',
    '31' => 'the rest of the Forssa region',
    '32' => 'the Loimaa region',
    '33' => 'the Tampere region',
    '34' => 'northern Pirkanmaa',
    '35' => 'north-eastern Pirkanmaa',
    '36' => 'south-eastern Pirkanmaa',
    '37' => 'south-western Pirkanmaa',
    '38' => 'eastern Satakunta',
    '39' => 'north-western Pirkanmaa',
    '40' => 'the Jyväskylä region',
    '41' => 'the eastern part of Central Finland',
    '42' => 'the Jämsä and Keuruu regions',
    '43' => 'northern Central Finland',
    '44' => 'the Äänekoski region',
    '45' => 'Kouvola',
    '46' => 'Anjalankoski',
    '47' => 'north-western Kymenlaakso',
    '48' => 'Kotka',
    '49' => 'the Hamina region',
    '50' => 'Mikkeli',
    '51' => 'the northern part of Southern Savonia',
    '52' => 'the south-eastern part of Southern Savonia',
    '53' => 'Lappeenranta',
    '54' => 'the rest of the Lappeenranta region',
    '55' => 'Imatra',
    '56' => 'Rautjärvi and Ruokolahti',
    '57' => 'Savonlinna',
    '58' => 'the western part of Southern Savonia',
    '59' => 'the rest of South Karelia',
    '60' => 'the Seinäjoki region',
    '61' => 'the western part of Southern Ostrobothnia',
    '62' => 'the northern part of Southern Ostrobothnia',
    '63' => 'the eastern part of Southern Ostrobothnia',
    '64' => 'southern Ostrobothnia (region)',
    '65' => 'Vaasa',
    '66' => 'northern Ostrobothnia',
    '67' => 'Kokkola',
    '68' => 'the Jakobstad',
    '69' => 'the rest of Central Ostrobothnia',
    '70' => 'Kuopio',
    '71' => 'the rest of the Kuopio region',
    '72' => 'the western part of Northern Savonia',
    '73' => 'the eastern part of Northern Savonia',
    '74' => 'the Iisalmi region',
    '75' => 'Nurmes',
    '76' => 'Pieksämäki',
    '77' => 'Suonenjoki',
    '78' => 'Varkaus',
    '79' => 'the rest of the Varkaus region',
    '80' => 'Joensuu',
    '81' => 'northern North Karelia',
    '82' => 'southern North Karelia',
    '83' => 'western North Karelia',
    '84' => 'Ylivieska',
    '85' => 'the Nivala region',
    '86' => 'the central part of Northern Ostrobothnia',
    '87' => 'Kajaani',
    '88' => 'southern Kainuu',
    '89' => 'northern Kainuu',
    '90' => 'the Oulu region',
    '91' => 'the northern part of Northern Ostrobothnia',
    '92' => 'the Raahe region',
    '93' => 'the eastern part of Northern Ostrobothnia',
    '94' => 'Kemi',
    '95' => 'the Tornio region and western',
    '96' => 'Rovaniemi',
    '97' => 'Ranua and Posio',
    '98' => 'central Lapland',
    '99' => 'northern Lapland',
    # '99999' => 'Korvatunturi', # fictional
); }


1;
