@isTest
private class TwinFieldsTest {
    @IsTest
    static void testMigrateRecords() {
        Account testAcc = new Account(Name = 'Name Original', Phone = '123456789');
        insert testAcc;

        Map<String, Object> overrideMap = new Map<String, Object>{ 'Name' => 'Name Override' };

        Test.startTest();
        // List<Account> migratedRecords = TwinFields.migrateRecords(testAcc, Account.getSObjectType(), overrideMap);
        List<Account> migratedRecords = new TwinFields()
            .setOriginRecords(testAcc)
            .setDestinyRecordType(Account.getSObjectType())
            .setOverrideMap(overrideMap)
            .run();
        Test.stopTest();

        System.assertEquals(1, migratedRecords.size(), 'There should be a migrated record');

        Account migratedRecord = migratedRecords[0];
        System.assertEquals('Name Override', migratedRecord.Name, 'Name field was not migrated correctly');
        System.assertEquals('123456789', migratedRecord.Phone, 'Phone field was not migrated correctly');
    }

    @IsTest
    static void testFieldNotContains() {
        Account testAcc = new Account(Name = 'Name Original', Phone = '123456789');
        insert testAcc;

        Test.startTest();
        List<SObject> migratedRecords = new TwinFields().setOriginRecords(testAcc).setDestinyRecordType(Contract.getSObjectType()).run();
        Test.stopTest();

        Assert.areEqual(1, migratedRecords[0].getPopulatedFieldsAsMap().size());
    }
}
