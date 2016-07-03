use 5.006;
use strict;
use warnings FATAL => 'all';
use utf8;

use Test::More;
use Geo::PostcodeToProvince qw(postcode_to_province);

is(postcode_to_province("it", "00118"), "Rome", "Rome postcode, scalar context");
is_deeply([postcode_to_province("it", "00118")], ["Rome"], "Rome postcode, list context");

is(postcode_to_province("it", "xecroedgs"), undef, "Weird postcode gives undef");

done_testing();
