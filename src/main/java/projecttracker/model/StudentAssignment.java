package projecttracker.model;

import jakarta.persistence.*;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;
import java.time.LocalDateTime;

@Entity 
@Table(name = "student_assignments")
public class StudentAssignment {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne 
    @JoinColumn(name="assignment_id", nullable=false)
    private Assignment assignment;

    @ManyToOne
    @JoinColumn(name="student_id",nullable=false)
    private User student;

    //enums for student assignment
    @Enumerated(EnumType.STRING)
    @JdbcTypeCode(SqlTypes.NAMED_ENUM)
    @Column(name="current_status", nullable=false)
    private StudentAssignmentStatus currentStatus=StudentAssignmentStatus.NOT_SUBMITTED;
    
    @Column(name="assigned_at", insertable=false, updatable=false)
    private LocalDateTime assignedAt;

    protected StudentAssignment() {}

    public StudentAssignment(Assignment assignment, User student) {
        this.assignment = assignment;  
        this.student = student;
    }

    public Integer getId() {return id;}
    public Assignment getAssignment() {return assignment;}
    public User getStudent() {return student;}
    public StudentAssignmentStatus getCurrentStatus() {return currentStatus;}
    public LocalDateTime getAssignedAt() {return assignedAt;}

    public void setCurrentStatus(StudentAssignmentStatus currentStatus) {this.currentStatus = currentStatus;}
}
