@isTest
private class UserSingletonTest {
    private static ProductFamilyGlobal product = ProductFamilyGlobal.values;
    private static User basicUser;
    private static User advancedUser;

    static {
        Profile profile = [SELECT Id FROM Profile WHERE Name = 'Read Only'];
        Profile profileAdmin = [SELECT Id FROM Profile WHERE Name = 'System Administrator' OR Name = 'Administrador do sistema'];

        User myUser = new User(id = UserInfo.getUserId());
        // Preventing NON-SETUP DML Failures
        System.runAs(myUser) {
            advancedUser = (User) TestFactory.createSObject(
                TestDataFactory.generateUserMockData(
                    'advanceduser@unico.io.sandbox',
                    'advanceduser-1',
                    profileAdmin.id,
                    product.UNICO_CHECK
                ),
                false
            );
            basicUser = (User) TestFactory.createSObject(
                TestDataFactory.generateUserMockData('basicuser@unico.io.sandbox', 'basicuser-2', profile.id, product.UNICO_PEOPLE),
                false
            );
            insert new List<User>{ basicUser, advancedUser };

            basicUser.ManagerId = advancedUser.Id;
            update basicUser;
        }
    }

    @isTest
    static void testHasViewAllData() {
        Test.startTest();
        UserSingleton USERS = (UserSingleton) Singleton.getSingleton(UserSingleton.class);
        System.assertEquals(false, USERS.hasViewAllData(basicUser.Id));
        System.assertEquals(true, USERS.hasViewAllData(advancedUser.Id));
        Test.stopTest();
    }

    @IsTest
    static void getManagerFromUserTest() {
        Test.startTest();
        UserSingleton USERS = (UserSingleton) Singleton.getSingleton(UserSingleton.class);
        System.assertEquals(false, String.isBlank(USERS.getManagerFromUser(basicUser.Id).Id));
        System.assertEquals(true, String.isBlank(USERS.getManagerFromUser(advancedUser.Id).Id));
        Test.stopTest();
    }

    @IsTest
    static void getUserTest() {
        Test.startTest();
        UserSingleton USERS = (UserSingleton) Singleton.getSingleton(UserSingleton.class);
        System.assertEquals(basicUser.Email, USERS.getUser(basicUser.Id).Email);
        System.assertEquals(advancedUser.Email, USERS.getUser(advancedUser.Id).Email);
        System.assertEquals(true, String.isBlank(USERS.getUser(TestingUtils.generateId(User.SObjectType)).Email));
        Test.stopTest();
    }

    @IsTest
    static void getProfileByUserTest() {
        Test.startTest();
        UserSingleton USERS = (UserSingleton) Singleton.getSingleton(UserSingleton.class);
        System.assertEquals(false, String.isBlank(USERS.getProfileByUser(basicUser.Id).Id));
        System.assertEquals(false, String.isBlank(USERS.getProfileByUser(advancedUser.Id).Id));
        Test.stopTest();
    }

    @IsTest
    static void usersListTest() {
        Test.startTest();
        UserSingleton USERS = (UserSingleton) Singleton.getSingleton(UserSingleton.class);
        System.assertEquals(false, USERS.usersList.isEmpty());
        Test.stopTest();
    }
}
