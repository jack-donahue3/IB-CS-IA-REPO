package projecttracker.service;

import java.util.List;
import java.time.LocalDateTime;
import java.util.NoSuchElementException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import projecttracker.model.Assignment;
import projecttracker.model.Role;
import projecttracker.model.User;
import projecttracker.repository.AssignmentRepository;
import projecttracker.repository.UserRepository;

@Service 
public class AssignmentService {
    
    //unchanging repositories
    private final AssignmentRepository assignmentRepository;
    private final UserRepository userRepository;

    //constructor for dependency injection
    public AssignmentService(AssignmentRepository assignmentRepository, UserRepository userRepository) {
        this.assignmentRepository = assignmentRepository;
        this.userRepository = userRepository;
    }

    //read all assignments
    public List<Assignment> getAll() {return assignmentRepository.findAll();}

    public Assignment getById(Integer id) {return assignmentRepository.findById(id).orElseThrow(() -> new NoSuchElementException(id + " not found"));}

    //create
    @Transactional 
    public Assignment create(String title, String description, LocalDateTime dueDate, Integer points, Integer creatorId) {
        validateTitle(title);
        validatePoints(points);

        if (creatorId == null) {throw new IllegalArgumentException("A creator is required");}

        User creator = userRepository.findById(creatorId).orElseThrow(() -> new NoSuchElementException(creatorId + " not found"));
        
        if (creator.getRole() != Role.TEACHER) {throw new IllegalArgumentException("Teachers only");}

        Assignment assignment = new Assignment(title.trim(), description, dueDate, points, creator);
        return assignmentRepository.save(assignment);
    }

    //update
    @Transactional 
    public Assignment update(Integer id, String title, String description, LocalDateTime dueDate, Integer points) {
        validateTitle(title);
        validatePoints(points);

        Assignment assignment = getById(id);
        assignment.setTitle(title.trim());
        assignment.setDescription(description);
        assignment.setDueDate(dueDate);
        assignment.setPoints(points);
        return assignmentRepository.save(assignment);
    }

    //delete
    @Transactional 
    public void delete(Integer id) {
        assignmentRepository.deleteById(id);
    }

    //validation functions
    private void validateTitle(String title) {
        if (title == null || title.trim().isEmpty()) {
            throw new IllegalArgumentException("Title is required");
        }
        if (title.trim().length()>255) {
            throw new IllegalArgumentException("Title cant be greater than 255 characters");
        }
    }

    private void validatePoints(Integer points) {
        if (points == null) {
            throw new IllegalArgumentException("Points are required");
        }
        if (points < 0) {
            throw new IllegalArgumentException("Points cant be less than 0");
        }
    }
}
