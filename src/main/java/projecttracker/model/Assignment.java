package projecttracker.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "assignments")
public class Assignment {
    //columns
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(nullable = false, length = 255)
    private String title;

    private String description;

    @Column(name = "due_date")
    private LocalDateTime dueDate;

    private Integer points;

    //link to teacher creator
    @ManyToOne 
    @JoinColumn(name = "created_by", nullable = false)
    private User createdBy;

    @Column(name = "created_at", insertable = false, updatable = false)
    private LocalDateTime createdAt;

    //constructors
    protected Assignment() {}

    public Assignment(String title, String description, LocalDateTime dueDate, Integer points, User createdBy) {
        this.title = title;
        this.description = description;
        this.dueDate = dueDate;
        this.points = points;
        this.createdBy = createdBy;
    }

    //getters
    public Integer getId() {return id;}
    public String getTitle() {return title;}
    public String getDescription() {return description;}
    public LocalDateTime getDueDate() {return dueDate;}
    public Integer getPoints() {return points;}
    public User getCreatedBy() {return createdBy;}
    public LocalDateTime getCreatedAt() {return createdAt;}

    //setters
    public void setTitle(String title) {this.title = title;}
    public void setDescription(String description) {this.description = description;}
    public void setDueDate(LocalDateTime dueDate) {this.dueDate = dueDate;}
    public void setPoints(Integer points) {this.points = points;}
}
