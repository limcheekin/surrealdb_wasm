docker run --rm --pull always -p 8000:8000 --name surrealdb surrealdb/surrealdb:latest start memory -A --user root --pass root &
flutter drive --driver=test_driver/integration_test.dart --target integration_test/all_tests.dart -d web-server --release --browser-name=chrome
docker container stop surrealdb