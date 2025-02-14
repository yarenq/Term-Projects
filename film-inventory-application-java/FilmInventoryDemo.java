package FinalProject;

import java.io.FileNotFoundException;
import java.util.Scanner;

public class FilmInventoryDemo {
    public static void main(String[] args) throws FileNotFoundException {
        DoublyLinkedList doublyLinkedList = new DoublyLinkedList();
        DoublyLinkedList.DoublyLinkedIterator iterator = doublyLinkedList.new DoublyLinkedIterator();
        boolean exit = false;
        boolean fileRead = false;

        //USER INTERFACE AND COMMANDS
        Scanner keyboard = new Scanner(System.in);
        int choice = 0;
        System.out.println("Welcome to the Film Inventory Application!");
        System.out.println("------------------------------------");
        while(choice!=8 && !exit){
            System.out.println(" ");
            System.out.println("1) Read information from file");
            System.out.println("2) Add a movie to the list");
            System.out.println("3) Search a movie by name");
            System.out.println("4) Delete a movie from the list");
            System.out.println("5) Print all movies from head");
            System.out.println("6) Print all movies from tail");
            System.out.println("7) Print all movies that were made before 2000");
            System.out.println("8) EXIT");
            System.out.println("--------------------------------------");
            System.out.println("Please enter the number of your command: ");
            choice = keyboard.nextInt();

            switch (choice) {
                case 1 -> {
                    if (!fileRead){
                    iterator.readFromFile();
                    fileRead = true;
                    System.out.println("List created successfully.");
                    break;}
                    System.out.println("File has already been read.");
                }
                case 2 -> {
                    iterator.addMovie();
                    System.out.println("Movie added successfully.");
                }
                case 3 -> {
                    System.out.println("Please enter the name of the movie: ");
                    keyboard.nextLine();
                    String enteredMovie = keyboard.nextLine();
                    if (iterator.findByName(enteredMovie) != null) {
                        Movie movieInfo = (iterator.returnMovieInfo(iterator.findByName(enteredMovie)));
                        System.out.println(movieInfo.toString());
                        break;
                    }
                    System.out.println("Movie not found.");
                }
                case 4 -> {
                    System.out.println("Please enter the name of the movie you want to delete: ");
                    keyboard.nextLine();
                    String deletedMovie = keyboard.nextLine();
                    if (iterator.findByName(deletedMovie) != null) {
                        iterator.delete(iterator.findByName(deletedMovie));
                        System.out.println("Movie deleted successfully.");
                        break;
                    }
                    System.out.println("Movie not found.");
                }
                case 5 -> {
                    if (!iterator.isEmpty()) {
                        doublyLinkedList.printFromHead();
                        break;
                    }
                    System.out.println("List is empty.");
                }
                case 6 -> {
                    if (!iterator.isEmpty()) {
                        doublyLinkedList.printFromTail();
                        break;
                    }
                    System.out.println("List is empty.");
                }
                case 7 -> {
                    if (!iterator.isEmpty()) {
                        iterator.moviesBefore2000();
                        break;
                    }
                    System.out.println("List is empty.");
                }
                case 8 -> {
                    System.out.println("Saving to file...");
                    iterator.writeToFile();
                    System.out.println("Exiting the program.");
                    exit = true;
                }
            }
        }
    }
}

