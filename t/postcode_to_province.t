use 5.006;
use strict;
use warnings FATAL => 'all';
use utf8;

use Test::More;
use Geo::PostcodeToProvince qw(postcode_to_province);

is_deeply(
    postcode_to_province("it", "00118"),
    { region_code => 'IT-62', province_code => 'IT-RM' },
    "Rome postcode, scalar context"
);
is_deeply(
    [postcode_to_province("it", "00118")], 
    [{ region_code => 'IT-62', province_code => 'IT-RM' }],
    "Rome postcode, list context"
);

is(postcode_to_province("it", "xecroedgs"), undef, "Weird postcode gives undef");

done_testing();
