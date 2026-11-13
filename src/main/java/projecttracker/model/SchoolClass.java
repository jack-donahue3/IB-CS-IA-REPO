package projecttracker.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "classes")
public class SchoolClass {
    //columns
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(nullable = false, length = 255)
    private String name;

    private Integer period;

    @Column(length = 20)
    private String year;

    @Column(length = 50)
    private String level;

    @Column(name = "join_code", nullable = false, unique = true, length = 50)
    private String joinCode;

    @Column(name = "created_at", insertable = false, updatable = false)
    private LocalDateTime createdAt;

    //constructors
    protected SchoolClass() {}

    public SchoolClass(String name, Integer period, String year, String level, String joinCode) {
        this.name = name;
        this.period = period;
        this.year = year;
        this.level = level;
        this.joinCode = joinCode;
    }

    //getters
    public Integer getId() {return id;}
    public String getName() {return name;}
    public Integer getPeriod() {return period;}
    public String getYear() {return year;}
    public String getLevel() {return level;}
    public String getJoinCode() {return joinCode;}
    public LocalDateTime getCreatedAt() {return createdAt;}

    //setters
    public void setName(String name) {this.name = name;}
    public void setPeriod(Integer period) {this.period = period;}
    public void setYear(String year) {this.year = year;}
    public void setLevel(String level) {this.level = level;}
    public void setJoinCode(String joinCode) {this.joinCode = joinCode;}
}
