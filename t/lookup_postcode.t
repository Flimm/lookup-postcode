use 5.012;
use strict;
use warnings FATAL => 'all';
use utf8;

use Test::More;
use Geo::LookupPostcode qw(lookup_postcode);

binmode Test::More->builder->output, ":encoding(UTF-8)";
binmode Test::More->builder->failure_output, ":encoding(UTF-8)";
binmode Test::More->builder->todo_output, ":encoding(UTF-8)";


is_deeply(
    lookup_postcode("it", "00118"),
    { region_code => 'IT-62', province_code => 'IT-RM' },
    "Rome postcode, scalar context"
);
is_deeply(
    [lookup_postcode("it", "00118")], 
    [{ region_code => 'IT-62', province_code => 'IT-RM' }],
    "Rome postcode, list context"
);

is(lookup_postcode("it", "xecroedgs"), undef, "Weird postcode gives undef");

my $truthy_return_value_count = 0;

for my $i (1..99_999) {
    my $postcode = sprintf("%05d", $i);
    my $rv = lookup_postcode("it", $postcode);
    if ($rv) {
        ok($rv->{region_code}, "rv for $postcode includes region_code");
        ok($rv->{province_code}, "rv for $postcode includes province_code");
        $truthy_return_value_count++;
    }
}

cmp_ok($truthy_return_value_count, '>=', 100, "At least 100 postcodes give a result");

done_testing();
