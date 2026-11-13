package projecttracker.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import projecttracker.model.Assignment;

public interface AssignmentRepository extends JpaRepository<Assignment, Integer> {
}
