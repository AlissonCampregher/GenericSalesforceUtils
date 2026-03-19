@IsTest
private class MilestoneTTest {
    @IsTest
    static void shouldComputeBusinessDays() {
        Datetime startDate = Datetime.newInstanceGmt(2022, 6, 1);
        Datetime nextDay = MilestoneT.getNextBusinessDay(startDate, 10);
        Datetime expectedDate = Datetime.newInstanceGmt(2022, 6, 14);
        System.assertEquals(expectedDate, nextDay, '');
    }

    @IsTest
    static void shouldComputeElapsedBusinessDays() {
        Datetime startDate = Datetime.newInstanceGmt(2022, 6, 1);
        Datetime endDate = Datetime.newInstanceGmt(2022, 6, 14);
        MilestoneT milestone = new MilestoneT(startDate, endDate);
        System.assertEquals(9, milestone.getElapsedDays(), '');
        System.assertEquals(0, milestone.getElapsedHours(), '');
        System.assertEquals(0, milestone.getElapsedMinutes(), '');
        System.assertEquals(0, milestone.getElapsedSeconds(), '');
    }

    @IsTest
    static void shouldComputeElapsedBusinessDaysHoursMinutesSecondsPhase1() {
        Datetime startDate = Datetime.newInstanceGmt(2022, 6, 1, 8, 0, 0);
        Datetime endDate = startDate.addHours(2);
        MilestoneT milestone = new MilestoneT(startDate, endDate);
        System.assertEquals(0, milestone.getElapsedDays(), '');
        System.assertEquals(2, milestone.getElapsedHours(), '');
        System.assertEquals(0, milestone.getElapsedMinutes(), '');
        System.assertEquals(0, milestone.getElapsedSeconds(), '');
    }

    @IsTest
    static void shouldComputeElapsedBusinessDaysHoursMinutesSecondsPhase2() {
        Datetime startDate = Datetime.newInstanceGmt(2022, 6, 1, 8, 0, 0);
        Datetime endDate = startDate.addHours(2).addMinutes(3).addSeconds(4);
        MilestoneT milestone = new MilestoneT(startDate, endDate);
        System.assertEquals(0, milestone.getElapsedDays(), '');
        System.assertEquals(2, milestone.getElapsedHours(), '');
        System.assertEquals(3, milestone.getElapsedMinutes(), '');
        System.assertEquals(4, milestone.getElapsedSeconds(), '');
    }
}
