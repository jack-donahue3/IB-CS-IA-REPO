package projecttracker.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import projecttracker.model.SchoolClass;

public interface SchoolClassRepository extends JpaRepository<SchoolClass, Integer> {
}