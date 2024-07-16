surreal start memory --allow-all --auth --user root --pass root &
flutter drive --driver=test_driver/integration_test.dart --target integration_test/all_tests.dart -d chrome --debug
killall surreal