pwd;
export PGPASSWORD='qaPassword'; psql -h localhost -p 5432 -U qa qa < sql/qa.sql
psql -h localhost -p 5432 -U qa -c "CREATE USER test WITH PASSWORD 'testPassword'";
psql -h localhost -p 5432 -U qa -c "CREATE DATABASE test;"
psql -h localhost -p 5432 -U qa -c "GRANT ALL PRIVILEGES ON DATABASE test to test;"
export PGPASSWORD='testPassword'; psql -h localhost -p 5432 -U test test < sql/test.sql
echo "127.0.0.1 qa.api.test api.test" | sudo tee -a /etc/hosts;