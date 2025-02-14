package FinalProject;

public class Actor {
    private String nameSurname;
    private String gender;
    private String citizenship;

    //constructor methods
    public Actor(){
        setGender(null);
        setNameSurname(null);
        setCitizenship(null);
    }
    public Actor(String nameSurname, String gender, String citizenship){
        this.setNameSurname(nameSurname);
        this.setGender(gender);
        this.setCitizenship(citizenship);
    }
    public Actor(Actor a){
        this.nameSurname = a.nameSurname;
        this.gender = a.gender;
        this.citizenship = a.citizenship;
    }

    //accessor/mutator methods
    public String getNameSurname() {
        return nameSurname;
    }

    public void setNameSurname(String nameSurname) {
        this.nameSurname = nameSurname;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getCitizenship() {
        return citizenship;
    }

    public void setCitizenship(String citizenship) {
        this.citizenship = citizenship;
    }

    //to string method
    @Override
    public String toString() {
        return  "Actor Info:"+"\n" +"Name Surname: " + nameSurname + "\n" + "Gender: " + gender +"\n" + "Citizenship: "
                + citizenship;
    }
}
