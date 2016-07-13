package Geo::LookupPostcode;

use 5.006;
use strict;
use warnings FATAL => 'all';
use utf8;

use Carp qw(croak);
require Exporter;

our @ISA = qw(Exporter);
our @EXPORT_OK = qw(postcode_to_province);

# These are initialised further down
my %lookup_table;
my %lookup_functions;

=encoding utf-8

=head1 NAME

Geo::LookupPostcode - Get a province name for a given postcode

=head1 VERSION

Version 0.01_01

This is a developer release, as the API interface may change.

=cut

our $VERSION = '0.01_01';


=head1 SYNOPSIS

Given a country name and a postcode, get the name of the province.

    use Geo::LookupPostcode qw(postcode_to_province);

    my $province = postcode_to_province("it", "00118");
    # $province is now:
    # {
    #   region_code => 'IT-62',
    #   province_code => 'IT-RM',
    # }

=head1 Supported countries

=over 12

=item Italy

This includes the Vatican and the Republic of San Marino.

=back

=head1 SUBROUTINES/METHODS

=head2 postcode_to_province

Takes two character string arguments, the first one being a two-letter ISO
3166-1 country code, and the second one being a postcode in that country.

If successful, it returns a reference to a hash, with these key/value pairs:

    {
        region_code => $region_code,
        province_code => $province_code,
    }
    
If it cannot find the province, it returns undef if not.

Note that the names may be anglicised (eg: "Vatican City", not "Città del Vaticano").

This subroutine will die if the wrong number of arguments is passed or if an
unsupported country is passed.

    my $rh_province = postcode_to_province("it", "00118");

=cut

sub postcode_to_province {
    croak "Expected two arguments" if (@_ != 2);
    my ($country, $postcode) = @_;

    # Ensure that the UTF-8 flag is turned on, so that `lc` treats these
    # strings as character strings.
    utf8::upgrade $country;
    utf8::upgrade $postcode;

    $country = lc($country);
    $postcode = lc($postcode);

    croak "Unsupported country '$country'" if ! $lookup_table{$country};

    # Do some cleanup of postcode:
    utf8::upgrade $postcode;
    $postcode =~ s/\s*//g;

    my $lookup_key = $lookup_functions{$country}($postcode);
    if ($lookup_table{$country}{$lookup_key}) {
        my @results;
        for my $rh_geo_entry (@{ $lookup_table{$country}{$lookup_key} }) {
            local $_ = $postcode;
            if (! $rh_geo_entry->{function} || $rh_geo_entry->{function}()) {
                push @results, $rh_geo_entry;
            }
        }
        if (@results > 1) {
            my $provinces = join(", ", map { $_->{province} } @results);
            die "Found more than one province for postcode '$postcode': $provinces ";
        }
        elsif (@results == 1) {
            return {
                region_code => $results[0]{region_code},
                province_code => $results[0]{province_code},
            };
        }
    }
    return;
}

sub _build_data() {
    %lookup_functions = (
        it => sub { substr($_[0], 0, 3) },
    );

    # Italian data from https://en.wikipedia.org/wiki/List_of_postal_codes_in_Italy
    my %geo_provinces = ();
    $geo_provinces{it} = [
        {
            'region'        => 'Sicily',
            'lookup_keys'   => [ '920', '921' ],
            'province'      => 'Agrigento',
            'province_code' => 'IT-AG'
        },
        {
            'region'        => 'Piedmont',
            'lookup_keys'   => [ '150', '151' ],
            'province'      => 'Alessandria',
            'province_code' => 'IT-AL'
        },
        {
            'region'        => 'Marche',
            'lookup_keys'   => [ '600', '601' ],
            'province'      => 'Ancona',
            'province_code' => 'IT-AN'
        },
        {
            'region'        => 'Aosta Valley',
            'lookup_keys'   => [ '110', '111' ],
            'province'      => 'Aosta',
            'province_code' => 'IT-AO'
        },
        {
            'region'        => 'Marche',
            'lookup_keys'   => [ '630', '631' ],
            'province'      => 'Ascoli Piceno',
            'province_code' => 'IT-AP'
        },
        {
            'region'        => 'Abruzzo',
            'lookup_keys'   => [ '670', '671' ],
            'province'      => 'L\'Aquila',
            'province_code' => 'IT-AQ'
        },
        {
            'region'        => 'Tuscany',
            'lookup_keys'   => [ '520', '521' ],
            'province'      => 'Arezzo',
            'province_code' => 'IT-AR'
        },
        {
            'region'        => 'Piedmont',
            'lookup_keys'   => [ '140', '141' ],
            'province'      => 'Asti',
            'province_code' => 'IT-AT'
        },
        {
            'region'        => 'Campania',
            'lookup_keys'   => [ '830', '831' ],
            'province'      => 'Avellino',
            'province_code' => 'IT-AV'
        },
        {
            'region'        => 'Apulia',
            'lookup_keys'   => [ '700', '701' ],
            'province'      => 'Bari',
            'province_code' => 'IT-BA'
        },
        {
            'region'        => 'Lombardy',
            'lookup_keys'   => [ '240', '241' ],
            'province'      => 'Bergamo',
            'province_code' => 'IT-BG'
        },
        {
            'region'        => 'Piedmont',
            'lookup_keys'   => [ '138', '139' ],
            'province'      => 'Biella',
            'province_code' => 'IT-BI'
        },
        {
            'region'        => 'Veneto',
            'lookup_keys'   => [ '320', '321' ],
            'province'      => 'Belluno',
            'province_code' => 'IT-BL'
        },
        {
            'region'        => 'Campania',
            'comment'       => 'Province could also be Beneventum',
            'lookup_keys'   => [ '820', '821' ],
            'province'      => 'Benevento',
            'province_code' => 'IT-BN'
        },
        {
            'region'        => 'Emilia-Romagna',
            'lookup_keys'   => [ '400', '401' ],
            'province'      => 'Bologna',
            'province_code' => 'IT-BO'
        },
        {
            'region'        => 'Apulia',
            'lookup_keys'   => [ '720', '721' ],
            'province'      => 'Brindisi',
            'province_code' => 'IT-BR'
        },
        {
            'region'        => 'Lombardy',
            'lookup_keys'   => [ '250', '251' ],
            'province'      => 'Brescia',
            'province_code' => 'IT-BS'
        },
        {
            'region'        => 'Apulia',
            'lookup_keys'   => [ '760', '761' ],
            'province'      => 'Barletta-Andria-Trani',
            'province_code' => 'IT-BT'
        },
        {
            'region'        => 'Trentino-Alto Adige/Südtirol',
            'lookup_keys'   => [ '390', '391' ],
            'province'      => 'Bolzano/Bozen',
            'province_code' => 'IT-BZ'
        },
        {
            'region'        => 'Sardinia',
            'function'      => sub { ($_ >= 9121 && $_ <= 9134) || ($_ >= 9018 && $_ <= 9019) || ($_ >= 9042 && $_ <= 9049) || $_ == 8030 || $_ == 8033 || $_ == 8035 || $_ == 8043 },
            'lookup_keys'   => [ '080', '090', '091' ],
            'province'      => 'Cagliari',
            'province_code' => 'IT-CA',
            'comment'       => 'Remove 09010 to 09017 because it conflicts with Carbonia-Iglesias, and 09020 to 09041 because it conflicts with Medio Campidano',
        },
        {
            'region'        => 'Molise',
            'function'      => sub { $_ == 86100 || ($_ >= 86010 && $_ <= 86049) },
            'lookup_keys'   => [ '860', '861' ],
            'province'      => 'Campobasso',
            'province_code' => 'IT-CB'
        },
        {
            'region'        => 'Campania',
            'lookup_keys'   => [ '810', '811' ],
            'province'      => 'Caserta',
            'province_code' => 'IT-CE'
        },
        {
            'region'        => 'Abruzzo',
            'lookup_keys'   => [ '660', '661' ],
            'province'      => 'Chieti',
            'province_code' => 'IT-CH'
        },
        {
            'region'        => 'Sardinia',
            'function'      => sub { $_ >= 9010 && $_ <= 9017 },
            'lookup_keys'   => [ '090' ],
            'province'      => 'Carbonia-Iglesias',
            'province_code' => 'IT-CI'
        },
        {
            'region'        => 'Sicily',
            'lookup_keys'   => [ '930', '931' ],
            'province'      => 'Caltanissetta',
            'province_code' => 'IT-CL'
        },
        {
            'region'        => 'Piedmont',
            'lookup_keys'   => [ '120', '121' ],
            'province'      => 'Cuneo',
            'province_code' => 'IT-CN'
        },
        {
            'region'        => 'Lombardy',
            'lookup_keys'   => [ '220', '221' ],
            'province'      => 'Como',
            'province_code' => 'IT-CO'
        },
        {
            'region'        => 'Lombardy',
            'lookup_keys'   => [ '260', '261' ],
            'province'      => 'Cremona',
            'province_code' => 'IT-CR'
        },
        {
            'region'        => 'Calabria',
            'lookup_keys'   => [ '870', '871' ],
            'province'      => 'Cosenza',
            'province_code' => 'IT-CS'
        },
        {
            'region'        => 'Sicily',
            'lookup_keys'   => [ '950', '951' ],
            'province'      => 'Catania',
            'province_code' => 'IT-CT'
        },
        {
            'region'        => 'Calabria',
            'lookup_keys'   => [ '880', '881' ],
            'province'      => 'Catanzaro',
            'province_code' => 'IT-CZ'
        },
        {
            'region'        => 'Sicily',
            'lookup_keys'   => [ '940', '941' ],
            'province'      => 'Enna',
            'province_code' => 'IT-EN'
        },
        {
            'region'        => 'Emilia-Romagna',
            'lookup_keys'   => [ '470', '471' ],
            'province'      => 'Forl�-Cesena',
            'province_code' => 'IT-FC'
        },
        {
            'region'        => 'Emilia-Romagna',
            'lookup_keys'   => [ '440', '441' ],
            'province'      => 'Ferrara',
            'province_code' => 'IT-FE'
        },
        {
            'region'        => 'Apulia',
            'lookup_keys'   => [ '710', '711' ],
            'province'      => 'Foggia',
            'province_code' => 'IT-FG'
        },
        {
            'region'        => 'Tuscany',
            'lookup_keys'   => [ '500', '501' ],
            'province'      => 'Florence',
            'province_code' => 'IT-FI'
        },
        {
            'region'        => 'Marche',
            'lookup_keys'   => [ '638', '639' ],
            'province'      => 'Fermo',
            'province_code' => 'IT-FM'
        },
        {
            'region'        => 'Lazio',
            'lookup_keys'   => [ '030', '031' ],
            'province'      => 'Frosinone',
            'province_code' => 'IT-FR'
        },
        {
            'region'        => 'Liguria',
            'lookup_keys'   => [ '160', '161' ],
            'province'      => 'Genoa',
            'province_code' => 'IT-GE'
        },
        {
            'region'        => 'Friuli-Venezia Giulia',
            'function'      => sub { $_ == 34170 && ($_ >= 34070 && $_ <= 34079) },
            'lookup_keys'   => [ '340', '341' ],
            'province'      => 'Gorizia',
            'province_code' => 'IT-GO'
        },
        {
            'region'        => 'Tuscany',
            'lookup_keys'   => [ '580', '581' ],
            'province'      => 'Grosseto',
            'province_code' => 'IT-GR'
        },
        {
            'region'        => 'Liguria',
            'lookup_keys'   => [ '180', '181' ],
            'province'      => 'Imperia',
            'province_code' => 'IT-IM'
        },
        {
            'region'        => 'Molise',
            'function'      => sub { $_ == 86170 || ($_ >= 86070 && $_ <= 86097) },
            'lookup_keys'   => [ '860', '861' ],
            'province'      => 'Isernia',
            'province_code' => 'IT-IS'
        },
        {
            'region'        => 'Calabria',
            'lookup_keys'   => [ '888', '889' ],
            'province'      => 'Crotone',
            'province_code' => 'IT-KR'
        },
        {
            'region'        => 'Lombardy',
            'lookup_keys'   => [ '238', '239' ],
            'province'      => 'Lecco',
            'province_code' => 'IT-LC'
        },
        {
            'region'        => 'Apulia',
            'lookup_keys'   => [ '730', '731' ],
            'province'      => 'Lecce',
            'province_code' => 'IT-LE'
        },
        {
            'region'        => 'Tuscany',
            'comment'       => 'Province could also be Leghorn',
            'lookup_keys'   => [ '570', '571' ],
            'province'      => 'Livorno',
            'province_code' => 'IT-LI'
        },
        {
            'region'        => 'Lombardy',
            'lookup_keys'   => [ '268', '269' ],
            'province'      => 'Lodi',
            'province_code' => 'IT-LO'
        },
        {
            'region'        => 'Lazio',
            'lookup_keys'   => [ '040', '041' ],
            'province'      => 'Latina',
            'province_code' => 'IT-LT'
        },
        {
            'region'        => 'Tuscany',
            'lookup_keys'   => [ '550', '551' ],
            'province'      => 'Lucca',
            'province_code' => 'IT-LU'
        },
        {
            'region'        => 'Lombardy',
            'lookup_keys'   => [ '208', '209' ],
            'province'      => 'Monza & Brianza',
            'province_code' => 'IT-MB'
        },
        {
            'region'        => 'Marche',
            'lookup_keys'   => [ '620', '621' ],
            'province'      => 'Macerata',
            'province_code' => 'IT-MC'
        },
        {
            'region'        => 'Sardinia',
            'function'      => sub { $_ >= 9020 && $_ <= 9041 },
            'comment'       => 'Provisional code MD modified in VS from December 2006.',
            'lookup_keys'   => [ '090' ],
            'province'      => 'Medio Campidano',
            'province_code' => 'IT-MD',
        },
        {
            'region'        => 'Sicily',
            'lookup_keys'   => [ '980', '981' ],
            'province'      => 'Messina',
            'province_code' => 'IT-ME'
        },
        {
            'region'        => 'Lombardy',
            'lookup_keys'   => [ '200', '201' ],
            'province'      => 'Milan',
            'province_code' => 'IT-MI'
        },
        {
            'region'        => 'Lombardy',
            'lookup_keys'   => [ '460', '461' ],
            'province'      => 'Mantua',
            'province_code' => 'IT-MN'
        },
        {
            'region'        => 'Emilia-Romagna',
            'lookup_keys'   => [ '410', '411' ],
            'province'      => 'Modena',
            'province_code' => 'IT-MO'
        },
        {
            'region'        => 'Tuscany',
            'lookup_keys'   => [ '541', '750' ],
            'province'      => 'Massa-Carrara',
            'province_code' => 'IT-MS'
        },
        {
            'region'        => 'Basilicata',
            'lookup_keys'   => [ '751', '80750' ],
            'province'      => 'Matera',
            'province_code' => 'IT-MT'
        },
        {
            'region'        => 'Campania',
            'lookup_keys'   => [ '800', '801' ],
            'province'      => 'Naples',
            'province_code' => 'IT-NA'
        },
        {
            'region'        => 'Piedmont',
            'lookup_keys'   => [ '280', '281' ],
            'province'      => 'Novara',
            'province_code' => 'IT-NO'
        },
        {
            'region'        => 'Sardinia',
            'function'      => sub { $_ == 8100 || $_ == 8012 || ($_ >= 8014 && $_ <= 8018) || ($_ >= 8021 && $_ <= 8029) || ($_ >= 8031 && $_ <= 8032) || ($_ >= 8036 && $_ <= 8039) },
            'lookup_keys'   => [ '080', '081' ],
            'province'      => 'Nuoro',
            'province_code' => 'IT-NU',
            'comment'       => 'Removed 08010, 08013, 08019, 08020 and 08034 as these conflict with Oristano, and 08030, 08033 and 08035 as these conflict with Cagliari',
        },
        {
            'region'        => 'Sardinia',
            'function'      => sub { $_ >= 8040 && $_ <= 8049 && $_ != 8043 },
            'lookup_keys'   => [ '080' ],
            'province'      => 'Ogliastra',
            'province_code' => 'IT-OG',
            'comment'       => 'Removed 08043 because it conflicts with Cagliari',
        },
        {
            'region'        => 'Sardinia',
            'function'      => sub { $_ == 9170 || ($_ >= 9070 && $_ <= 9099) || $_ == 8010 || $_ == 8013 || $_ == 8019 || $_ == 8034 },
            'lookup_keys'   => [ '080', '090', '091' ],
            'province'      => 'Oristano',
            'province_code' => 'IT-OR',
            'comment'       => 'Remove 08030 because this conflicts with Cagliari',
        },
        {
            'region'        => 'Sardinia',
            'function'      => sub { ($_ >= 7020 && $_ <= 7029) || $_ == 8020 },
            'lookup_keys'   => [ '070', '080' ],
            'province'      => 'Olbia-Tempio',
            'province_code' => 'IT-OT'
        },
        {
            'region'        => 'Sicily',
            'lookup_keys'   => [ '900', '901' ],
            'province'      => 'Palermo',
            'province_code' => 'IT-PA'
        },
        {
            'region'        => 'Emilia-Romagna',
            'lookup_keys'   => [ '290', '291' ],
            'province'      => 'Piacenza',
            'province_code' => 'IT-PC'
        },
        {
            'region'        => 'Veneto',
            'lookup_keys'   => [ '350', '351' ],
            'province'      => 'Padua',
            'province_code' => 'IT-PD'
        },
        {
            'region'        => 'Abruzzo',
            'lookup_keys'   => [ '650', '651' ],
            'province'      => 'Pescara',
            'province_code' => 'IT-PE'
        },
        {
            'region'        => 'Umbria',
            'lookup_keys'   => [ '060', '061' ],
            'province'      => 'Perugia',
            'province_code' => 'IT-PG'
        },
        {
            'region'        => 'Tuscany',
            'lookup_keys'   => [ '560', '561' ],
            'province'      => 'Pisa',
            'province_code' => 'IT-PI'
        },
        {
            'region'        => 'Friuli-Venezia Giulia',
            'function'      => sub { $_ == 33170 || ($_ >= 33070 && $_ <= 33099) },
            'lookup_keys'   => [ '330', '331' ],
            'province'      => 'Pordenone',
            'province_code' => 'IT-PN'
        },
        {
            'region'        => 'Tuscany',
            'lookup_keys'   => [ '590', '591' ],
            'province'      => 'Prato',
            'province_code' => 'IT-PO'
        },
        {
            'region'        => 'Emilia-Romagna',
            'lookup_keys'   => [ '430', '431' ],
            'province'      => 'Parma',
            'province_code' => 'IT-PR'
        },
        {
            'region'        => 'Tuscany',
            'lookup_keys'   => [ '510', '511' ],
            'province'      => 'Pistoia',
            'province_code' => 'IT-PT'
        },
        {
            'region'        => 'Marche',
            'lookup_keys'   => [ '610', '611' ],
            'province'      => 'Pesaro e Urbino',
            'province_code' => 'IT-PU'
        },
        {
            'region'        => 'Lombardy',
            'lookup_keys'   => [ '270', '271' ],
            'province'      => 'Pavia',
            'province_code' => 'IT-PV'
        },
        {
            'region'        => 'Basilicata',
            'lookup_keys'   => [ '850', '851' ],
            'province'      => 'Potenza',
            'province_code' => 'IT-PZ'
        },
        {
            'region'        => 'Emilia-Romagna',
            'lookup_keys'   => [ '480', '481' ],
            'province'      => 'Ravenna',
            'province_code' => 'IT-RA'
        },
        {
            'region'        => 'Calabria',
            'lookup_keys'   => [ '890', '891' ],
            'province'      => 'Reggio Calabria',
            'province_code' => 'IT-RC'
        },
        {
            'region'        => 'Emilia-Romagna',
            'lookup_keys'   => [ '420', '421' ],
            'province'      => 'Reggio Emilia',
            'province_code' => 'IT-RE'
        },
        {
            'region'        => 'Sicily',
            'lookup_keys'   => [ '970', '971' ],
            'province'      => 'Ragusa',
            'province_code' => 'IT-RG'
        },
        {
            'region'        => 'Lazio',
            'lookup_keys'   => [ '020', '021' ],
            'province'      => 'Rieti',
            'province_code' => 'IT-RI'
        },
        {
            'region'        => 'Lazio',
            'function'      => sub { ($_ >= 118 && $_ <= 119) || ($_ >= 121 && $_ <= 199) || ($_ >= 10 && $_ <= 69) },
            'lookup_keys'   => [ '000', '001' ],
            'province'      => 'Rome',
            'province_code' => 'IT-RM'
        },
        {
            'region'        => 'Emilia-Romagna',
            'function'      => sub { ($_ >= 47921 && $_ <= 47924) || ($_ >= 47814 && $_ <= 47866) },
            'lookup_keys'   => [ '478', '479' ],
            'province'      => 'Rimini',
            'province_code' => 'IT-RN'
        },
        {
            'region'        => 'Veneto',
            'lookup_keys'   => [ '450', '451' ],
            'province'      => 'Rovigo',
            'province_code' => 'IT-RO'
        },
        {
            'region'        => '-',
            'function'      => sub { $_ >= 47890 && $_ <= 47899 },
            'lookup_keys'   => [ '478' ],
            'province'      => 'Republic of San Marino',
            'province_code' => 'IT-RSM'
        },
        {
            'region'        => 'Campania',
            'lookup_keys'   => [ '840', '841' ],
            'province'      => 'Salerno',
            'province_code' => 'IT-SA'
        },
        {
            'region'        => '-',
            'function'      => sub { $_ == 120 },
            'lookup_keys'   => [ '001' ],
            'province'      => 'Vatican City',
            'province_code' => 'IT-SCV'
        },
        {
            'region'        => 'Tuscany',
            'lookup_keys'   => [ '530', '531' ],
            'province'      => 'Siena',
            'province_code' => 'IT-SI'
        },
        {
            'region'        => 'Lombardy',
            'lookup_keys'   => [ '230', '231' ],
            'province'      => 'Sondrio',
            'province_code' => 'IT-SO'
        },
        {
            'region'        => 'Liguria',
            'lookup_keys'   => [ '190', '191' ],
            'province'      => 'La Spezia',
            'province_code' => 'IT-SP'
        },
        {
            'region'        => 'Sicily',
            'lookup_keys'   => [ '960', '961' ],
            'province'      => 'Syracuse',
            'province_code' => 'IT-SR'
        },
        {
            'region'        => 'Sardinia',
            'function'      => sub { $_ == 7100 || ($_ >= 7010 && $_ <= 7019) || ($_ >= 7030 && $_ <= 7049) },
            'lookup_keys'   => [ '070', '071' ],
            'province'      => 'Sassari',
            'province_code' => 'IT-SS'
        },
        {
            'region'        => 'Liguria',
            'lookup_keys'   => [ '170', '171' ],
            'province'      => 'Savona',
            'province_code' => 'IT-SV'
        },
        {
            'region'        => 'Apulia',
            'lookup_keys'   => [ '740', '741' ],
            'province'      => 'Taranto',
            'province_code' => 'IT-TA'
        },
        {
            'region'        => 'Abruzzo',
            'lookup_keys'   => [ '640', '641' ],
            'province'      => 'Teramo',
            'province_code' => 'IT-TE'
        },
        {
            'region'        => 'Trentino-Alto Adige/Südtirol',
            'lookup_keys'   => [ '380', '381' ],
            'province'      => 'Trento',
            'province_code' => 'IT-TN'
        },
        {
            'region'        => 'Piedmont',
            'lookup_keys'   => [ '100', '101' ],
            'province'      => 'Turin',
            'province_code' => 'IT-TO'
        },
        {
            'region'        => 'Sicily',
            'lookup_keys'   => [ '910', '911' ],
            'province'      => 'Trapani',
            'province_code' => 'IT-TP'
        },
        {
            'region'        => 'Umbria',
            'lookup_keys'   => [ '050', '051' ],
            'province'      => 'Terni',
            'province_code' => 'IT-TR'
        },
        {
            'region'        => 'Friuli-Venezia Giulia',
            'function'      => sub { ($_ >= 34121 && $_ <= 34151) || ($_ >= 34010 && $_ <= 34018) },
            'lookup_keys'   => [ '340', '341' ],
            'province'      => 'Trieste',
            'province_code' => 'IT-TS'
        },
        {
            'region'        => 'Veneto',
            'lookup_keys'   => [ '310', '311' ],
            'province'      => 'Treviso',
            'province_code' => 'IT-TV'
        },
        {
            'region'        => 'Friuli-Venezia Giulia',
            'function'      => sub { $_ == 33100 || ($_ >= 33010 && $_ <= 33059) },
            'lookup_keys'   => [ '330', '331' ],
            'province'      => 'Udine',
            'province_code' => 'IT-UD'
        },
        {
            'region'        => 'Lombardy',
            'lookup_keys'   => [ '210', '211' ],
            'province'      => 'Varese',
            'province_code' => 'IT-VA'
        },
        {
            'region'        => 'Piedmont',
            'lookup_keys'   => [ '288', '289' ],
            'province'      => 'Verbano-Cusio-Ossola',
            'province_code' => 'IT-VB'
        },
        {
            'region'        => 'Piedmont',
            'lookup_keys'   => [ '130', '131' ],
            'province'      => 'Vercelli',
            'province_code' => 'IT-VC'
        },
        {
            'region'        => 'Veneto',
            'lookup_keys'   => [ '300', '301' ],
            'province'      => 'Venice',
            'province_code' => 'IT-VE'
        },
        {
            'region'        => 'Veneto',
            'lookup_keys'   => [ '360', '361' ],
            'province'      => 'Vicenza',
            'province_code' => 'IT-VI'
        },
        {
            'region'        => 'Veneto',
            'lookup_keys'   => [ '370', '371' ],
            'province'      => 'Verona',
            'province_code' => 'IT-VR'
        },
        {
            'region'        => 'Lazio',
            'lookup_keys'   => [ '010', '011' ],
            'province'      => 'Viterbo',
            'province_code' => 'IT-VT'
        },
        {
            'region'        => 'Calabria',
            'lookup_keys'   => [ '898', '899' ],
            'province'      => 'Vibo Valentia',
            'province_code' => 'IT-VV'
        },
    ];
    my %geo_regions = (
        # Take from https://en.wikipedia.org/wiki/ISO_3166-2:IT
        'it' => {
            'Abruzzo' => 'IT-65',
            'Basilicata' => 'IT-77',
            'Calabria' => 'IT-78',
            'Campania' => 'IT-72',
            'Emilia-Romagna' => 'IT-45',
            'Friuli-Venezia Giulia' => 'IT-36',
            'Lazio' => 'IT-62',
            'Liguria' => 'IT-42',
            'Lombardy' => 'IT-25',
            'Marche' => 'IT-57',
            'Molise' => 'IT-67',
            'Piedmont' => 'IT-21',
            'Apulia' => 'IT-75',
            'Sardinia' => 'IT-88',
            'Sicily' => 'IT-82',
            'Tuscany' => 'IT-52',
            'Trentino-Alto Adige/Südtirol' => 'IT-32',
            'Umbria' => 'IT-55',
            'Aosta Valley' => 'IT-23',
            'Veneto' => 'IT-34',
            '-' => '-', # For the Vatican and San Marino
        },
    );


    %lookup_table = ();
    for my $country (keys %geo_provinces) {
        my $rh_lookup = $lookup_table{$country} = {};
        for my $rh_geo_entry (@{ $geo_provinces{$country} }) {
            $rh_geo_entry->{region_code} = $geo_regions{$country}{$rh_geo_entry->{region}};
            for my $key (@{ $rh_geo_entry->{lookup_keys} }) {
                $rh_lookup->{$key} //= [];
                push @{ $rh_lookup->{$key} }, $rh_geo_entry;
            }
        }

    }

}

sub _test_check_lookup_table {
    # This test is written here, instead of in a .t file, as only it has access
    # to the private variable %lookup_table
    require Test::More;
    for my $country (sort keys %lookup_table) {
        my $rh_lookup = $lookup_table{$country};
        for my $key (sort keys %$rh_lookup) {
            if (@{ $rh_lookup->{$key} } >= 2) {
                if (! _all(sub { $_->{function} }, @{ $rh_lookup->{$key} })) {
                    my $provinces_string = join(", ",
                        map { $_->{province} } @{ $rh_lookup->{$key} }
                    );
                    Test::More::fail("Lookup key '$key' in country $country has multiple provinces $provinces_string but missing functions to distinguish between them. ");
                }
            }
        }
    }
}

sub _all {
    my $rc_sub = shift;
    for (@_) {
        return 0 if ! $rc_sub->();
    }
    return 1;
}

BEGIN {
    _build_data();
}


# --------------------------

=head1 AUTHOR

David D Lowe, C<< <daviddlowe.flimm at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-geo-postcodetoprovince at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Geo-LookupPostcode>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.






=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Geo::LookupPostcode


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Geo-LookupPostcode>

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
