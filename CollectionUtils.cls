public abstract class CollectionUtils {
    public static List<SObject> filterByProperty(List<SObject> sobjects, String fieldName, Object filter) {
        return filterByProperty(sobjects, new Map<String, Object>{ fieldName => filter }, false);
    }

    public static List<SObject> filterByProperty(List<SObject> sobjects, Map<String, Object> filterByFieldName) {
        return filterByProperty(sobjects, filterByFieldName, false);
    }

    public static List<SObject> filterByPropertyOr(List<SObject> sobjects, Map<String, Object> filterByFieldName) {
        return filterByProperty(sobjects, filterByFieldName, true);
    }

    private static List<SObject> filterByProperty(List<SObject> sobjects, Map<String, Object> filterByFieldName, Boolean useOrOperator) {
        List<SObject> result = new List<SObject>();

        for (SObject sobj : sobjects) {
            Boolean isValid = true;

            for (String fieldName : filterByFieldName.keySet()) {
                isValid = checkValue(getObjectValue(sobj, fieldName), filterByFieldName.get(fieldName));

                if ((useOrOperator && isValid) || (!useOrOperator && !isValid)) {
                    break;
                }
            }

            if (isValid) {
                result.add(sobj);
            }
        }

        return result;
    }

    public static List<SObject> filterByPropertyContains(List<SObject> sobjects, String key, String filter) {
        return filterByPropertyContains(sobjects, key, new List<String>{ filter });
    }

    public static List<SObject> filterByPropertyContains(List<SObject> sobjects, String key, List<String> filters) {
        List<SObject> result = new List<SObject>();
        for (SObject sobj : sobjects) {
            for (String filter : filters) {
                Object value = getObjectValue(sobj, key);
                if (String.valueOf(value).contains(filter)) {
                    result.add(sobj);
                }
            }
        }
        return result;
    }

    public static List<SObject> filterByPropertyNull(List<SObject> sobjects, String key) {
        List<SObject> result = new List<SObject>();
        for (SObject sobj : sobjects) {
            Object value = getObjectValue(sobj, key);
            if (value == null) {
                result.add(sobj);
            }
        }
        return result;
    }

    public static List<SObject> filterByPropertyNotNull(List<SObject> sobjects, Set<String> keys) {
        List<SObject> result = new List<SObject>();
        for (SObject sobj : sobjects) {
            for (String key : keys) {
                Object value = getObjectValue(sobj, key);
                if (value != null && !result.contains(sobj)) {
                    result.add(sobj);
                }
            }
        }
        return result;
    }

    public static List<SObject> filterByPropertyNotNull(List<SObject> sobjects, String key) {
        return filterByPropertyNotNull(sobjects, new Set<String>{ key });
    }

    public static SObject findByProperty(List<SObject> sobjects, String key, Object filter) {
        return findByProperty(sobjects, key, filter, false);
    }

    public static SObject findByProperty(List<SObject> sobjects, String key, Object filter, Boolean useOrOperator) {
        return findByProperty(sobjects, key, filter, useOrOperator, false, false);
    }

    public static SObject findByProperty(
        List<SObject> sobjects,
        String key,
        Object filter,
        Boolean useOrOperator,
        Boolean throwExceptionIfNotExists,
        Boolean throwExceptionIfFoundMoreThanOne
    ) {
        return findByProperty(
            sobjects,
            new Map<String, Object>{ key => filter },
            useOrOperator,
            throwExceptionIfNotExists,
            throwExceptionIfFoundMoreThanOne
        );
    }

    public static SObject findByProperty(List<SObject> sobjects, Map<String, Object> filterByFieldName) {
        return findByProperty(sobjects, filterByFieldName, false);
    }

    public static SObject findByProperty(List<SObject> sobjects, Map<String, Object> filterByFieldName, Boolean useOrOperator) {
        return findByProperty(sobjects, filterByFieldName, useOrOperator, false, false);
    }

    public static SObject findByProperty(
        List<SObject> sobjects,
        Map<String, Object> filterByFieldName,
        Boolean useOrOperator,
        Boolean throwExceptionIfNotExists,
        Boolean throwExceptionIfFoundMoreThanOne
    ) {
        SObject result;

        List<SObject> results = filterByProperty(sobjects, filterByFieldName, useOrOperator);

        if (results.size() == 1) {
            result = results[0];
        } else if ((results.size() > 1) && throwExceptionIfFoundMoreThanOne) {
            throw new CustomException('Foram encontrados mais que um objeto com os parâmetros informados!');
        }

        if ((result == null) && throwExceptionIfNotExists) {
            throw new CustomException('Não foi encontrado nenhum objeto com os parâmetros informados!');
        }

        return result;
    }

    public static Set<Id> generateSetId(List<SObject> sobjects, String key) {
        return generateSetId(sobjects, new Set<String>{ key });
    }

    public static Set<Id> generateSetId(List<SObject> sobjects, Set<String> keys) {
        Set<Id> result = new Set<Id>();
        for (String key : keys) {
            loadSetId(sobjects, key, result);
        }
        return result;
    }

    public static Set<String> generateSetString(List<SObject> sobjects, String key) {
        Set<String> result = new Set<String>();
        loadSetString(sobjects, key, result);
        return result;
    }

    public static Set<Date> generateSetDate(List<SObject> sobjects, String key) {
        Set<Date> result = new Set<Date>();
        loadSetDate(sobjects, key, result);
        return result;
    }

    public static Set<Object> generateSetObject(List<SObject> sobjects, String key) {
        Set<Object> result = new Set<Object>();
        for (SObject sobj : sobjects) {
            Object value = getObjectValue(sobj, key);
            if (value != null) {
                result.add(value);
            }
        }
        return result;
    }

    public static Map<Id, SObject> generateMapId(List<SObject> sobjects, String key) {
        Map<Id, SObject> result = new Map<Id, SObject>();
        loadMapId(sobjects, key, result);
        return result;
    }

    public static Map<String, SObject> generateMapString(List<SObject> sobjects, String key) {
        Map<String, SObject> result = new Map<String, SObject>();
        loadMapString(sobjects, key, result);
        return result;
    }

    public static Map<Id, List<SObject>> generateMapIdListObject(List<SObject> sobjects, String key) {
        Map<Id, List<SObject>> result = new Map<Id, List<SObject>>();
        loadMapIdListSObject(sobjects, key, result);
        return result;
    }

    public static Map<Date, List<SObject>> generateMapDateListObject(List<SObject> sobjects, String key) {
        Map<Date, List<SObject>> result = new Map<Date, List<SObject>>();
        loadMapDateListSObject(sobjects, key, result);
        return result;
    }

    public static Map<Id, Map<Id, List<SObject>>> generateMapIdMapIdListObject(List<SObject> sobjects, String key, String key2) {
        Map<Id, Map<Id, List<SObject>>> result = new Map<Id, Map<Id, List<SObject>>>();
        loadMapIdMapIdListSObject(sobjects, key, key2, result);
        return result;
    }

    public static Map<String, Map<Date, List<SObject>>> generateMapStringMapDateListObject(
        List<SObject> sobjects,
        String key,
        String key2
    ) {
        Map<String, Map<Date, List<SObject>>> result = new Map<String, Map<Date, List<SObject>>>();
        loadMapStringMapDateListObject(sobjects, key, key2, result);
        return result;
    }

    public static void sortASCByProperty(List<SObject> sobjects, String key) {
        integer length = sobjects.size();
        for (Integer i = 0; i < length; i++) {
            for (Integer j = i + 1; j < length; j++) {
                Object valueOne = getObjectValue(sobjects[i], key);
                Object valueTwo = getObjectValue(sobjects[j], key);
                if (isGreaterThan(valueOne, valueTwo)) {
                    SObject aux = sobjects[i];
                    sobjects[i] = sobjects[j];
                    sobjects[j] = aux;
                }
            }
        }
    }

    private static Boolean isGreaterThan(Object value1, Object value2) {
        if (value1 instanceof Decimal && value2 instanceof Decimal) {
            return (Decimal) value1 > (Decimal) value2;
        } else if (value1 instanceof Integer && value2 instanceof Integer) {
            return (Integer) value1 > (Integer) value2;
        } else if (value1 instanceof String && value2 instanceof String) {
            return (String) value1 > (String) value2;
        } else {
            return false;
        }
    }

    private static Map<Object, SObject> generateMapSObject(List<SObject> sobjects, String key) {
        Map<Object, SObject> result = new Map<Object, SObject>();
        for (SObject sobj : sobjects) {
            result.put(getObjectValue(sobj, key), sobj);
        }
        return result;
    }

    private static Map<Object, List<SObject>> generateMapListSObject(List<SObject> sobjects, String key) {
        Map<Object, List<SObject>> result = new Map<Object, List<SObject>>();
        for (SObject sobj : sobjects) {
            Object keyObj = getObjectValue(sobj, key);
            if (keyObj == null) {
                continue;
            }
            List<SObject> sobjs = result.get(keyObj);
            if (sobjs == null) {
                sobjs = new List<SObject>();
            }
            sobjs.add(sobj);
            result.put(keyObj, sobjs);
        }
        return result;
    }

    private static void loadSetId(List<SObject> sobjects, String key, Set<Id> setTo) {
        for (Object obj : generateSetObject(sobjects, key)) {
            setTo.add(String.valueOf(obj));
        }
    }

    private static void loadSetString(List<SObject> sobjects, String key, Set<String> setTo) {
        for (Object obj : generateSetObject(sobjects, key)) {
            setTo.add(String.valueOf(obj));
        }
    }

    private static void loadSetDate(List<SObject> sobjects, String key, Set<Date> setTo) {
        for (Object obj : generateSetObject(sobjects, key)) {
            setTo.add(Date.valueOf(obj));
        }
    }

    private static void loadMapId(List<SObject> sobjects, String key, Map<Id, SObject> mapTo) {
        Map<Object, SObject> mapFrom = generateMapSObject(sobjects, key);
        for (Object obj : mapFrom.keySet()) {
            if (String.valueOf(obj) != null) {
                mapTo.put(String.valueOf(obj), mapFrom.get(obj));
            }
        }
    }

    private static void loadMapIdListSObject(List<SObject> sobjects, String key, Map<Id, List<SObject>> mapTo) {
        Map<Object, List<SObject>> mapFrom = generateMapListSObject(sobjects, key);
        for (Object obj : mapFrom.keySet()) {
            if (String.valueOf(obj) != null) {
                mapTo.put(String.valueOf(obj), mapFrom.get(obj));
            }
        }
    }

    private static void loadMapDateListSObject(List<SObject> sobjects, String key, Map<Date, List<SObject>> mapTo) {
        Map<Object, List<SObject>> mapFrom = generateMapListSObject(sobjects, key);
        for (Object obj : mapFrom.keySet()) {
            if (Date.valueOf(obj) != null) {
                mapTo.put(Date.valueOf(obj), mapFrom.get(obj));
            }
        }
    }

    private static void loadMapIdMapIdListSObject(List<SObject> sobjects, String key, String key2, Map<Id, Map<Id, List<SObject>>> mapTo) {
        Set<Id> keys1 = generateSetId(sobjects, key);
        Set<Id> keys2 = generateSetId(sobjects, key2);

        for (Id key1 : keys1) {
            List<SObject> sobjectsKey1 = filterByProperty(sobjects, key, key1);

            mapTo.put(key1, generateMapIdListObject(sobjectsKey1, key2));
        }
    }

    private static void loadMapStringMapDateListObject(
        List<SObject> sobjects,
        String key,
        String key2,
        Map<String, Map<Date, List<SObject>>> mapTo
    ) {
        Set<String> keys1 = generateSetString(sobjects, key);
        Set<Date> keys2 = generateSetDate(sobjects, key2);

        for (String key1 : keys1) {
            List<SObject> sobjectsKey1 = filterByProperty(sobjects, key, key1);

            mapTo.put(key1, generateMapDateListObject(sobjectsKey1, key2));
        }
    }

    private static void loadMapString(List<SObject> sobjects, String key, Map<String, SObject> mapTo) {
        Map<Object, SObject> mapFrom = generateMapSObject(sobjects, key);
        for (Object obj : mapFrom.keySet()) {
            mapTo.put(String.valueOf(obj), mapFrom.get(obj));
        }
    }

    public static SObject getObject(SObject sobj, String fieldName) {
        List<String> keys = fieldName.split('\\.');
        Integer lastElement = keys.size() - 1;
        for (Integer i = 0; i < lastElement; i++) {
            sobj = sobj.getSObject(keys[i]);
            if (sobj == null) {
                return null;
            }
        }
        return sobj;
    }

    public static Object getObjectValue(SObject sobj, String fieldName) {
        List<String> keys = fieldName.split('\\.');
        Integer lastElement = keys.size() - 1;
        for (Integer i = 0; i < lastElement; i++) {
            sobj = sobj.getSObject(keys[i]);
            if (sobj == null) {
                return null;
            }
        }
        return sobj.get(keys[lastElement]);
    }

    public static String getObjectType(Object obj) {
        String result = 'DateTime';

        try {
            DateTime typeCheck = (DateTime) obj;
        } catch (System.TypeException te) {
            String message = te.getMessage().substringAfter('Invalid conversion from runtime type ');
            result = message.substringBefore(' to Datetime');
        }

        return result;
    }

    public static void setObjectValue(SObject sobj, String fieldName, Object value) {
        List<String> keys = fieldName.split('\\.');

        Integer lastElement = keys.size() - 1;

        sobj = getObject(sobj, fieldName);

        if (sobj != null) {
            sobj.put(keys[lastElement], value);
        }
    }

    public static Decimal sumProperty(List<SObject> sobjects, String key) {
        return sumProperty(sobjects, new Set<String>{ key }).get(key);
    }

    public static Map<String, Decimal> sumProperty(List<SObject> sobjects, Set<String> keys) {
        Map<String, Decimal> result = new Map<String, Decimal>();

        for (String key : keys) {
            result.put(key, 0);
        }

        for (SObject sobj : sobjects) {
            for (String key : keys) {
                Decimal value = (Decimal) getObjectValue(sobj, key);

                result.put(key, result.get(key) + (value != null ? value : 0));
            }
        }

        return result;
    }

    public static void putMap(Map<Id, List<SObject>> mapTo, Id key, SObject value) {
        List<SObject> sObjects;

        if (mapTo.containsKey(key)) {
            sObjects = mapTo.get(key);
        } else {
            sObjects = new List<SObject>();
        }

        sObjects.add(value);

        mapTo.put(key, sObjects);
    }

    public static void putMap(Map<Id, Set<Id>> mapTo, Id key, Id value) {
        Set<Id> ids;

        if (mapTo.containsKey(key)) {
            ids = mapTo.get(key);
        } else {
            ids = new Set<Id>();
        }

        ids.add(value);

        mapTo.put(key, ids);
    }

    public static void setValueToField(List<SObject> sObjects, String fieldName, Object value) {
        setValueToField(sObjects, new Map<String, Object>{ fieldName => value });
    }

    public static void setValueToField(List<SObject> sObjects, Map<String, Object> valueByFieldName) {
        for (SObject sobj : sObjects) {
            for (String fieldName : valueByFieldName.keySet()) {
                setObjectValue(sobj, fieldName, valueByFieldName.get(fieldName));
            }
        }
    }

    public static SObject getLastItem(List<SObject> sObjects) {
        return sObjects != null && sObjects.size() > 0 ? sObjects[sObjects.size() - 1] : null;
    }

    private static Boolean checkValue(Object value1, Object value2) {
        String value2Type = getObjectType(value2);

        if ((value2 instanceof Iterable<Object>) || value2Type.startsWith('Set<')) {
            return contains(value1, value2);
        } else {
            return compare(value1, value2);
        }
    }

    private static Boolean compare(Object value1, Object value2) {
        if (value1 instanceof String) {
            return (value2 != null) && String.valueOf(value2).equalsIgnoreCase(String.valueOf(value1));
        } else {
            return value1 == value2;
        }
    }

    private static Boolean contains(Object value1, Object value2) {
        String value2Type = getObjectType(value2);

        if (!(value2 instanceof Iterable<Object>) && !value2Type.startsWith('Set<')) {
            return false;
        }

        Iterable<Object> itarable = (Iterable<Object>) value2;

        Iterator<Object> iterator = itarable.iterator();

        while (iterator.hasNext()) {
            if (compare(value1, iterator.next())) {
                return true;
            }
        }

        return false;
    }
}
