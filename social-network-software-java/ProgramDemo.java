public class ProgramDemo { //the main program class
    public static void main(String[] args) {
        UserDatabase db = UserDatabase.getInstance();
        //demo users
        db.addUser("John", "Doe", "john@example.com", "password123", 25, "1998-05-14", "Music", "Movies");
        db.addUser("Jane", "Smith", "jane@example.com", "password456", 30, "1993-08-22", "Books", "Travel");
        db.addUser("Alice", "Johnson", "alice@example.com", "password789", 27, "1996-02-11", "Art", "Fitness");
        db.addUser("Bob", "Brown", "bob@example.com", "password101", 22, "2001-01-19", "Tech", "Gaming");
        db.addUser("Charlie", "Davis", "charlie@example.com", "password202", 35, "1989-11-05", "Cooking", "Travel");

        new LoginFrame();
    }
}
