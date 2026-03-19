public class TwinFields {
    private List<SObject> originRecords;
    private Schema.SObjectType destType;
    private Map<String, Object> overrideMap;

    public TwinFields setOriginRecords(List<SObject> originRecords) {
        this.originRecords = originRecords;
        return this;
    }

    public TwinFields setOriginRecords(SObject originRecords) {
        return this.setOriginRecords(new List<SObject>{ originRecords });
    }

    public TwinFields setDestinyRecordType(Schema.SObjectType destType) {
        this.destType = destType;
        return this;
    }

    public TwinFields setOverrideMap(Map<String, Object> overrideMap) {
        this.overrideMap = overrideMap;
        return this;
    }

    public List<SObject> run() {
        Schema.DescribeSObjectResult destDescribe = this.destType.getDescribe();
        Map<String, Schema.SObjectField> destFields = destDescribe.fields.getMap();

        List<SObject> targetRecords = new List<SObject>();

        for (SObject originRecord : this.originRecords) {
            SObject destRecord = this.destType.newSObject();
            Map<String, Object> populatedFields = originRecord.getPopulatedFieldsAsMap();

            for (String fieldName : populatedFields.keySet()) {
                if (destFields.containsKey(fieldName) == false) {
                    continue;
                }
                Schema.DescribeFieldResult fieldDescribe = destFields.get(fieldName).getDescribe();
                if (!fieldDescribe.isCreateable()) {
                    continue;
                }
                destRecord.put(fieldName, populatedFields.get(fieldName));
            }

            if (overrideMap != null) {
                for (String overrideField : overrideMap.keySet()) {
                    if (destFields.containsKey(overrideField) == false) {
                        continue;
                    }
                    Schema.DescribeFieldResult overrideFieldDescribe = destFields.get(overrideField).getDescribe();
                    if (overrideFieldDescribe.isCreateable()) {
                        destRecord.put(overrideField, overrideMap.get(overrideField));
                    }
                }
            }
            targetRecords.add(destRecord);
        }
        return targetRecords;
    }
}
