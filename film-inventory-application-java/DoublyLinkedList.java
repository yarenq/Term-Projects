package FinalProject;

import java.io.*;
import java.util.ArrayList;
import java.util.InputMismatchException;
import java.util.Scanner;

public class DoublyLinkedList {
    private Node head;
    private Node tail;

    DoublyLinkedIterator iterator = new DoublyLinkedIterator(); // Create an instance of the iterator

    //constructors
    public DoublyLinkedList( ) {
        this.head = null;
        this.tail = null;
        }

    //NODE CLASS
    public class Node {
        private Movie movieInfo;
        private Node previous;
        private Node next;

        //constructors
        public Node(){
            setMovieInfo(null);
            setPrevious(null);
            setNext(null);
        }
        public Node(Movie newMovieInfo, Node previousNode, Node nextNode){
            this.movieInfo = newMovieInfo;
            this.previous = previousNode;
            this.next = nextNode;
        }
        public Node(Movie newMovieInfo){
            this.movieInfo = newMovieInfo;
        }

        public Node(Movie newMovieInfo, Node nextNode){
            this.movieInfo = newMovieInfo;
            this.next = nextNode;
        }

        // accessor/mutator methods
        public Movie getMovieInfo() {
            return movieInfo;
        }

        public void setMovieInfo(Movie movieInfo) {
            this.movieInfo = movieInfo;
        }

        public Node getPrevious() {
            return previous;
        }

        public void setPrevious(Node previous) {
            this.previous = previous;
        }

        public Node getNext() {
            return next;
        }
        public void setNext(Node next) {
            this.next = next;
        }
    }

    //EXTRA METHODS
    public boolean isEmpty(){
        return(head == null);
    }

    public void printFromHead() { //command 5
        Node currentNode = head;
        while (currentNode != null) {
            System.out.println(currentNode.getMovieInfo());
            currentNode = currentNode.getNext();
        }
    }

    public void printFromTail() { //command 6
        Node currentNode = tail;

        while (currentNode != null) {
            System.out.println(currentNode.getMovieInfo());
            currentNode = currentNode.getPrevious();
        }
    }

    //ITERATOR CLASS
    public class DoublyLinkedIterator<T extends Comparable<T>> implements Comparable<DoublyLinkedIterator<T>> {
        private Node position;
        public DoublyLinkedIterator iterator( ){
            return new DoublyLinkedIterator( );
        }

        //constructor
        public DoublyLinkedIterator() {
            setPosition(head);
        }

        //accessor/mutator methods
        public Node getPosition() {
            return position;
        }

        public void setPosition(Node position) {
            this.position = position;
        }
        public boolean isEmpty(){
            return (head==null);
        }


        @Override
        public int compareTo(DoublyLinkedIterator<T> other) {
            // Compare the positions of the two iterators based on the movie's year and name
            if (this.getPosition().getMovieInfo().getYear() < other.getPosition().getMovieInfo().getYear()) {
                return -1;
            } else if (this.getPosition().getMovieInfo().getYear() > other.getPosition().getMovieInfo().getYear()) {
                return 1;
            } else {
                // If the years are equal, compare based on movie name
                return this.getPosition().getMovieInfo().getTitle().compareTo(other.getPosition().getMovieInfo().getTitle());
            }
        }

        public Node findByName(String enteredMovie){
            Node position = head;
            String itemAtPosition;
            while (position != null){
                itemAtPosition = position.getMovieInfo().getTitle();
                if (itemAtPosition.equalsIgnoreCase(enteredMovie)){
                    iterator.setPosition(position);
                    return position;
                } //returns the position of the movie given
                position = position.getNext();
            }
            return null; //target was not found
        }

        public Movie returnMovieInfo(Node position){ //returns info of the movie in given position
            return position.getMovieInfo();
        }

        public void moviesBefore2000(){
            Node position = head;
            while(position.getMovieInfo().getYear() <= 2000 && position != null){
                System.out.println(position.getMovieInfo());
                position = position.getNext();
            }
        }

        public void addMovie(){
            Scanner keyboard = new Scanner(System.in);
            System.out.println("Please enter the information of the movie you want to add: ");
            int year;
            while (true) {
                try {
                    System.out.println("Year: ");
                    year = keyboard.nextInt();
                    keyboard.nextLine();
                    if (year > 0) {
                        break;
                    } else {
                        System.out.println("Invalid year. Please enter a positive number.");
                    }
                } catch (InputMismatchException e) {
                    System.out.println("Invalid input. Please enter a valid year.");
                    keyboard.nextLine(); // Clear the input buffer
                }
            }
            System.out.println("Title: ");
            String title = keyboard.nextLine();
            System.out.println("Genre: ");
            String genre = keyboard.nextLine();
            System.out.println("Director: ");
            String director = keyboard.nextLine();
            //actors class will be different here
            System.out.println("Actors: ");
            ArrayList<Actor> actors = new ArrayList<>();
            String addMoreActors = "";
            while (!addMoreActors.equalsIgnoreCase("n")) {
                System.out.println("Please enter information about the actor/actress");
                System.out.println("Name Surname: ");
                String nameSurname = keyboard.nextLine();
                System.out.println("Gender: ");
                String gender = keyboard.nextLine();
                System.out.println("Citizenship: ");
                String citizenship = keyboard.nextLine();

                actors.add(new Actor(nameSurname, gender, citizenship));

                System.out.println("Would you like to add more actors?(y/n): ");
                addMoreActors = keyboard.nextLine();
            }
            Movie newMovie = new Movie(year, title, genre, director, actors);
            iterator.insertHere(newMovie);
        }

        //command 1 - reading from the file and creating a doubly  linked list
        public void readFromFile() throws FileNotFoundException {
            Scanner fileIn = null;
            fileIn = new Scanner(
                    new FileInputStream("C:\\Users\\yaren\\IdeaProjects\\untitled\\src\\FinalProject\\information.txt"));

            while (fileIn.hasNextLine()){
                String line = fileIn.nextLine();
                String[] movieInfo = line.split(", ",5);

                int year = Integer.parseInt(movieInfo[0]);
                String title = movieInfo[1];
                String genre = movieInfo[2];
                String director = movieInfo[3];

                ArrayList<Actor> actorsList = new ArrayList<>();
                String actorsText = movieInfo[4];
                actorsText = actorsText.substring(2, actorsText.length() - 2);

                for (String actorText : actorsText.split("\\)\\(")) {
                    String[] actorInfo = actorText.split(", ");
                    actorsList.add(new Actor(actorInfo[0], actorInfo[1], actorInfo[2]));
                }
                Movie movie = new Movie(year, title, genre, director, actorsList);
                iterator.insertHere(movie);

            }
        }

        public void writeToFile() { //command 8
            try (BufferedWriter writer = new BufferedWriter(new FileWriter("C:\\Users\\yaren\\IdeaProjects\\untitled\\src\\FinalProject\\information.txt"))) {
                Node currentNode = head;

                while (currentNode != null) {
                    Movie movie = currentNode.getMovieInfo();
                    String line = movie.getYear() + ", " + movie.getTitle() + ", " + movie.getGenre() + ", " +
                            movie.getDirector() + "\n" + movie.getActors().toString();
                    writer.write(line);
                    writer.newLine();
                    writer.newLine();
                    currentNode = currentNode.getNext();
                }
                System.out.println("Data written to file successfully.");
            } catch (IOException e) {
                System.out.println("Error writing to file: " + e.getMessage());
            }
        }

        public void insertHere(Movie newMovieInfo) {
            if (isEmpty()) {
                head = tail = new Node(newMovieInfo, null, null);
            } else if (head.getMovieInfo().getYear() > newMovieInfo.getYear()) {
                // Insert at the beginning
                head.setPrevious(new Node(newMovieInfo, null, head));
                head = head.getPrevious();
            } else if (tail.getMovieInfo().getYear() <= newMovieInfo.getYear()) {
                // Insert at the end
                tail.setNext(new Node(newMovieInfo, tail, null));
                tail = tail.getNext();
            } else {
                Node currentNode = head.getNext();
                // Find the correct insert position
                while (currentNode.getMovieInfo().getYear() <= newMovieInfo.getYear()) {
                    if (currentNode.getMovieInfo().getYear() == newMovieInfo.getYear()) {
                        // If the years are equal, compare based on movie title
                        if (currentNode.getMovieInfo().getTitle().compareTo(newMovieInfo.getTitle()) > 0) {
                            break;
                        }
                    }
                    currentNode = currentNode.getNext();
                }

                // Insert the new movie before the currentNode
                Node newNode = new Node(newMovieInfo, currentNode.getPrevious(), currentNode);
                currentNode.getPrevious().setNext(newNode);
                currentNode.setPrevious(newNode);
            }
        }

        public void delete(Node position) {
            if (position == null) {
                throw new IllegalStateException();
            } else if (position.previous == null) {
                // Deleting first node
                head = head.next;
                if (head != null) {
                    head.previous = null;
                } else {
                    tail = null; // Update tail when deleting the last node
                }
            } else if (position.next == null) {
                // Deleting last node
                position.previous.next = null;
                tail = position.previous; // Update tail when deleting the last node
            } else {
                position.previous.next = position.next;
                position.next.previous = position.previous;
            }
        }
    }
}
