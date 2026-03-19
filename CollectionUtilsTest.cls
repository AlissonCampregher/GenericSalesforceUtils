@IsTest
private class CollectionUtilsTest {
    private static List<Account> accounts;
    private static List<Contact> contacts;

    static {
        accounts = generateAccountList();
        contacts = generateContactList(accounts);
    }

    @IsTest
    static void shouldReturnSetSObjectId() {
        Test.startTest();
        Set<Id> ids = CollectionUtils.generateSetId(accounts, 'Id');
        Test.stopTest();
        System.assertEquals(accounts.size(), ids.size(), 'Set should be same size\'s List');
    }

    @IsTest
    static void shouldReturnSetId(){
        Test.startTest();
        Set<Id> ids = CollectionUtils.generateSetId(contacts, new Set<String>{'Id','Account.Id'});
        Test.stopTest();
        System.assertEquals(ids.size(), contacts.size() * 2);
    }

    @IsTest
    static void shouldReturnSetSObjectString() {
        Test.startTest();
        Set<String> names = CollectionUtils.generateSetString(accounts, 'Name');
        Test.stopTest();
        System.assertEquals(1, names.size(), 'Set size should be ONE');
    }

    @IsTest
    static void shouldReturnSetSObjectDate() {
        contacts[0].Birthdate = System.today();
        contacts[1].Birthdate = System.today().addDays(1);
        Test.startTest();
        Set<Date> dates = CollectionUtils.generateSetDate(contacts, 'Birthdate');
        Test.stopTest();
        System.assertEquals(2, dates.size());
    }

    @IsTest
    static void shouldReturnMapSObjectId() {
        Test.startTest();
        Map<Id, SObject> mapIds = CollectionUtils.generateMapId(accounts, 'Id');
        Test.stopTest();
        System.assertEquals(accounts.size(), mapIds.size(), 'Map should be same size\'s List');
    }

    @IsTest
    static void shouldReturnMapSObjectString() {
        Test.startTest();
        Map<String, SObject> names = CollectionUtils.generateMapString(accounts, 'Name');
        Test.stopTest();
        System.assertEquals(1, names.size(), 'Map size should be ONE');
    }

    @IsTest
    static void shouldReturnMapDateListSObject() {
        contacts[0].Birthdate = System.today();
        contacts[1].Birthdate = System.today().addDays(1);
        Test.startTest();
        Map<Date, List<SObject>> dates = CollectionUtils.generateMapDateListObject(contacts, 'Birthdate');
        Test.stopTest();
        System.assertEquals(2, dates.size());
    }

    @IsTest
    static void shouldReturnSetSObjectLoopkup() {
        Test.startTest();
        Set<Id> ids = CollectionUtils.generateSetId(contacts, 'Account.Id');
        Test.stopTest();
        System.assertEquals(accounts.size(), ids.size(), 'Set should be same size\'s List');
    }

    @IsTest
    static void shouldReturnMapStringLoopkup() {
        Test.startTest();
        Map<String, SObject> mapIds = CollectionUtils.generateMapString(contacts, 'Account.Name');
        Test.stopTest();
        System.assertEquals(1, mapIds.size(), 'Map size should be ONE');
    }

    @IsTest
    static void shouldReturnMapListSObject() {
        Test.startTest();
        Map<Id, List<SObject>> mapSObjects = CollectionUtils.generateMapIdListObject(contacts, 'Account.Id');
        Test.stopTest();
        System.assertEquals(contacts.size(), mapSObjects.size(), 'Map should be same size\'s List');
        for (Id key : mapSObjects.keySet()) {
            System.assertEquals(false, mapSObjects.get(key).isEmpty(), 'List should not be empty');
        }
    }

    @IsTest
    static void shouldFilterByPropertyContains() {
        contacts[0].Account.Name = 'thisIsAfilterWithContains';
        Test.startTest();
        List<SObject> filtered = CollectionUtils.filterByPropertyContains(contacts, 'Account.Name', 'filter');
        Test.stopTest();
        System.assertEquals(1, filtered.size(), 'List should be the same size');
    }

    @IsTest
    static void shouldFilterByPropertyString() {
        contacts[0].Account.Name = 'filter';
        Test.startTest();
        List<SObject> filtered = CollectionUtils.filterByProperty(contacts, 'Account.Name', 'filter');
        Test.stopTest();
        System.assertEquals(1, filtered.size(), 'List should be the same size');
    }

    @IsTest
    static void shouldFilterByPropertyAnd() {
        contacts[0].Account.Name = 'filter';
        contacts[0].Account.CNPJ__c = '33129481000199';
        Test.startTest();
        List<SObject> filtered = CollectionUtils.filterByProperty(
            contacts,
            new Map<String, Object>{ 'Account.Name' => 'filter', 'Account.CNPJ__c' => '33129481000199' }
        );
        Test.stopTest();
        System.assertEquals(1, filtered.size(), 'List should be the same size');
    }

    @IsTest
    static void shouldFilterByPropertyOr() {
        contacts[0].Account.Name = 'filter';
        contacts[1].Account.CNPJ__c = '33129481000199';
        Test.startTest();
        List<SObject> filtered = CollectionUtils.filterByPropertyOr(
            contacts,
            new Map<String, Object>{ 'Account.Name' => 'filter', 'Account.CNPJ__c' => '33129481000199' }
        );
        Test.stopTest();
        System.assertEquals(2, filtered.size(), 'List should be the same size');
    }

    @IsTest
    static void shouldFilterByPropertyId() {
        Set<Id> ids = new Set<Id>{ contacts[0].Account.Id };
        Test.startTest();
        List<SObject> filtered = CollectionUtils.filterByProperty(contacts, 'Account.Id', ids);
        Test.stopTest();
        System.assertEquals(1, filtered.size(), 'List should be the same size');
    }

    @IsTest
    static void shouldFilterByPropertyNull() {
        contacts[0].Account.Name = null;
        Test.startTest();
        List<SObject> filtered = CollectionUtils.filterByPropertyNull(contacts, 'Account.Name');
        Test.stopTest();
        System.assertEquals(1, filtered.size(), 'List should be the same size');
    }

    @IsTest
    static void shouldFilterByPropertyNotNull() {
        contacts[0].Account.Phone = '123';
        Test.startTest();
        List<SObject> filtered = CollectionUtils.filterByPropertyNotNull(contacts, 'Account.Phone');
        Test.stopTest();
        System.assertEquals(1, filtered.size(), 'List should be the same size');
    }

    @IsTest
    static void shouldFilterByPropertyNotNullSet() {
        contacts[0].Account.Phone = '123';
        contacts[0].Account.Description = 'teste';
        Test.startTest();
        List<SObject> filtered = CollectionUtils.filterByPropertyNotNull(contacts, new Set<String>{ 'Account.Phone', 'Account.Description' });
        Test.stopTest();
        System.assertEquals(1, filtered.size(), 'List should be the same size');
    }

    @IsTest
    static void shouldFindByProperty() {
        contacts[0].Account.Name = 'filter';
        contacts[1].Account.CNPJ__c = '33129481000199';
        Test.startTest();
        SObject filtered1 = CollectionUtils.findByProperty(contacts, 'Account.Name', 'filter');
        SObject filtered2 = CollectionUtils.findByProperty(contacts, new Map<String, Object>{ 'Account.CNPJ__c' => '33129481000199' });
        Test.stopTest();
        Assert.isNotNull(filtered1);
        Assert.isNotNull(filtered2);
    }

    @IsTest
    static void shouldFindByPropertyNotFound() {
        contacts[0].Account.Name = 'filter';
        Test.startTest();
        SObject filtered = CollectionUtils.findByProperty(contacts, 'Account.Name', 'filtered');
        Test.stopTest();
        Assert.isNull(filtered);
    }

    @IsTest
    static void shouldFindByPropertyNotFoundException() {
        contacts[0].Account.Name = 'filter';

        try {
            Test.startTest();
            SObject filtered = CollectionUtils.findByProperty(contacts, 'Account.Name', 'filtered', false, true, false);
            Test.stopTest();

            Assert.fail('O filtro não encontrou nenhum registro e não lançou a exceção');
        } catch (Exception e) {
            Assert.isInstanceOfType(e, CustomException.class);
            Assert.areEqual(e.getMessage(), 'Não foi encontrado nenhum objeto com os parâmetros informados!');
        }
    }

    @IsTest
    static void shouldFindByPropertyFoundMoreThanOneException() {
        contacts[0].Account.Name = 'filter';
        contacts[1].Account.Name = 'filter';

        try {
            Test.startTest();
            SObject filtered = CollectionUtils.findByProperty(contacts, 'Account.Name', 'filter', false, false, true);
            Test.stopTest();

            Assert.fail('O filtro encontrou mais de um registro com essa condição e não lançou a exceção');
        } catch (Exception e) {
            Assert.isInstanceOfType(e, CustomException.class);
            Assert.areEqual(e.getMessage(), 'Foram encontrados mais que um objeto com os parâmetros informados!');
        }
    }

    @IsTest
    static void shouldSortASCList() {
        Integer j = accounts.size();
        for (Account account : accounts) {
            account.name = String.valueOf(j--).leftPad(10, '0');
        }
        Test.startTest();
        CollectionUtils.sortASCByProperty(accounts, 'Name');
        Test.stopTest();
        j = 1;
        for (Account account : accounts) {
            System.assertEquals(j++, Integer.valueOf(account.name), '');
        }
    }

    @IsTest
    static void shouldSortASCListDecimal() {
        List<ItemModeloPrecificacao__c> itensModeloPrecificacao = new List<ItemModeloPrecificacao__c>{
            new ItemModeloPrecificacao__c(ConsumoDe__C = 301),
            new ItemModeloPrecificacao__c(ConsumoDe__C = 501),
            new ItemModeloPrecificacao__c(ConsumoDe__C = 701),
            new ItemModeloPrecificacao__c(ConsumoDe__C = 801),
            new ItemModeloPrecificacao__c(ConsumoDe__C = 1001),
            new ItemModeloPrecificacao__c(ConsumoDe__C = 2501),
            new ItemModeloPrecificacao__c(ConsumoDe__C = 5001),
            new ItemModeloPrecificacao__c(ConsumoDe__C = 7501),
            new ItemModeloPrecificacao__c(ConsumoDe__C = 10001),
            new ItemModeloPrecificacao__c(ConsumoDe__C = 20001),
            new ItemModeloPrecificacao__c(ConsumoDe__C = 30001),
            new ItemModeloPrecificacao__c(ConsumoDe__C = 50001),
            new ItemModeloPrecificacao__c(ConsumoDe__C = 100001),
            new ItemModeloPrecificacao__c(ConsumoDe__C = 200001),
            new ItemModeloPrecificacao__c(ConsumoDe__C = 301000),
            new ItemModeloPrecificacao__c(ConsumoDe__C = 1)
        };

        Test.startTest();
        CollectionUtils.sortASCByProperty(itensModeloPrecificacao, 'ConsumoDe__c');
        Test.stopTest();

        System.assertEquals(itensModeloPrecificacao[0].ConsumoDe__c, (Decimal) 1);
        System.assertEquals(itensModeloPrecificacao[1].ConsumoDe__c, (Decimal) 301);
        System.assertEquals(itensModeloPrecificacao[2].ConsumoDe__c, (Decimal) 501);
        System.assertEquals(itensModeloPrecificacao[3].ConsumoDe__c, (Decimal) 701);
        System.assertEquals(itensModeloPrecificacao[4].ConsumoDe__c, (Decimal) 801);
        System.assertEquals(itensModeloPrecificacao[5].ConsumoDe__c, (Decimal) 1001);
        System.assertEquals(itensModeloPrecificacao[6].ConsumoDe__c, (Decimal) 2501);
        System.assertEquals(itensModeloPrecificacao[7].ConsumoDe__c, (Decimal) 5001);
        System.assertEquals(itensModeloPrecificacao[8].ConsumoDe__c, (Decimal) 7501);
        System.assertEquals(itensModeloPrecificacao[9].ConsumoDe__c, (Decimal) 10001);
        System.assertEquals(itensModeloPrecificacao[10].ConsumoDe__c, (Decimal) 20001);
        System.assertEquals(itensModeloPrecificacao[11].ConsumoDe__c, (Decimal) 30001);
        System.assertEquals(itensModeloPrecificacao[12].ConsumoDe__c, (Decimal) 50001);
        System.assertEquals(itensModeloPrecificacao[13].ConsumoDe__c, (Decimal) 100001);
        System.assertEquals(itensModeloPrecificacao[14].ConsumoDe__c, (Decimal) 200001);
        System.assertEquals(itensModeloPrecificacao[15].ConsumoDe__c, (Decimal) 301000);
    }

    @IsTest
    static void sumPropertyTest() {
        for (Account acc : accounts) {
            acc.NumberOfEmployees = 10;
        }

        accounts[accounts.size() - 1].NumberOfEmployees = null;

        Test.startTest();
        Decimal sumNumberOfEmployees = CollectionUtils.sumProperty(accounts, 'NumberOfEmployees');
        Test.stopTest();

        System.assertEquals(90, sumNumberOfEmployees);
    }

    @IsTest
    static void sumMultiplesPropertyTest() {
        for (Account acc : accounts) {
            acc.NumberOfEmployees = 10;
            acc.AnnualRevenue = 1000;
        }

        accounts[accounts.size() - 1].NumberOfEmployees = null;
        accounts[accounts.size() - 1].AnnualRevenue = null;

        Test.startTest();
        Map<String, Decimal> sumProperties = CollectionUtils.sumProperty(
            accounts,
            new Set<String>{ 'NumberOfEmployees', 'AnnualRevenue', 'Admissoes__c' }
        );
        Test.stopTest();

        System.assertEquals(90, sumProperties.get('NumberOfEmployees'));
        System.assertEquals(9000, sumProperties.get('AnnualRevenue'));
        System.assertEquals(0, sumProperties.get('Admissoes__c'));
    }

    @isTest
    static void testGetLastItem() {
        for (Account account : accounts) {
            account.Name = account.Name + ' ' + (accounts.indexOf(account) + 1);
        }

        Test.startTest();
        Account account = (Account) CollectionUtils.getLastItem(accounts);
        Test.stopTest();

        System.assertEquals('Test 10', account.Name);
    }

    @isTest
    static void testPutMapIdListSObject() {
        Map<Id, List<SObject>> mapTo = new Map<Id, List<SObject>>{ accounts[0].Id => new List<Contact>{ contacts[0], contacts[1] } };

        Test.startTest();
        CollectionUtils.putMap(mapTo, accounts[0].Id, contacts[2]);
        CollectionUtils.putMap(mapTo, accounts[1].Id, contacts[0]);
        Test.stopTest();

        System.assertEquals(2, mapTo.size());
        System.assertEquals(3, mapTo.get(accounts[0].Id).size());
        System.assertEquals(1, mapTo.get(accounts[1].Id).size());
    }

    @isTest
    static void testPutMapIdSetId() {
        Map<Id, Set<Id>> mapTo = new Map<Id, Set<Id>>{ accounts[0].Id => new Set<Id>{ contacts[0].Id, contacts[1].Id } };

        Test.startTest();
        CollectionUtils.putMap(mapTo, accounts[0].Id, contacts[2].Id);
        CollectionUtils.putMap(mapTo, accounts[1].Id, contacts[0].Id);
        Test.stopTest();

        System.assertEquals(2, mapTo.size());
        System.assertEquals(3, mapTo.get(accounts[0].Id).size());
        System.assertEquals(1, mapTo.get(accounts[1].Id).size());
    }

    private static List<Account> generateAccountList() {
        List<Account> accounts = TestingUtils.generateSObjectList(Account.SObjectType, 10);
        for (Account acc : accounts) {
            acc.Name = 'Test';
        }
        return accounts;
    }

    private static List<Contact> generateContactList(List<Account> accounts) {
        List<Contact> contacts = TestingUtils.generateSObjectList(Contact.SObjectType, 10);
        for (Contact contact : contacts) {
            contact.FirstName = 'First Name';
            contact.LastName = 'Last Name';
        }
        for (Integer i = 0; i < contacts.size(); i++) {
            contacts[i].Account = accounts[i];
        }
        return contacts;
    }
}
