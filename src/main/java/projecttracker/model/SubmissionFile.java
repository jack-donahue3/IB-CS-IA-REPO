package projecttracker.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name="submission_files")
public class SubmissionFile {
    @Id
    @GeneratedValue(strategy=GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne 
    @JoinColumn(name="submission_attempt_id", nullable=false)
    private SubmissionAttempt submissionAttempt;

    @Column(name="file_name", nullable=false,length=255)
    private String fileName;

    @Column(name="storage_reference",nullable=false)
    private String storageReference;

    @Column(name="file_size")
    private Integer fileSize;

    @Column(name="uploaded_at", insertable=false,updatable=false)
    private LocalDateTime uploadedAt;

    protected SubmissionFile() {}

    public SubmissionFile(SubmissionAttempt submissionAttempt, String fileName, String storageReference, Integer fileSize) {
        this.submissionAttempt = submissionAttempt;
        this.fileName = fileName;
        this.storageReference=storageReference;
        this.fileSize = fileSize;
    }

    public Integer getId() {return id;}
    public SubmissionAttempt getSubmissionAttempt() {return submissionAttempt;}
    public String getFileName() {return fileName;}
    public String getStorageReference() {return storageReference;}
    public Integer getFileSize() {return fileSize;}
    public LocalDateTime getUploadedAt() {return uploadedAt;}
}
