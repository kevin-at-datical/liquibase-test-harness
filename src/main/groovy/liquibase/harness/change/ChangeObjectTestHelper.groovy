package liquibase.harness.change

import groovy.transform.ToString
import groovy.transform.builder.Builder
import liquibase.database.Database
import liquibase.harness.config.DatabaseUnderTest
import liquibase.harness.config.TestConfig
import liquibase.harness.util.DatabaseConnectionUtil
import liquibase.harness.util.FileUtils
import java.util.logging.Logger

class ChangeObjectTestHelper {

    final static List supportedChangeLogFormats = ['xml', 'sql', 'json', 'yml', 'yaml'].asImmutable()
    final static String baseChangelogPath = "liquibase/harness/change/changelogs"

    static List<TestInput> buildTestInput() {
        String commandLineInputFormat = System.getProperty("inputFormat")
        String commandLineChangeObjects = System.getProperty("changeObjects")
        List commandLineChangeObjectList = Collections.emptyList()
        if(commandLineChangeObjects){
            commandLineChangeObjectList = Arrays.asList(commandLineChangeObjects.contains(",")
                    ? commandLineChangeObjects.split(",")
                    : commandLineChangeObjects)
        }
        if (commandLineInputFormat) {
            if (!supportedChangeLogFormats.contains(commandLineInputFormat)) {
                throw new IllegalArgumentException(commandLineInputFormat + " inputFormat is not supported")
            }
            TestConfig.instance.inputFormat = commandLineInputFormat
        }

        Logger.getLogger(this.class.name).warning("Only " + TestConfig.instance.inputFormat
                + " input files are taken into account for this test run")

        List<TestInput> inputList = new ArrayList<>()
        DatabaseConnectionUtil databaseConnectionUtil = new DatabaseConnectionUtil()

        for (DatabaseUnderTest databaseUnderTest : databaseConnectionUtil
                .initializeDatabasesConnection(TestConfig.instance.getFilteredDatabasesUnderTest())) {
            def database = databaseUnderTest.database
            for (def changeLogEntry : FileUtils.resolveInputFilePaths(databaseUnderTest, baseChangelogPath,
                    TestConfig.instance.inputFormat).entrySet()) {
                if (!commandLineChangeObjectList || commandLineChangeObjectList.contains(changeLogEntry.key)) {
                    inputList.add(TestInput.builder()
                            .databaseName(databaseUnderTest.name)
                            .url(databaseUnderTest.url)
                            .dbSchema(databaseUnderTest.dbSchema)
                            .username(databaseUnderTest.username)
                            .password(databaseUnderTest.password)
                            .version(databaseUnderTest.version)
                            .context(TestConfig.instance.context)
                            .changeObject(changeLogEntry.key)
                            .pathToChangeLogFile(changeLogEntry.value)
                            .database(database)
                            .build())
                }
            }
        }
        return inputList
    }

    static void saveAsExpectedSql(String generatedSql, TestInput testInput) {
        File outputFile = "${TestConfig.instance.outputResourcesBase}/liquibase/harness/change/expectedSql/" +
                "${testInput.databaseName}/${testInput.changeObject}.sql" as File
        outputFile.parentFile.mkdirs()
        try {
            outputFile.write(generatedSql)
        } catch(IOException exception) {
            Logger.getLogger(this.class.name).warning("Failed to save generated sql file! " + exception.message)
        }
    }

    @Builder
    @ToString(includeNames=true, includeFields=true, includePackage = false, excludes ='database,password')
    static class TestInput {
        String databaseName
        String url
        String dbSchema
        String username
        String password
        String version
        String context
        String changeObject
        String pathToChangeLogFile
        Database database
    }
}
