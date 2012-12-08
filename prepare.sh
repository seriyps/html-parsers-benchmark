
tests="erlang python pypy"

for tst in $tests; do
    cd $tst
    ./prepare.sh
    cd ../
done
