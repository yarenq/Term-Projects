package FinalProject;

import java.util.ArrayList;

public class Movie {
    private int year;
    private String title;
    private String genre;
    private String director;
    private ArrayList<Actor> actors;

    //constructor methods
    public Movie(){
        setYear(0);
        setTitle(null);
        setGenre(null);
        setDirector(null);
        setActors(null);

    }
    public Movie(int year, String title, String genre, String director, ArrayList<Actor> actors){
        this.setYear(year);
        this.setTitle(title);
        this.setGenre(genre);
        this.setDirector(director);
        this.setActors(actors);
    }
    public Movie(Movie m){
        this.year = m.year;
        this.title = m.title;
        this.genre = m.genre;
        this.director = m.director;
        this.actors = m.actors;
    }

    //accessor/mutator methods
    public int getYear() {
        return year;
    }

    public void setYear(int year) {
        this.year = year;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getGenre() {
        return genre;
    }

    public void setGenre(String genre) {
        this.genre = genre;
    }

    public String getDirector() {
        return director;
    }

    public void setDirector(String director) {
        this.director = director;
    }
    public ArrayList<Actor> getActors() {
        return actors;
    }
    public void setActors(ArrayList<Actor> actors) {
        this.actors = actors;
    }

    //to string method
    @Override
    public String toString() {
        return  "\n" +"Year: " + year + "\n" + "Title: " + title +"\n" + "Genre: " + genre + "\n" +
                "Director's Name-Surname:" + director + "\n" +actors.toString() ;
    }
}


