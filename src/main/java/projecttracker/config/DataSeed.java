package projecttracker.config;

import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;
import projecttracker.model.Role;
import projecttracker.model.User;
import projecttracker.repository.UserRepository;
import projecttracker.repository.AssignmentRepository;
import projecttracker.model.Assignment;
import java.time.LocalDateTime;

@Component
public class DataSeed implements CommandLineRunner{
    private static final String Seed_Password = "A1234567ABCDEF8912345";

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final AssignmentRepository assignmentRepository;

    public DataSeed(UserRepository userRepository, PasswordEncoder passwordEncoder, AssignmentRepository assignmentRepository) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
        this.assignmentRepository = assignmentRepository;
    }

    @Override 
    public void run(String... args) {
        User teacher = userRepository.findByEmail("teacher@example.com").orElseGet(() -> userRepository.save(new User("Test", "Teacher", "teacher@example.com", passwordEncoder.encode(Seed_Password), Role.TEACHER)));
        
        User student = userRepository.findByEmail("student@example.com").orElseGet(() -> userRepository.save(new User("Test", "Student", "student@example.com", passwordEncoder.encode(Seed_Password), Role.STUDENT)));

        if (assignmentRepository.count() == 0) {assignmentRepository.save(new Assignment("Sample assignment", "Seeded test assignment for site", LocalDateTime.now(), 100, teacher));}

        System.out.println("Teacher ID: " + teacher.getId() + "\nStudent ID: " + student.getId());
    }
}
