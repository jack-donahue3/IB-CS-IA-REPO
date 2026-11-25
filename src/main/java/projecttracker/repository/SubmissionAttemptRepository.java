package projecttracker.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import projecttracker.model.SubmissionAttempt;
import java.util.List;
import java.util.Optional;

public interface SubmissionAttemptRepository extends JpaRepository<SubmissionAttempt, Integer> {
    List<SubmissionAttempt> findByStudentAssignmentIdOrderByAttemptNumberAsc(Integer studentAssignmentId);

    Optional<SubmissionAttempt> findTopByStudentAssignmentIdOrderByAttemptNumberDesc(Integer studentAssignmentId);
}