package projecttracker.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import projecttracker.model.SubmissionFile;
import java.util.List;

public interface SubmissionFileRepository extends JpaRepository<SubmissionFile, Integer> {
    List<SubmissionFile> findBySubmissionAttemptId(Integer submissionAttemptId);
}
