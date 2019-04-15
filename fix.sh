for f in $1/*; do
  sed -i -E 's/([\,]\"X[0-9]+\"[\,]*){2}$//1' $f
done
