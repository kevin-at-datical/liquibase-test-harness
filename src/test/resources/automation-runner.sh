#!/usr/bin/env bash

set -ex

db=$1

test_command () {
  $@
  exit 0
}

case $db in
  "mysql-5.6" )
    test_command mvn -ntp -Dtest=LiquibaseHarnessSuiteTest -DdbName=mysql -DdbVersion=5.6 test
    ;;
  "mysql-5.7" )
    test_command mvn -ntp -Dtest=LiquibaseHarnessSuiteTest -DdbName=mysql -DdbVersion=5.7 test
    ;;
  "mysql-8" )
    test_command mvn -ntp -Dtest=LiquibaseHarnessSuiteTest -DdbName=mysql -DdbVersion=8 test
    ;;
  "percona-xtradb-cluster-5.7" )
    test_command mvn -ntp -Dtest=LiquibaseHarnessSuiteTest -DdbName=percona-xtradb-cluster -DdbVersion=5.7 test
    ;;
  "percona-xtradb-cluster-8.0" )
    test_command mvn -ntp -Dtest=LiquibaseHarnessSuiteTest -DdbName=percona-xtradb-cluster -DdbVersion=8.0 test
    ;;
  "postgres-9.5" )
    test_command mvn -ntp -Dtest=LiquibaseHarnessSuiteTest -DdbName=postgresql -DdbVersion=9.5 test
    ;;
  "postgres-9" )
    test_command mvn -ntp -Dtest=LiquibaseHarnessSuiteTest -DdbName=postgresql -DdbVersion=9 test
    ;;
  "postgres-10" )
    test_command mvn -ntp -Dtest=LiquibaseHarnessSuiteTest -DdbName=postgresql -DdbVersion=10 test
    ;;
  "postgres-11" )
    test_command mvn -ntp -Dtest=LiquibaseHarnessSuiteTest -DdbName=postgresql -DdbVersion=11 test
    ;;
  "postgres-12" )
    test_command mvn -ntp -Dtest=LiquibaseHarnessSuiteTest -DdbName=postgresql -DdbVersion=12 test
    ;;
  "postgres-13" )
    test_command mvn -ntp -Dtest=LiquibaseHarnessSuiteTest -DdbName=postgresql -DdbVersion=13 test
    ;;
  "postgres-14" )
    test_command mvn -ntp -Dtest=LiquibaseHarnessSuiteTest -DdbName=postgresql -DdbVersion=14 test
    ;;
  "mariadb-10.2" )
    test_command mvn -ntp -Dtest=LiquibaseHarnessSuiteTest -DdbName=mariadb -DdbVersion=10.2 test
    ;;
  "mariadb-10.3" )
    test_command mvn -ntp -Dtest=LiquibaseHarnessSuiteTest -DdbName=mariadb -DdbVersion=10.3 test
    ;;
  "mariadb-10.4" )
    test_command mvn -ntp -Dtest=LiquibaseHarnessSuiteTest -DdbName=mariadb -DdbVersion=10.4 test
    ;;
  "mariadb-10.5" )
    test_command mvn -ntp -Dtest=LiquibaseHarnessSuiteTest -DdbName=mariadb -DdbVersion=10.5 test
    ;;
  "mariadb-10.6" )
    test_command mvn -ntp -Dtest=LiquibaseHarnessSuiteTest -DdbName=mariadb -DdbVersion=10.6 test
    ;;
    "mariadb-10.7" )
    test_command mvn -ntp -Dtest=LiquibaseHarnessSuiteTest -DdbName=mariadb -DdbVersion=10.7 test
    ;;
  "mssql-2017" )
    test_command mvn -ntp -Dtest=LiquibaseHarnessSuiteTest -DdbName=mssql -DdbVersion=2017 test
    ;;
  "mssql-2019" )
    test_command mvn -ntp -Dtest=LiquibaseHarnessSuiteTest -DdbName=mssql -DdbVersion=2019 test
    ;;
  "H2Database-2.1" )
    test_command mvn -ntp -Dtest=LiquibaseHarnessSuiteTest -DdbName=h2 test
    ;;
  "crdb-20.2" )
    test_command mvn -ntp -Dtest=LiquibaseHarnessSuiteTest -DdbName=cockroachdb -DdbVersion=20.2 test
    ;;
  "crdb-20.1" )
    test_command mvn -ntp -Dtest=LiquibaseHarnessSuiteTest -DdbName=cockroachdb -DdbVersion=20.1 test
    ;;
  "crdb-21.1" )
    test_command mvn -ntp -Dtest=LiquibaseHarnessSuiteTest -DdbName=cockroachdb -DdbVersion=21.1 test
    ;;
  "crdb-21.2" )
    test_command mvn -ntp -Dtest=LiquibaseHarnessSuiteTest -DdbName=cockroachdb -DdbVersion=21.2 test
    ;;
  "edb-9.5" )
    test_command mvn -ntp -Dtest=LiquibaseHarnessSuiteTest -DdbName=edb -DdbVersion=9.5 test
    ;;
  "edb-9.6" )
    test_command mvn -ntp -Dtest=LiquibaseHarnessSuiteTest -DdbName=edb -DdbVersion=9.6 test
    ;;
  "edb-10" )
    test_command mvn -ntp -Dtest=LiquibaseHarnessSuiteTest -DdbName=edb -DdbVersion=10 test
    ;;
  "edb-11" )
    test_command mvn -ntp -Dtest=LiquibaseHarnessSuiteTest -DdbName=edb -DdbVersion=11 test
    ;;
  "edb-12" )
    test_command mvn -ntp -Dtest=LiquibaseHarnessSuiteTest -DdbName=edb -DdbVersion=12 test
    ;;
  "edb-13" )
    test_command mvn -ntp -Dtest=LiquibaseHarnessSuiteTest -DdbName=edb -DdbVersion=13 test
    ;;
  "edb-14" )
    test_command mvn -ntp -Dtest=LiquibaseHarnessSuiteTest -DdbName=edb -DdbVersion=14 test
    ;;
  "derby" )
    test_command mvn -ntp -Dtest=LiquibaseHarnessSuiteTest -DdbName=derby -Dmaven.test.failure.ignore=true test
    ;;
  "sqlite" )
    test_command mvn -ntp -Dtest=LiquibaseHarnessSuiteTest -DdbName=sqlite -Dmaven.test.failure.ignore=true test
    ;;
  "diff")
    test_command mvn -ntp -Dtest=DiffTest test
    ;;
  "hsqldb-2.4")
    test_command mvn -ntp -Dtest=LiquibaseHarnessSuiteTest -DdbName=hsqldb -DdbVersion=2.4 test
    ;;
  "hsqldb-2.5")
    test_command mvn -ntp -Dtest=LiquibaseHarnessSuiteTest -DdbName=hsqldb -DdbVersion=2.5 test
    ;;
  "firebird-3")
    test_command mvn -ntp -Dtest=LiquibaseHarnessSuiteTest -DdbName=firebird -DdbVersion=3 test
    ;;
  "firebird-4")
    test_command mvn -ntp -Dtest=LiquibaseHarnessSuiteTest -DdbName=firebird -DdbVersion=4 test
    ;;
esac

