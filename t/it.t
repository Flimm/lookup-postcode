use 5.012;
use strict;
use warnings FATAL => 'all';
use utf8;

use Test::More;
use Geo::LookupPostcode::IT;

binmode Test::More->builder->output, ":encoding(UTF-8)";
binmode Test::More->builder->failure_output, ":encoding(UTF-8)";
binmode Test::More->builder->todo_output, ":encoding(UTF-8)";

Geo::LookupPostcode::IT::_test_check_lookup_table();

ok(1);

done_testing();
