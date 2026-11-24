package projecttracker.config;

import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;
import org.springframework.data.domain.Sort;
import projecttracker.model.Role;
import projecttracker.model.User;
import projecttracker.repository.UserRepository;
import projecttracker.repository.AssignmentRepository;
import projecttracker.repository.StudentAssignmentRepository;
import projecttracker.model.StudentAssignment;
import projecttracker.model.Assignment;
import java.time.LocalDateTime;

@Component
public class DataSeed implements CommandLineRunner{
    private static final String Seed_Password = "A1234567ABCDEF8912345";

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final AssignmentRepository assignmentRepository;
    private final StudentAssignmentRepository studentAssignmentRepository;

    public DataSeed(UserRepository userRepository, PasswordEncoder passwordEncoder, AssignmentRepository assignmentRepository, StudentAssignmentRepository studentAssignmentRepository) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
        this.assignmentRepository = assignmentRepository;
        this.studentAssignmentRepository = studentAssignmentRepository;
    }

    @Override 
    public void run(String... args) {
        User teacher = userRepository.findByEmail("teacher@example.com").orElseGet(() -> userRepository.save(new User("Test", "Teacher", "teacher@example.com", passwordEncoder.encode(Seed_Password), Role.TEACHER)));
        
        User student = userRepository.findByEmail("student@example.com").orElseGet(() -> userRepository.save(new User("Test", "Student", "student@example.com", passwordEncoder.encode(Seed_Password), Role.STUDENT)));

        Assignment first = assignmentRepository.findAll(Sort.by("id")).get(0);

        if (studentAssignmentRepository.findByStudentIdAndAssignmentId(student.getId(), first.getId()).isEmpty()) {
            studentAssignmentRepository.save(new StudentAssignment(first, student));
        }

        if (assignmentRepository.count() == 0) {assignmentRepository.save(new Assignment("Sample assignment", "Seeded test assignment for site", LocalDateTime.now(), 100, teacher));}

        System.out.println("Teacher ID: " + teacher.getId() + 
        "\nStudent ID: " + student.getId() + 
        "\nStudent has " + studentAssignmentRepository.findByStudentId(student.getId()).size() + " assignments");
    }
}
