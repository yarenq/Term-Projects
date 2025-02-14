import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class UserDatabase {
    private static UserDatabase instance; // using singleton design pattern to create the database
    // keeps the lists of users and posts in the database
    private List<User> users;
    private Map<User, List<String>> postsMap;

    private UserDatabase() {
        users = new ArrayList<>();
        postsMap = new HashMap<>();
    }

    public static UserDatabase getInstance() {
        if (instance == null) {
            instance = new UserDatabase();
        }
        return instance;
    }

    // adds users using UserFactory
    public void addUser(String firstName, String lastName, String email, String password, int age, String birthday, String primaryInterest, String secondaryInterest) {
        User user = UserFactory.createUser(firstName, lastName, email, password, age, birthday, primaryInterest, secondaryInterest);
        users.add(user);
    }

    // adds posts to the user or friends wall
    public void addPost(User wallOwner, User poster, String postText) {
        List<String> posts = postsMap.getOrDefault(wallOwner, new ArrayList<>());
        posts.add(poster.getFirstName() + ": " + postText);
        postsMap.put(wallOwner, posts);
    }

    // method to check if user exists, at the login frame
    public User findUserByEmail(String email) {
        for (User user : users) {
            if (user.getEmail().equals(email)) {
                return user;
            }
        }
        return null;
    }

    // searches users that exist in the database
    public List<User> searchUsers(String name) {
        List<User> result = new ArrayList<>();
        String lowerCaseName = name.toLowerCase();
        for (User user : users) {
            if ((user.getFirstName() + " " + user.getLastName()).toLowerCase().contains(lowerCaseName) && user.isSearchable()) {
                result.add(user);
            }
        }
        return result;
    }

    public List<String> getPosts(User user) {
        return postsMap.getOrDefault(user, new ArrayList<>());
    }
}
