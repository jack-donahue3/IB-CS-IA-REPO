package projecttracker.model;

import jakarta.persistence.*;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;
import java.time.LocalDateTime;

@Entity
@Table(name="submission_attempts")
public class SubmissionAttempt {
    @Id 
    @GeneratedValue(strategy=GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne
    @JoinColumn(name = "student_assignment_id", nullable=false)
    private StudentAssignment studentAssignment;

    @Column(name="attempt_number",nullable = false)
    private Integer attemptNumber;

    @Column(name="text_response")
    private String textResponse;

    @Enumerated(EnumType.STRING)
    @JdbcTypeCode(SqlTypes.NAMED_ENUM)
    @Column(name="review_status",nullable = false)
    private SubmissionReviewStatus reviewStatus = SubmissionReviewStatus.AWAITING_REVIEW;

    @Column(name="submitted_at",insertable=false,updatable=false)
    private LocalDateTime submittedAt;

    protected SubmissionAttempt() {}

    public SubmissionAttempt(StudentAssignment studentAssignment, Integer attemptNumber,String textResponse) {
        this.studentAssignment = studentAssignment;
        this.attemptNumber = attemptNumber;
        this.textResponse = textResponse;
    }

    public Integer getId() {return id;}
    public StudentAssignment getStudentAssignment() {return studentAssignment;}
    public Integer getAttemptNumber() {return attemptNumber;}
    public String getTextResponse() { return textResponse;}
    public SubmissionReviewStatus getReviewStatus() {return reviewStatus;}
    public LocalDateTime getSubmittedAt() {return submittedAt;}

    public void setReviewStatus(SubmissionReviewStatus reviewStatus) {this.reviewStatus = reviewStatus;}
    
}
