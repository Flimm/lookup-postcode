use 5.012;
use strict;
use warnings FATAL => 'all';
use utf8;

use Test::More;
use Geo::LookupPostcode::ES qw(lookup_es_postcode);

binmode Test::More->builder->output, ":encoding(UTF-8)";
binmode Test::More->builder->failure_output, ":encoding(UTF-8)";
binmode Test::More->builder->todo_output, ":encoding(UTF-8)";


is_deeply(
    lookup_es_postcode("03460"),
    { province_name => 'Beneixama' },
    "Beneixama postcode"
);

is(lookup_es_postcode("xecroedgs"), undef, "Weird postcode gives undef");

my $truthy_return_value_count = 0;

for my $i (1..99_999) {
    my $postcode = sprintf("%05d", $i);
    my $rv = lookup_es_postcode($postcode);
    if ($rv) {
        ok($rv->{province_name}, "rv for $postcode includes province_name");
        $truthy_return_value_count++;
    }
}

cmp_ok($truthy_return_value_count, '>=', 100, "At least 100 postcodes give a result");

done_testing();
