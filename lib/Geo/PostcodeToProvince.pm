package Geo::PostcodeToProvince;

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

Geo::PostcodeToProvince - Get a province name for a given postcode

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

Given a country name and a postcode, get the name of the province.

    use Geo::PostcodeToProvince qw(postcode_to_province);

    my $province = postcode_to_province("it", "00118");
    # $province is now "Rome"

=head1 Supported countries

=over 12

=item Italy

This includes the Vatican.

=back

=head1 SUBROUTINES/METHODS

=head2 postcode_to_province

Takes two character string arguments, the first one being a two-letter ISO
3166-1 country code, and the second one being a postcode in that country.

It returns the name of the province of that postcode if it can find it, or
undef if not. Note that the names may be anglicised (eg: "Vatican City", not
"Città del Vaticano").

This subroutine will die if the wrong number of arguments is passed or if an
unsupported country is passed.

    my $province = postcode_to_province("it", "00118");

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
            if ($rh_geo_entry->{function}()) {
                push @results, $rh_geo_entry;
            }
        }
        die "Found more than one province for postcode '$postcode'" if (@results > 1);
        return $results[0]{province} if @results == 1;
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
            'area'          => 'Sicily',
            'lookup_keys'   => [ '920', '921' ],
            'province'      => 'Agrigento',
            'province_code' => 'ag'
        },
        {
            'area'          => 'Piedmont',
            'lookup_keys'   => [ '150', '151' ],
            'province'      => 'Alessandria',
            'province_code' => 'al'
        },
        {
            'area'          => 'Marche',
            'lookup_keys'   => [ '600', '601' ],
            'province'      => 'Ancona',
            'province_code' => 'an'
        },
        {
            'area'          => 'Aosta Valley',
            'lookup_keys'   => [ '110', '111' ],
            'province'      => 'Aosta',
            'province_code' => 'ao'
        },
        {
            'area'          => 'Marche',
            'lookup_keys'   => [ '630', '631' ],
            'province'      => 'Ascoli Piceno',
            'province_code' => 'ap'
        },
        {
            'area'          => 'Abruzzo',
            'lookup_keys'   => [ '670', '671' ],
            'province'      => 'L\'Aquila',
            'province_code' => 'aq'
        },
        {
            'area'          => 'Tuscany',
            'lookup_keys'   => [ '520', '521' ],
            'province'      => 'Arezzo',
            'province_code' => 'ar'
        },
        {
            'area'          => 'Piedmont',
            'lookup_keys'   => [ '140', '141' ],
            'province'      => 'Asti',
            'province_code' => 'at'
        },
        {
            'area'          => 'Campania',
            'lookup_keys'   => [ '830', '831' ],
            'province'      => 'Avellino',
            'province_code' => 'av'
        },
        {
            'area'          => 'Apulia',
            'lookup_keys'   => [ '700', '701' ],
            'province'      => 'Bari',
            'province_code' => 'ba'
        },
        {
            'area'          => 'Lombardy',
            'lookup_keys'   => [ '240', '241' ],
            'province'      => 'Bergamo',
            'province_code' => 'bg'
        },
        {
            'area'          => 'Piedmont',
            'lookup_keys'   => [ '138', '139' ],
            'province'      => 'Biella',
            'province_code' => 'bi'
        },
        {
            'area'          => 'Veneto',
            'lookup_keys'   => [ '320', '321' ],
            'province'      => 'Belluno',
            'province_code' => 'bl'
        },
        {
            'area'          => 'Campania',
            'comment'       => 'Province could also be Beneventum',
            'lookup_keys'   => [ '820', '821' ],
            'province'      => 'Benevento',
            'province_code' => 'bn'
        },
        {
            'area'          => 'Emilia-Romagna',
            'lookup_keys'   => [ '400', '401' ],
            'province'      => 'Bologna',
            'province_code' => 'bo'
        },
        {
            'area'          => 'Apulia',
            'lookup_keys'   => [ '720', '721' ],
            'province'      => 'Brindisi',
            'province_code' => 'br'
        },
        {
            'area'          => 'Lombardy',
            'lookup_keys'   => [ '250', '251' ],
            'province'      => 'Brescia',
            'province_code' => 'bs'
        },
        {
            'area'          => 'Apulia',
            'lookup_keys'   => [ '760', '761' ],
            'province'      => 'Barletta-Andria-Trani',
            'province_code' => 'bt'
        },
        {
            'area'          => 'Trentino-Alto Adige/S�dtirol',
            'lookup_keys'   => [ '390', '391' ],
            'province'      => 'Bolzano/Bozen',
            'province_code' => 'bz'
        },
        {
            'area'          => 'Sardinia',
            'function'      => sub { ($_ >= 9121 && $_ <= 9134) || ($_ >= 9010 && $_ <= 9049) || $_ == 8030 || $_ == 8033 || $_ == 8035 || $_ == 8043 },
            'lookup_keys'   => [ '080', '090', '091' ],
            'province'      => 'Cagliari',
            'province_code' => 'ca'
        },
        {
            'area'          => 'Molise',
            'function'      => sub { $_ == 86100 || ($_ >= 86010 && $_ <= 86049) },
            'lookup_keys'   => [ '860', '861' ],
            'province'      => 'Campobasso',
            'province_code' => 'cb'
        },
        {
            'area'          => 'Campania',
            'lookup_keys'   => [ '810', '811' ],
            'province'      => 'Caserta',
            'province_code' => 'ce'
        },
        {
            'area'          => 'Abruzzo',
            'lookup_keys'   => [ '660', '661' ],
            'province'      => 'Chieti',
            'province_code' => 'ch'
        },
        {
            'area'          => 'Sardinia',
            'function'      => sub { $_ >= 9010 && $_ <= 9017 },
            'lookup_keys'   => [ '090' ],
            'province'      => 'Carbonia-Iglesias',
            'province_code' => 'ci'
        },
        {
            'area'          => 'Sicily',
            'lookup_keys'   => [ '930', '931' ],
            'province'      => 'Caltanissetta',
            'province_code' => 'cl'
        },
        {
            'area'          => 'Piedmont',
            'lookup_keys'   => [ '120', '121' ],
            'province'      => 'Cuneo',
            'province_code' => 'cn'
        },
        {
            'area'          => 'Lombardy',
            'lookup_keys'   => [ '220', '221' ],
            'province'      => 'Como',
            'province_code' => 'co'
        },
        {
            'area'          => 'Lombardy',
            'lookup_keys'   => [ '260', '261' ],
            'province'      => 'Cremona',
            'province_code' => 'cr'
        },
        {
            'area'          => 'Calabria',
            'lookup_keys'   => [ '870', '871' ],
            'province'      => 'Cosenza',
            'province_code' => 'cs'
        },
        {
            'area'          => 'Sicily',
            'lookup_keys'   => [ '950', '951' ],
            'province'      => 'Catania',
            'province_code' => 'ct'
        },
        {
            'area'          => 'Calabria',
            'lookup_keys'   => [ '880', '881' ],
            'province'      => 'Catanzaro',
            'province_code' => 'cz'
        },
        {
            'area'          => 'Sicily',
            'lookup_keys'   => [ '940', '941' ],
            'province'      => 'Enna',
            'province_code' => 'en'
        },
        {
            'area'          => 'Emilia-Romagna',
            'lookup_keys'   => [ '470', '471' ],
            'province'      => 'Forl�-Cesena',
            'province_code' => 'fc'
        },
        {
            'area'          => 'Emilia-Romagna',
            'lookup_keys'   => [ '440', '441' ],
            'province'      => 'Ferrara',
            'province_code' => 'fe'
        },
        {
            'area'          => 'Apulia',
            'lookup_keys'   => [ '710', '711' ],
            'province'      => 'Foggia',
            'province_code' => 'fg'
        },
        {
            'area'          => 'Tuscany',
            'lookup_keys'   => [ '500', '501' ],
            'province'      => 'Florence',
            'province_code' => 'fi'
        },
        {
            'area'          => 'Marche',
            'lookup_keys'   => [ '638', '639' ],
            'province'      => 'Fermo',
            'province_code' => 'fm'
        },
        {
            'area'          => 'Lazio',
            'lookup_keys'   => [ '030', '031' ],
            'province'      => 'Frosinone',
            'province_code' => 'fr'
        },
        {
            'area'          => 'Liguria',
            'lookup_keys'   => [ '160', '161' ],
            'province'      => 'Genoa',
            'province_code' => 'ge'
        },
        {
            'area'          => 'Friuli-Venezia Giulia',
            'function'      => sub { $_ == 34170 && ($_ >= 34070 && $_ <= 34079) },
            'lookup_keys'   => [ '340', '341' ],
            'province'      => 'Gorizia',
            'province_code' => 'go'
        },
        {
            'area'          => 'Tuscany',
            'lookup_keys'   => [ '580', '581' ],
            'province'      => 'Grosseto',
            'province_code' => 'gr'
        },
        {
            'area'          => 'Liguria',
            'lookup_keys'   => [ '180', '181' ],
            'province'      => 'Imperia',
            'province_code' => 'im'
        },
        {
            'area'          => 'Molise',
            'function'      => sub { $_ == 86170 || ($_ >= 86070 && $_ <= 86097) },
            'lookup_keys'   => [ '860', '861' ],
            'province'      => 'Isernia',
            'province_code' => 'is'
        },
        {
            'area'          => 'Calabria',
            'lookup_keys'   => [ '888', '889' ],
            'province'      => 'Crotone',
            'province_code' => 'kr'
        },
        {
            'area'          => 'Lombardy',
            'lookup_keys'   => [ '238', '239' ],
            'province'      => 'Lecco',
            'province_code' => 'lc'
        },
        {
            'area'          => 'Apulia',
            'lookup_keys'   => [ '730', '731' ],
            'province'      => 'Lecce',
            'province_code' => 'le'
        },
        {
            'area'          => 'Tuscany',
            'comment'       => 'Province could also be Leghorn',
            'lookup_keys'   => [ '570', '571' ],
            'province'      => 'Livorno',
            'province_code' => 'li'
        },
        {
            'area'          => 'Lombardy',
            'lookup_keys'   => [ '268', '269' ],
            'province'      => 'Lodi',
            'province_code' => 'lo'
        },
        {
            'area'          => 'Lazio',
            'lookup_keys'   => [ '040', '041' ],
            'province'      => 'Latina',
            'province_code' => 'lt'
        },
        {
            'area'          => 'Tuscany',
            'lookup_keys'   => [ '550', '551' ],
            'province'      => 'Lucca',
            'province_code' => 'lu'
        },
        {
            'area'          => 'Lombardy',
            'lookup_keys'   => [ '208', '209' ],
            'province'      => 'Monza & Brianza',
            'province_code' => 'mb'
        },
        {
            'area'          => 'Marche',
            'lookup_keys'   => [ '620', '621' ],
            'province'      => 'Macerata',
            'province_code' => 'mc'
        },
        {
            'area'          => 'Sardinia',
            'function'      => sub { $_ >= 9020 && $_ <= 9041 },
            'comment'       => 'Provisional code MD modified in VS from December 2006.',
            'lookup_keys'   => [ '090' ],
            'province'      => 'Medio Campidano',
            'province_code' => 'md',
        },
        {
            'area'          => 'Sicily',
            'lookup_keys'   => [ '980', '981' ],
            'province'      => 'Messina',
            'province_code' => 'me'
        },
        {
            'area'          => 'Lombardy',
            'lookup_keys'   => [ '200', '201' ],
            'province'      => 'Milan',
            'province_code' => 'mi'
        },
        {
            'area'          => 'Lombardy',
            'lookup_keys'   => [ '460', '461' ],
            'province'      => 'Mantua',
            'province_code' => 'mn'
        },
        {
            'area'          => 'Emilia-Romagna',
            'lookup_keys'   => [ '410', '411' ],
            'province'      => 'Modena',
            'province_code' => 'mo'
        },
        {
            'area'          => 'Tuscany',
            'lookup_keys'   => [ '541', '750' ],
            'province'      => 'Massa-Carrara',
            'province_code' => 'ms'
        },
        {
            'area'          => 'Basilicata',
            'lookup_keys'   => [ '751', '80750' ],
            'province'      => 'Matera',
            'province_code' => 'mt'
        },
        {
            'area'          => 'Campania',
            'lookup_keys'   => [ '800', '801' ],
            'province'      => 'Naples',
            'province_code' => 'na'
        },
        {
            'area'          => 'Piedmont',
            'lookup_keys'   => [ '280', '281' ],
            'province'      => 'Novara',
            'province_code' => 'no'
        },
        {
            'area'          => 'Sardinia',
            'function'      => sub { $_ == 8100 || ($_ >= 8010 && $_ <= 8039) },
            'lookup_keys'   => [ '080', '081' ],
            'province'      => 'Nuoro',
            'province_code' => 'nu'
        },
        {
            'area'          => 'Sardinia',
            'function'      => sub { $_ >= 8040 && $_ <= 8049 },
            'lookup_keys'   => [ '080' ],
            'province'      => 'Ogliastra',
            'province_code' => 'og'
        },
        {
            'area'          => 'Sardinia',
            'function'      => sub { $_ == 9170 || ($_ >= 9070 && $_ <= 9099) || $_ == 8010 || $_ == 8013 || $_ == 8019 || $_ == 8030 || $_ == 8034 },
            'lookup_keys'   => [ '080', '090', '091' ],
            'province'      => 'Oristano',
            'province_code' => 'or'
        },
        {
            'area'          => 'Sardinia',
            'function'      => sub { ($_ >= 7020 && $_ <= 7029) || $_ == 8020 },
            'lookup_keys'   => [ '070', '080' ],
            'province'      => 'Olbia-Tempio',
            'province_code' => 'ot'
        },
        {
            'area'          => 'Sicily',
            'lookup_keys'   => [ '900', '901' ],
            'province'      => 'Palermo',
            'province_code' => 'pa'
        },
        {
            'area'          => 'Emilia-Romagna',
            'lookup_keys'   => [ '290', '291' ],
            'province'      => 'Piacenza',
            'province_code' => 'pc'
        },
        {
            'area'          => 'Veneto',
            'lookup_keys'   => [ '350', '351' ],
            'province'      => 'Padua',
            'province_code' => 'pd'
        },
        {
            'area'          => 'Abruzzo',
            'lookup_keys'   => [ '650', '651' ],
            'province'      => 'Pescara',
            'province_code' => 'pe'
        },
        {
            'area'          => 'Umbria',
            'lookup_keys'   => [ '060', '061' ],
            'province'      => 'Perugia',
            'province_code' => 'pg'
        },
        {
            'area'          => 'Tuscany',
            'lookup_keys'   => [ '560', '561' ],
            'province'      => 'Pisa',
            'province_code' => 'pi'
        },
        {
            'area'          => 'Friuli-Venezia Giulia',
            'function'      => sub { $_ == 33170 || ($_ >= 33070 && $_ <= 33099) },
            'lookup_keys'   => [ '330', '331' ],
            'province'      => 'Pordenone',
            'province_code' => 'pn'
        },
        {
            'area'          => 'Tuscany',
            'lookup_keys'   => [ '590', '591' ],
            'province'      => 'Prato',
            'province_code' => 'po'
        },
        {
            'area'          => 'Emilia-Romagna',
            'lookup_keys'   => [ '430', '431' ],
            'province'      => 'Parma',
            'province_code' => 'pr'
        },
        {
            'area'          => 'Tuscany',
            'lookup_keys'   => [ '510', '511' ],
            'province'      => 'Pistoia',
            'province_code' => 'pt'
        },
        {
            'area'          => 'Marche',
            'lookup_keys'   => [ '610', '611' ],
            'province'      => 'Pesaro e Urbino',
            'province_code' => 'pu'
        },
        {
            'area'          => 'Lombardy',
            'lookup_keys'   => [ '270', '271' ],
            'province'      => 'Pavia',
            'province_code' => 'pv'
        },
        {
            'area'          => 'Basilicata',
            'lookup_keys'   => [ '850', '851' ],
            'province'      => 'Potenza',
            'province_code' => 'pz'
        },
        {
            'area'          => 'Emilia-Romagna',
            'lookup_keys'   => [ '480', '481' ],
            'province'      => 'Ravenna',
            'province_code' => 'ra'
        },
        {
            'area'          => 'Calabria',
            'lookup_keys'   => [ '890', '891' ],
            'province'      => 'Reggio Calabria',
            'province_code' => 'rc'
        },
        {
            'area'          => 'Emilia-Romagna',
            'lookup_keys'   => [ '420', '421' ],
            'province'      => 'Reggio Emilia',
            'province_code' => 're'
        },
        {
            'area'          => 'Sicily',
            'lookup_keys'   => [ '970', '971' ],
            'province'      => 'Ragusa',
            'province_code' => 'rg'
        },
        {
            'area'          => 'Lazio',
            'lookup_keys'   => [ '020', '021' ],
            'province'      => 'Rieti',
            'province_code' => 'ri'
        },
        {
            'area'          => 'Lazio',
            'function'      => sub { ($_ >= 118 && $_ <= 199) || ($_ >= 10 && $_ <= 69) },
            'lookup_keys'   => [ '000', '001' ],
            'province'      => 'Rome',
            'province_code' => 'rm'
        },
        {
            'area'          => 'Emilia-Romagna',
            'function'      => sub { ($_ >= 47921 && $_ <= 47924) || ($_ >= 47814 && $_ <= 47866) },
            'lookup_keys'   => [ '478', '479' ],
            'province'      => 'Rimini',
            'province_code' => 'rn'
        },
        {
            'area'          => 'Veneto',
            'lookup_keys'   => [ '450', '451' ],
            'province'      => 'Rovigo',
            'province_code' => 'ro'
        },
        {
            'area'          => '-',
            'function'      => sub { $_ >= 47890 && $_ <= 47899 },
            'lookup_keys'   => [ '478' ],
            'province'      => 'Republic of San Marino',
            'province_code' => 'rsm'
        },
        {
            'area'          => 'Campania',
            'lookup_keys'   => [ '840', '841' ],
            'province'      => 'Salerno',
            'province_code' => 'sa'
        },
        {
            'area'          => '-',
            'function'      => sub { $_ == 120 },
            'lookup_keys'   => [ '001' ],
            'province'      => 'Vatican City',
            'province_code' => 'scv'
        },
        {
            'area'          => 'Tuscany',
            'lookup_keys'   => [ '530', '531' ],
            'province'      => 'Siena',
            'province_code' => 'si'
        },
        {
            'area'          => 'Lombardy',
            'lookup_keys'   => [ '230', '231' ],
            'province'      => 'Sondrio',
            'province_code' => 'so'
        },
        {
            'area'          => 'Liguria',
            'lookup_keys'   => [ '190', '191' ],
            'province'      => 'La Spezia',
            'province_code' => 'sp'
        },
        {
            'area'          => 'Sicily',
            'lookup_keys'   => [ '960', '961' ],
            'province'      => 'Syracuse',
            'province_code' => 'sr'
        },
        {
            'area'          => 'Sardinia',
            'function'      => sub { $_ == 7100 || ($_ >= 7010 && $_ <= 7019) || ($_ >= 7030 || $_ <= 7049) },
            'lookup_keys'   => [ '070', '071' ],
            'province'      => 'Sassari',
            'province_code' => 'ss'
        },
        {
            'area'          => 'Liguria',
            'lookup_keys'   => [ '170', '171' ],
            'province'      => 'Savona',
            'province_code' => 'sv'
        },
        {
            'area'          => 'Apulia',
            'lookup_keys'   => [ '740', '741' ],
            'province'      => 'Taranto',
            'province_code' => 'ta'
        },
        {
            'area'          => 'Abruzzo',
            'lookup_keys'   => [ '640', '641' ],
            'province'      => 'Teramo',
            'province_code' => 'te'
        },
        {
            'area'          => 'Trentino-Alto Adige/S�dtirol',
            'lookup_keys'   => [ '380', '381' ],
            'province'      => 'Trento',
            'province_code' => 'tn'
        },
        {
            'area'          => 'Piedmont',
            'lookup_keys'   => [ '100', '101' ],
            'province'      => 'Turin',
            'province_code' => 'to'
        },
        {
            'area'          => 'Sicily',
            'lookup_keys'   => [ '910', '911' ],
            'province'      => 'Trapani',
            'province_code' => 'tp'
        },
        {
            'area'          => 'Umbria',
            'lookup_keys'   => [ '050', '051' ],
            'province'      => 'Terni',
            'province_code' => 'tr'
        },
        {
            'area'          => 'Friuli-Venezia Giulia',
            'function'      => sub { ($_ >= 34121 && $_ <= 34151) || ($_ >= 34010 && $_ <= 34018) },
            'lookup_keys'   => [ '340', '341' ],
            'province'      => 'Trieste',
            'province_code' => 'ts'
        },
        {
            'area'          => 'Veneto',
            'lookup_keys'   => [ '310', '311' ],
            'province'      => 'Treviso',
            'province_code' => 'tv'
        },
        {
            'area'          => 'Friuli-Venezia Giulia',
            'function'      => sub { $_ == 33100 || ($_ >= 33010 && $_ <= 33059) },
            'lookup_keys'   => [ '330', '331' ],
            'province'      => 'Udine',
            'province_code' => 'ud'
        },
        {
            'area'          => 'Lombardy',
            'lookup_keys'   => [ '210', '211' ],
            'province'      => 'Varese',
            'province_code' => 'va'
        },
        {
            'area'          => 'Piedmont',
            'lookup_keys'   => [ '288', '289' ],
            'province'      => 'Verbano-Cusio-Ossola',
            'province_code' => 'vb'
        },
        {
            'area'          => 'Piedmont',
            'lookup_keys'   => [ '130', '131' ],
            'province'      => 'Vercelli',
            'province_code' => 'vc'
        },
        {
            'area'          => 'Veneto',
            'lookup_keys'   => [ '300', '301' ],
            'province'      => 'Venice',
            'province_code' => 've'
        },
        {
            'area'          => 'Veneto',
            'lookup_keys'   => [ '360', '361' ],
            'province'      => 'Vicenza',
            'province_code' => 'vi'
        },
        {
            'area'          => 'Veneto',
            'lookup_keys'   => [ '370', '371' ],
            'province'      => 'Verona',
            'province_code' => 'vr'
        },
        {
            'area'          => 'Lazio',
            'lookup_keys'   => [ '010', '011' ],
            'province'      => 'Viterbo',
            'province_code' => 'vt'
        },
        {
            'area'          => 'Calabria',
            'lookup_keys'   => [ '898', '899' ],
            'province'      => 'Vibo Valentia',
            'province_code' => 'vv'
        },
    ];
	


    %lookup_table = ();
    for my $country (keys %geo_provinces) {
        my $rh_lookup = $lookup_table{$country} = {};
        for my $rh_geo_entry (@{ $geo_provinces{$country} }) {
            for my $key (@{ $rh_geo_entry->{lookup_keys} }) {
                $rh_lookup->{$key} //= [];
                push @{ $rh_lookup->{$key} }, $rh_geo_entry;
            }
        }

        # Do some error checking, we should probably move this out to a test:
        my $error_string;
        for my $key (sort keys %$rh_lookup) {
            if (@{ $rh_lookup->{$key} } >= 2) {
                if (! _all(sub { $_->{function} }, @{ $rh_lookup->{$key} })) {
                    print "$key\n";
                    my $provinces_string = join(", ",
                        map { $_->{province} } @{ $rh_lookup->{$key} }
                    );
                    $error_string = join(
                        "\n",
                        $error_string // (),
                        "Lookup key '$key' has multiple provinces $provinces_string but missing functions to distinguish between them. ",
                    );
                }
            }
        }
        die $error_string if $error_string;
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

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Geo::PostcodeToProvince


You can also look for information at:

=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2016 David D Lowe.

=cut

1; # End of Geo::PostcodeToProvince
