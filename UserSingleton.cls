public class UserSingleton extends Singleton{
    private static final List<User> USERS = [
        SELECT 
            Id, Name, ProfileId , Profile.Name, 
            Email, ManagerId, UserRoleId, Manager.Email, 
            Manager.UserRoleId, UserRole.Name, 
            (SELECT PermissionSet.Label, PermissionSet.PermissionsViewAllData FROM PermissionSetAssignments) 
        FROM User 
        WHERE IsActive = true
        ORDER BY UserRoleId NULLS LAST
    ];

    private static Map<Id, User> mapUsers = new Map<Id, User>(USERS);
    private static Map<Id, List<SObject>> mapAllData = 
    CollectionUtils.generateMapIdListObject(
        [SELECT AssigneeId 
        FROM PermissionSetAssignment 
        WHERE PermissionSet.PermissionsViewAllData = true],
        'AssigneeId');

    public List<User> usersList {
        get {
            return USERS;
        }
        private set;
    }
    
    public profile getProfileByUser(Id userId){
        User us = mapUsers.get(userId);
        return new Profile(Id = us.ProfileId, Name = us.Profile.Name);
    }

    public User getUser(Id userId){
        User userResult = mapUsers.get(userId);
        if (userResult == null) {
            return new User();
        }
        return userResult;
    }

    public User getManagerFromUser(Id userId){
        if (mapUsers.get(userId)?.ManagerId == null) {
            return new User();
        }
        return mapUsers.get(mapUsers.get(userId).ManagerId);
    }

    public Boolean hasViewAllData(Id userId){
        return mapAllData.get(userId) != null;
    } 
}