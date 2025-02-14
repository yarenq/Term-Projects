import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.List;

public class SearchUsersFrame extends JFrame {
    private User currentUser;
    private JTextField searchField;
    private DefaultListModel<User> searchListModel;
    private JList<User> searchList;

    public SearchUsersFrame(User currentUser) {
        this.currentUser = currentUser;

        setTitle("Search Users");
        setSize(400, 300);
        setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
        setLocationRelativeTo(null);

        JPanel panel = new JPanel(new BorderLayout());
        panel.setBackground(new Color(152, 197, 239));

        searchField = new JTextField(15);
        JButton searchButton = new JButton("Search");

        JPanel searchPanel = new JPanel();
        searchPanel.add(new JLabel("Search:"));
        searchPanel.add(searchField);
        searchPanel.add(searchButton);

        searchListModel = new DefaultListModel<>();
        searchList = new JList<>(searchListModel);
        searchList.setFont(new Font("Arial", Font.PLAIN, 14));
        JScrollPane scrollPane = new JScrollPane(searchList);

        panel.add(searchPanel, BorderLayout.NORTH);
        panel.add(scrollPane, BorderLayout.CENTER);

        add(panel);

        searchButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                searchUsers();
            }
        });

        searchList.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                JList<User> list = (JList<User>) evt.getSource();
                if (evt.getClickCount() == 2) {
                    int index = list.locationToIndex(evt.getPoint());
                    User selectedUser = list.getModel().getElementAt(index);
                    int confirm = JOptionPane.showConfirmDialog(SearchUsersFrame.this,
                            "Do you want to add " + selectedUser.getFirstName() + " as a friend?",
                            "Add Friend Confirmation", JOptionPane.YES_NO_OPTION);
                    if (confirm == JOptionPane.YES_OPTION) {
                        addFriend(selectedUser);
                    }
                }
            }
        });
    }

    //searches for users in the database
    private void searchUsers() {
        String name = searchField.getText().trim();
        List<User> searchResults = UserDatabase.getInstance().searchUsers(name);
        searchListModel.clear();
        for (User user : searchResults) {
            searchListModel.addElement(user);
        }
    }

    private void addFriend(User friend) {
        currentUser.getFriends().add(friend);
        //notifies the added friend
        friend.update(currentUser.getFirstName() + " " + currentUser.getLastName() + " added you as a friend!");
        JOptionPane.showMessageDialog(SearchUsersFrame.this,
                friend.getFirstName() + " has been added as a friend!",
                "Friend Added", JOptionPane.INFORMATION_MESSAGE);
    }
}
