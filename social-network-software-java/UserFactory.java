public class UserFactory { //FACTORY DESIGN PATTERN
    public static User createUser(String firstName, String lastName, String email, String password, int age, String birthday, String primaryInterest, String secondaryInterest) {
        return new User(firstName, lastName, email, password, age, birthday, primaryInterest, secondaryInterest);
    }
}
