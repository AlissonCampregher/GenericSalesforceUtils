@IsTest
private class SingletonTest {
    @IsTest
    static void baseLineTest() {
        runTest(null);
    }

    @IsTest
    static void singletonStressTest() {
        runTest(new TestStressSingleton());
    }

    static void runTest(TestFunction function) {
        for (Integer index = 0; index < 10000; index++) {
            if (function != null) {
                function.call();
            }
        }
    }

    private abstract class TestFunction {
        public abstract void call();
    }

    private class TestStressSingleton extends TestFunction {
        public override void call() {
            System.debug(MilestoneT.CURRENT_BH.getBusinessHoursId());
        }
    }
}
