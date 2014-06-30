#!/bin/bash
dom=$1
[ -z "$dom" ] && { echo missing textdomain; exit 1 ; }
[ -d po ] && pushd po
i=1
for f in ??.po ??_??.po; do
  [ -f $f ] || continue
  r=${dom}.$f
  all[$i]=$r
  l[$i]=${f%.po}
  echo -n "$((i++)) "
  mv $f ../$r
done
popd
echo ${all[*]}
echo ${l[*]}
exit 0

