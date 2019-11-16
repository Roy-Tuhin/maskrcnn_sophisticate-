for i in `find . -type f -name "*.java" -exec grep -l "db.properties" {} \;`
do
	ls -l $i
done
