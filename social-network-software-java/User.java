import java.util.ArrayList;
import java.util.List;

public class User implements Subject, Observer {
    private String firstName;
    private String lastName;
    private String email;
    private String password;
    private int age;
    private String birthday;
    private String primaryInterest;
    private String secondaryInterest;
    private List<User> friends;
    private List<User> friendRequests;
    private boolean searchable;
    private List<Observer> observers;
    private List<String> notifications;

    //constructor method
    public User(String firstName, String lastName, String email, String password, int age, String birthday, String primaryInterest, String secondaryInterest) {
        this.firstName = firstName;
        this.lastName = lastName;
        this.email = email;
        this.password = password;
        this.age = age;
        this.birthday = birthday;
        this.primaryInterest = primaryInterest;
        this.secondaryInterest = secondaryInterest;
        this.friends = new ArrayList<>();
        this.friendRequests = new ArrayList<>();
        this.searchable = true;
        this.observers = new ArrayList<>();
        this.notifications = new ArrayList<>();
    }

    //implementing the subject method
    @Override
    public void attach(Observer observer) {
        observers.add(observer);
    }

    //implementing the observer method
    @Override
    public void update(String notification) {
        notifications.add(notification);
    }

    //get set methods
    public String getFirstName() { return firstName; }
    public void setFirstName(String firstName) { this.firstName = firstName; }

    public String getLastName() { return lastName; }
    public void setLastName(String lastName) { this.lastName = lastName; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public int getAge() { return age; }
    public void setAge(int age) { this.age = age; }

    public String getBirthday() { return birthday; }
    public void setBirthday(String birthday) { this.birthday = birthday; }

    public String getPrimaryInterest() { return primaryInterest; }
    public void setPrimaryInterest(String primaryInterest) { this.primaryInterest = primaryInterest; }

    public String getSecondaryInterest() { return secondaryInterest; }
    public void setSecondaryInterest(String secondaryInterest) { this.secondaryInterest = secondaryInterest; }

    public List<User> getFriends() { return friends; }
    public void setFriends(List<User> friends) { this.friends = friends; }

    public List<String> getNotifications() {
        return notifications;
    }

    public List<User> getFriendRequests() { return friendRequests; }
    public void setFriendRequests(List<User> friendRequests) { this.friendRequests = friendRequests; }

    public boolean isSearchable() { return searchable; }
    public void setSearchable(boolean searchable) { this.searchable = searchable; }

    @Override
    public String toString() {
        return firstName + " " + lastName;
    }

}
