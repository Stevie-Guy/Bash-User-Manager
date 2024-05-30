
echo "  __"
echo "o-''|\___/)"
echo " \/|)     )"
echo "   |  _  /"
echo "   (/  (/"
if [ $# -gt 0 ]; then
  echo "Dog says: $*"
else
  echo "Dog says: $(fortune)"
fi
