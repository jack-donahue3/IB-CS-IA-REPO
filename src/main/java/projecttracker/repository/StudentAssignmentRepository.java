package projecttracker.repository;

import java.util.List;
import java.util.Optional;
import projecttracker.model.StudentAssignment;
import org.springframework.data.jpa.repository.JpaRepository;

public interface StudentAssignmentRepository extends JpaRepository<StudentAssignment, Integer> {
    List<StudentAssignment> findByStudentId(Integer studentId);

    Optional<StudentAssignment> findByStudentIdAndAssignmentId(Integer studentId, Integer assignmentId);

    List<StudentAssignment> findByAssignmentId(Integer assignmentId);
}
