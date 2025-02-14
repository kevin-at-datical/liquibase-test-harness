# A Harness of Integration Tests

![Default Test Execution](https://github.com/liquibase/liquibase-test-harness/workflows/Default%20Test%20Execution/badge.svg) ![Oracle Test Execution](https://github.com/liquibase/liquibase-test-harness/workflows/Oracle%20Parallel%20Test%20Execution/badge.svg)

## Test-Harness Support Matrix

| Database | Versions Tested|
| ----------- | ----------- |
| Postgres |  `9, 9.5, 10, 11, 12, 13, 14` |
| MySQL | `5.6, 5.7, 8` |
| MariaDB | `10.2, 10.3 , 10.4, 10.5, 10.6, 10.7` |
| SQL Server | `2017`, `2019` |
| Percona XtraDB | `5.7`, `8.0`|
| Oracle | `18.3.0, 18.4.0, 19.9.0, 21.3.0` |
| CockroachDB | `20.1, 20.2, 21.1` |
| EDB | `9.5, 9.6, 10, 11, 12, 13, 14` |
| H2 | `2.1.210` |
| SQLite | `3.34.0` |
| Apache Derby | `10.14.2.0` |
| Firebird | `3.0, 4.0` |
| HSQLDB | `2.3.4`, `2.5` |

## Framework

The test harness consists of a variety of standard tests to ensure the database-specific interactions within Liquibase work against specific 
versions and configurations

The test harness logically consists of three parts: 
1. Test logic
1. Configuration files containing inputs for the test logic
1. Configuration files containing outputs/expectations for the test logic. 

The built-in tests are designed to test an overall functional flow, iterating over all configured connections. 
For each connection, it will run each applicable input configuration and compare it to the expected output/expectations.

Both the input and output configuration files can be defined in a way that makes them apply to all databases or to specific types and/or specific versions.

The general pattern is that for each directory containing configuration files:
- Files directly in that root apply to all databases. Example: `liquibase/harness/change/changelogs`
- Files in a subdirectory named for the database type apply to only that type of database. Example: `liquibase/harness/change/changelogs/mysql`
- Files in a subdirectory with a version apply only to this version of the database. Example: `liquibase/harness/change/changelogs/mysql/8`
##### Note: The version folder name should be match exactly with the DB version provided in `harness-config.yml` file. We do not split this to major/minor/patch subversion folders currently.

At each level in that hierarchy, new configurations can be added and/or can override configurations from a lower level. 

Currently, there are three test types defined in the test harness:
* Change Object Tests
* Change Data Tests
* Diff Command Test

This repository is configured to run against databases supported by Liquibase Core. 

Extensions that add support for additional databases and/or define additional functionality can add this framework as a dependency and use the existing tests to:
- More easily verify their new functionality works
- And that it also doesn't break existing logic

## Configuring Execution   

#### Configuration File

The test harness will look for a file called `harness-config.yml` in the root of your classpath.

That file contains a list of the database connections to test against, as well as an ability to control which subsets of tests to run.   

See `src/test/resources/harness-config.yml` to see what this repository is configured to use.

## For use in extensions

For more information on using the test harness in your extension, see [README.extensions.md] 

# Framework Tests
 
## Change Objects Test

The test-harness validates most of the Change Types as listed on [Home Page](https://docs.liquibase.com/change-types/home.html). 
The primary focus is on add, create, drop & rename database objects.

The `groovy/liquibase/harness/ChangeObjectsTests.groovy` test executes changelogs against the database and validates the SQL generated by them as well as 
whether they make the expected changes.

* The test behavior is as follows:
  * It reads the changesets from the changelogs provided in `src/main/resources/liquibase/harness/change/changelogs` folders (recursively)
  * Runs the changeset thru the SqlGeneratorFactory to generate SQL
  * Compares the generated SQL with the expected SQL (provided in `src/main/resources/liquibase/harness/change/expectedSql`)
  * If the SQL generation is correct, the test then runs `liquibase update` to deploy the
  changeset to the DB
  * The test takes a snapshot of the database after deployment
  * The deployed changes are then rolled back 
  * Finally, the actual DB snapshot is compared to the expected DB snapshot (provided in `src/main/resources/liquibase/harness/change/expectedSnapshot`)

#### Types of input files
* The tests work with the 4 types of input files that are supported by liquibase itself - xml, yaml, json, sql.
Thus files with extensions 'xml', 'sql', 'json', 'yml', 'yaml' are taken into account, but not all formats together in the same run.
* The default format is xml, so by default only changelogs with xml file extension are executed.
To change it to another format, like 'sql' for instance, specify `-DinputFormat=sql` as the command line argument for Maven or as VM option to your JUnit test run config.


### Adding a change object test
1) Go to `src/main/resources/liquibase/harness/change/changelogs` and add the xml (or other) changeset for the change type you
 want to test.
  - The framework tries to rollback changes after deploying them to DB. If liquibase knows how to do a rollback for that particular changeset, it will automatically do that.
If not, you will need to provide the rollback by yourself. To learn more about rollbacks read [Rolling back changesets](https://docs.liquibase.com/workflows/liquibase-community/using-rollback.html) article.
2) Go to `src/main/resources/liquibase/harness/change/expectedSql` and add the expected generated SQL. 
 - You will need to add this under the database specific folder.
 - NOTE: If your changeSet will generate multiple SQL statements, you should add each SQL statement as a separate line. (See `renameTable.sql` in the postgres folder for an example.)
 - If you would like to test another DB type, please add the requisite folder.
3) Go to `src/main/resources/liquibase/harness/change/expectedSnapshot` and add the expected DB Snapshot results.
  - To verify the absence of an object in a snapshot (such as with drop* commands) add `"_noMatch": true,` to that tree level where the missing object should be verified.
  See [dropSequence.json](src/main/resources/liquibase/harness/change/expectedSnapshot/postgresql/dropSequence.json) as an example. 
Additionally the `_noMatchField` parameter can be used to define the exact property which should be absent or different for that particular database object (for example Column, Table etc.) 
see [createTableWithNumericColumn.json](src/main/resources/liquibase/harness/change/expectedSnapshot/postgresql/createTableWithNumericColumn.json)
  - You will need to add this under the database specific folder.
  - If you would like to test another DB type, please add the requisite folder.
4) Go to your IDE and run the test class `ChangeObjectTests.groovy` (You can also choose to run `BaseTestHarnessSuite`, or `LiquibaseHarnessSuiteTest` -- at present they all work the same).

## Change Data Test

The primary goal of these tests is to validate change types related to DML (Data Manipulation Language) aspect.
Generally it is similar to ChangeObjectTests except it doesn't use Liquibase snapshot to verify data but obtains result set via JDBC.
 - `src/main/resources/liquibase/harness/data/changelogs` - add DML related changelogs here;
 - `src/main/resources/liquibase/harness/data/checkingSql` - add select query which will obtain a result set from required table;
 - `src/main/resources/liquibase/harness/data/expectedResultSet` - add JSON formatted expected result set from required table
    where left part of a JSON node is the name of a change type and right part is JSON Array with a result set;
 - `src/main/resources/liquibase/harness/data/expectedSql` - add query which is expected to be generated by Liquibase;
To run the test go to your IDE and run the test class `ChangeDataTests.groovy`.

## DiffCommandTest
This test executes the following steps: 
   * Reads `src/test/resources/harness-config.yml` and `src/main/resources/liquibase/harness/diff/diffDatabases.yml` to locate the
    databases that need to be compared
   * Creates a diff based on 2 databases (targetDatabase and referenceDatabase) from `diffDatabases.yml`
   * Generates the changelog based on diff 
   * Applies the generated changelog to the targetDatabase
   * Checks the diff between the target and reference databases again
   * If some diffs still exist, then they are matched with the expected diff from `liquibase/harness/diff/expectedDiff` folder

#### Warning: This is a destructive test -- it will alter the state of targetDatabase to match the referenceDatabase. 

## Running the Tests

### Minimum Requirements
Java 1.8

1) Make sure you have a docker container up and running first
2) Go to `src/test/resources/docker` and run `docker-compose up -d`. 
Wait until the databases start up.
3) Open `src/test/groovy/liquibase/harness/LiquibaseHarnessSuiteTest.groovy` in your IDE of choice and run it

## Running from the cmd line with Maven
Build the project first by running `mvn clean install -DskipTests` 

Execute `mvn test` with the (optional) flags outlined below:
* `-DinputFormat=xml` or select from the other inputFormats listed in [Types of input files](#types-of-input-files)
* `-DchangeObjects=createTable,dropTable` flag allows you to run specific changeObjects rather than all. Use comma
 separated lists.
* `-DchangeData=insert,delete` flag that allows to run specific changeData through ChangeDataTests. Use comma separated list
* `-DconfigFile=customConfigFile.yml` enables to override default config file which is(`src/test/resources/harness-config.yml`)
* `-Dprefix=docker` filters database from config file by some common platform identifier. E.g. all AWS based platforms, all Titan managed platforms, all from default docker file.
* `-DdbName=mysql` overrides the database type. This is only a single value property for now.
* `-DdbVersion` overrides the database version. Works in conjunction with `-DdbName` flag.

To run the test suite itself, you can execute `mvn -Dtest=LiquibaseHarnessSuiteTest test`

## Cleanup

When you are done with test execution, run `docker-compose down --volumes` to stop the docker containers 
gracefully and to allow the tests to start from a clean slate on the next run.


