@IsTest
private class PicklistTest {
    @IsTest
    static void shouldTestCorrectValue() {
        System.assertEquals('Governo', PickListForTest.Values.GOVERNO, '');
    }

    @IsTest
    static void shouldTestWrongValue() {
        try {
            System.assertEquals('Error', PickListForTest.Values.TEST_ERROR, '');
            System.assertEquals(false, true, '');
        } catch (Exception e) {
            System.assertEquals(true, true, '');
        }
    }
}
