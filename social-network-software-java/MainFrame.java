import javax.swing.*;
import java.awt.*;
import java.util.ArrayList;
import java.util.List;

public class MainFrame extends JFrame implements Observer {
    private User user;
    private JCheckBox searchableCheckBox;
    private JTextArea wallTextArea;
    private List<String> notifications;

    public MainFrame(User user) {
        this.user = user;
        this.user.attach(this); // attaching MainFrame as an observer
        this.notifications = new ArrayList<>(user.getNotifications());

        setTitle("Social Network");
        setSize(600, 500);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setLocationRelativeTo(null);

        JPanel panel = new JPanel();
        panel.setBackground(new Color(152, 197, 239));
        panel.setLayout(new BoxLayout(panel, BoxLayout.Y_AXIS));
        panel.setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));

        // displays the user info
        JLabel nameLabel = new JLabel("Name: " + user.getFirstName() + " " + user.getLastName());
        JLabel emailLabel = new JLabel("Email: " + user.getEmail());
        JLabel ageLabel = new JLabel("Age: " + user.getAge());
        JLabel birthdayLabel = new JLabel("Birthday: " + user.getBirthday());
        JLabel interestsLabel = new JLabel("Interests: " + user.getPrimaryInterest() + ", " + user.getSecondaryInterest());

        nameLabel.setFont(new Font("Arial", Font.BOLD, 16));
        emailLabel.setFont(new Font("Arial", Font.BOLD, 16));
        ageLabel.setFont(new Font("Arial", Font.BOLD, 16));
        birthdayLabel.setFont(new Font("Arial", Font.BOLD, 16));
        interestsLabel.setFont(new Font("Arial", Font.BOLD, 16));

        searchableCheckBox = new JCheckBox("Show in search results", user.isSearchable());
        searchableCheckBox.setBackground(new Color(152, 197, 239));
        searchableCheckBox.setFont(new Font("Arial", Font.PLAIN, 14));
        searchableCheckBox.addActionListener(e -> user.setSearchable(searchableCheckBox.isSelected()));

        wallTextArea = new JTextArea(10, 30);
        wallTextArea.setEditable(false);
        wallTextArea.setFont(new Font("Arial", Font.PLAIN, 14));
        loadPosts();

        JScrollPane scrollPane = new JScrollPane(wallTextArea);
        scrollPane.setPreferredSize(new Dimension(500, 200));

        // displays post area
        JButton postButton = new JButton("Post");
        postButton.setFont(new Font("Arial", Font.BOLD, 14));
        postButton.setBackground(new Color(112, 174, 232)); // Medium purple
        postButton.setForeground(Color.WHITE);
        postButton.addActionListener(e -> {
            String postText = JOptionPane.showInputDialog("Enter your post:");
            if (postText != null && !postText.trim().isEmpty()) {
                UserDatabase.getInstance().addPost(user, user, postText);
                wallTextArea.append(user.getFirstName() + ": " + postText + "\n");
                notifyFriends("New post on your wall from " + user.getFirstName());
            }
        });

        // BUTTONS TO REACH THE OTHER FRAMES

        // opens FriendsFrame
        JButton friendsButton = new JButton("Friends");
        friendsButton.setFont(new Font("Arial", Font.BOLD, 14));
        friendsButton.setBackground(new Color(112, 174, 232));
        friendsButton.setForeground(Color.WHITE);
        friendsButton.addActionListener(e -> showFriends());

        // opens SearchUsersFrame
        JButton searchButton = new JButton("Search Users");
        searchButton.setFont(new Font("Arial", Font.BOLD, 14));
        searchButton.setBackground(new Color(112, 174, 232));
        searchButton.setForeground(Color.WHITE);
        searchButton.addActionListener(e -> showSearchUsers());

        // calls logout method
        JButton logoutButton = new JButton("Logout");
        logoutButton.setFont(new Font("Arial", Font.BOLD, 14));
        logoutButton.setBackground(new Color(112, 174, 232));
        logoutButton.setForeground(Color.WHITE);
        logoutButton.addActionListener(e -> logout());

        // calls the showNotifications method
        JButton notificationsButton = new JButton("Notifications");
        notificationsButton.setFont(new Font("Arial", Font.BOLD, 14));
        notificationsButton.setBackground(new Color(112, 174, 232));
        notificationsButton.setForeground(Color.WHITE);
        notificationsButton.addActionListener(e -> showNotifications());

        // adds the buttons to button panel under the user wall
        JPanel buttonPanel = new JPanel();
        buttonPanel.setBackground(new Color(152, 197, 237));
        buttonPanel.add(postButton);
        buttonPanel.add(friendsButton);
        buttonPanel.add(searchButton);
        buttonPanel.add(logoutButton);
        buttonPanel.add(notificationsButton);

        panel.add(nameLabel);
        panel.add(emailLabel);
        panel.add(ageLabel);
        panel.add(birthdayLabel);
        panel.add(interestsLabel);
        panel.add(searchableCheckBox);
        panel.add(scrollPane);
        panel.add(buttonPanel);

        add(panel);

        setVisible(true);
    }

    private void loadPosts() {
        List<String> posts = UserDatabase.getInstance().getPosts(user);
        for (String post : posts) {
            wallTextArea.append(post + "\n");
        }
    }

    private void showFriends() {
        List<User> friends = user.getFriends();
        FriendsFrame friendsFrame = new FriendsFrame(user, friends);
        friendsFrame.setVisible(true);
    }

    private void showSearchUsers() {
        SearchUsersFrame searchUsersFrame = new SearchUsersFrame(user);
        searchUsersFrame.setVisible(true);
    }

    // closes the user wall and opens LoginFrame again
    private void logout() {
        dispose();
        new LoginFrame();
    }

    // displays the notifications
    private void showNotifications() {
        StringBuilder sb = new StringBuilder();
        for (String notification : notifications) {
            sb.append(notification).append("\n");
        }
        JOptionPane.showMessageDialog(this, sb.toString(), "Notifications", JOptionPane.INFORMATION_MESSAGE);
    }

    // uses the update method from Observer interface to notify the users
    private void notifyFriends(String notification) {
        for (User friend : user.getFriends()) {
            friend.update(notification);
        }
    }

    @Override
    public void update(String notification) {
        notifications.add(notification);
        System.out.println("Notification received: " + notification);
    }
}
