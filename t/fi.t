use 5.012;
use strict;
use warnings FATAL => 'all';
use utf8;

use Test::More;
use Geo::LookupPostcode::FI qw(lookup_fi_postcode);

binmode Test::More->builder->output, ":encoding(UTF-8)";
binmode Test::More->builder->failure_output, ":encoding(UTF-8)";
binmode Test::More->builder->todo_output, ":encoding(UTF-8)";

is_deeply(
    lookup_fi_postcode("01430"),
    { area_name => 'Vantaa' },
    "Vantaa postcode"
);

is(lookup_fi_postcode("xecroedgs"), undef, "Weird postcode gives undef");

my $truthy_return_value_count = 0;

for my $i (1..99_999) {
    my $postcode = sprintf("%05d", $i);
    my $rv = lookup_fi_postcode($postcode);
    if ($rv) {
        ok($rv->{area_name}, "rv for $postcode includes area_name");
        $truthy_return_value_count++;
    }
}

cmp_ok($truthy_return_value_count, '>=', 100, "At least 100 postcodes give a result");

done_testing();
