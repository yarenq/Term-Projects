import javax.swing.*;
import java.awt.*;
import java.util.List;

public class FriendsFrame extends JFrame {
    private User currentUser;
    private List<User> friends;

    public FriendsFrame(User currentUser, List<User> friends) {
        this.currentUser = currentUser;
        this.friends = friends;

        setTitle("Friends");
        setSize(400, 300);
        setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
        setLocationRelativeTo(null);

        JPanel panel = new JPanel(new BorderLayout());
        panel.setBackground(new Color(152, 197, 239));

        DefaultListModel<User> model = new DefaultListModel<>();
        for (User friend : friends) {
            model.addElement(friend);
        }
        JList<User> friendsList = new JList<>(model);
        friendsList.setFont(new Font("Arial", Font.PLAIN, 14));
        JScrollPane scrollPane = new JScrollPane(friendsList);

        //creates a button to view the profile of the selected user from friends list
        JButton viewProfileButton = new JButton("View Profile");
        viewProfileButton.setFont(new Font("Arial", Font.BOLD, 14));
        viewProfileButton.setBackground(new Color(112, 174, 232));
        viewProfileButton.setForeground(Color.WHITE);
        viewProfileButton.addActionListener(e -> {
            User selectedUser = friendsList.getSelectedValue();
            if (selectedUser != null) {
                FriendWallFrame friendWallFrame = new FriendWallFrame(selectedUser, currentUser);
                friendWallFrame.setVisible(true);
            } else {
                JOptionPane.showMessageDialog(this, "Please select a friend to view profile.", "No Friend Selected", JOptionPane.INFORMATION_MESSAGE);
            }
        });

        panel.add(scrollPane, BorderLayout.CENTER);
        panel.add(viewProfileButton, BorderLayout.SOUTH);

        add(panel);
        setVisible(true);
    }
}
