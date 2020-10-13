export PGPASSWORD='testPassword'; pg_dump -h localhost -p 5432 -U test -d test -f sql/test.sql
export PGPASSWORD='qaPassword'; pg_dump -h localhost -p 5432 -U qa -d qa -f sql/qa.sql
mkdir -p test-results/cucumber
# cp *.json /home/qa/test-results/
mkdir -p artifact
cp sql/*.sql artifact/
cp report/* artifact/