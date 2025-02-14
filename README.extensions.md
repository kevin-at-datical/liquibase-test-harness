# Using Test Harness in Extensions

This test harness is *also* designed to make it easy for you to test your extensions.

## Configuring your project
 
#### Adding as a dependency

If you are using maven, you can add the dependency as follows:   

```
    <dependencies>
        <dependency>
            <groupId>org.liquibase</groupId>
            <artifactId>liquibase-test-harness</artifactId>
            <version>1.0.0</version> // pick up latest version availbale on maven-central
            <scope>test</scope>
        </dependency>
    </dependencies>
```

#### Configuring your connections

Add a harness-config.yml file to your `src/test/resources` file. 
This file should contain the connection information for all the databases you want your extension to be tested against.

See [src/test/resources/harness-config.yml] as an example.

#### Setting up your databases

If possible, provide a docker-compose.yml file that starts and configures your test databases. 

The test harness requires certain objects to be pre-created in your database. See [src/test/resources/docker/postgres-init.sh] as an example of what setup is required.

#### Adding a LiquibaseHarnessSuite file

In your `src/test/groovy` directory, create a file like:      

```
class ExtensionHarnessTest extends BaseHarnessSuite {

}
```

This suite will run all Test Harness tests

## Adding Additional Tests and Configurations


#### Base Level Test

In case you don't know if the extension you are going to use works with Liquibase on base level:
- Execution of update/rollback with a formatted SQL file;
- Databasechangelog table management;
- Databasechangeloglock table management;

You may use this test to check it.
Add new run configuration in extension project and choose class liquibase.harness.base.BaseLevelTest from external libraries. Run the test.

#### New-Database Extensions

If your extension is adding support for a new database type, you will be mainly focused on running and capturing the standard test permutations.

For each of the tests in the framework, we include base permutations that should run successfully. 
If there are "validation" files that the test uses, it will write an initial version of the file if it does not exit.
If a particular permutation is failing because it does not apply to your database, there is a way to override that functionality.

Once the standard permutations are passing, you can add additional database-specific permutations as you need. 

For details on how to configure verifications and add permutations, see the `Framework Tests` section of [README.md] 
      
#### New Functionality Extensions

If your extension is adding support for new functionality into Liquibase, you will mainly be focused on adding new permutations to the existing tests.
 
For example, if you are adding a new `cleanTable` tag, you'd add a new ChangeObjectsTest configuration for that new tag.  
 
For details on how to configure verifications and add permutations, see the `Framework Tests` section of [README.md] 
   
