# @date: 2012-12-26
# @author: Roman Bogatov

use Mojo::DOM ;
use Time::HiRes qw/time/ ;

$f=`cat $ARGV[0]`;
$s=time();
Mojo::DOM->new($f) for 1..$ARGV[1];
print time()-$s, " s\n"

