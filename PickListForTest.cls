public class PickListForTest extends Picklist {
    private PickListForTest() {
        super(Account.Industry);
    }

    public static PickListForTest Values {
        get {
            if (Values == null) {
                Values = new PickListForTest();
            }
            return Values;
        }
        private set;
    }

    public String GOVERNO {
        get {
            return this.validatePicklistValue('Governo');
        }
    }

    public String TEST_ERROR {
        get {
            return this.validatePicklistValue('Error');
        }
    }
}
