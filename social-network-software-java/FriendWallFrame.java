import javax.swing.*;
import java.awt.*;

public class FriendWallFrame extends JFrame {
    private User friend;
    private User currentUser;
    private JTextArea wallTextArea;

    public FriendWallFrame(User friend, User currentUser) {
        this.friend = friend;
        this.currentUser = currentUser;

        setTitle(friend.getFirstName() + "'s Wall");
        setSize(600, 500);
        setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
        setLocationRelativeTo(null);

        JPanel panel = new JPanel();
        panel.setBackground(new Color(152, 197, 239));
        panel.setLayout(new BoxLayout(panel, BoxLayout.Y_AXIS));
        panel.setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));

        //displays the friends user information
        JLabel nameLabel = new JLabel("Name: " + friend.getFirstName() + " " + friend.getLastName());
        JLabel emailLabel = new JLabel("Email: " + friend.getEmail());
        JLabel ageLabel = new JLabel("Age: " + friend.getAge());
        JLabel birthdayLabel = new JLabel("Birthday: " + friend.getBirthday());
        JLabel interestsLabel = new JLabel("Interests: " + friend.getPrimaryInterest() + ", " + friend.getSecondaryInterest());

        nameLabel.setFont(new Font("Arial", Font.BOLD, 16));
        emailLabel.setFont(new Font("Arial", Font.BOLD, 16));
        ageLabel.setFont(new Font("Arial", Font.BOLD, 16));
        birthdayLabel.setFont(new Font("Arial", Font.BOLD, 16));
        interestsLabel.setFont(new Font("Arial", Font.BOLD, 16));

        wallTextArea = new JTextArea(10, 30);
        wallTextArea.setEditable(false);
        wallTextArea.setFont(new Font("Arial", Font.PLAIN, 14));

        JScrollPane scrollPane = new JScrollPane(wallTextArea);
        scrollPane.setPreferredSize(new Dimension(500, 200));

        //creates button to post a text on friends wall
        JButton postButton = new JButton("Post");
        postButton.setFont(new Font("Arial", Font.BOLD, 14));
        postButton.setBackground(new Color(112, 174, 232)); // Medium purple
        postButton.setForeground(Color.WHITE);
        postButton.addActionListener(e -> {
            String postText = JOptionPane.showInputDialog("Enter your post:");
            if (postText != null && !postText.trim().isEmpty()) {
                UserDatabase.getInstance().addPost(friend, currentUser, postText);
                wallTextArea.append(currentUser.getFirstName() + ": " + postText + "\n");
            }
        });

        panel.add(nameLabel);
        panel.add(emailLabel);
        panel.add(ageLabel);
        panel.add(birthdayLabel);
        panel.add(interestsLabel);
        panel.add(scrollPane);
        panel.add(postButton);

        add(panel);

        //displays the friends wall posts
        for (String post : UserDatabase.getInstance().getPosts(friend)) {
            wallTextArea.append(post + "\n");
        }
        setVisible(true);
    }
}
