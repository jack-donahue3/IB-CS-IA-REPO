package projecttracker.config;

import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;
import projecttracker.model.Role;
import projecttracker.model.User;
import projecttracker.repository.UserRepository;

@Component
public class DataSeed implements CommandLineRunner{
    private static final String Seed_Password = "A1234567ABCDEF8912345";

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    public DataSeed(UserRepository userRepository, PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
    }

    @Override 
    public void run(String... args) {
        User teacher = userRepository.findByEmail("teacher@example.com").orElseGet(() -> userRepository.save(new User("Test", "Teacher", "teacher@example.com", passwordEncoder.encode(Seed_Password), Role.TEACHER)));
        
        User student = userRepository.findByEmail("student@example.com").orElseGet(() -> userRepository.save(new User("Test", "Student", "student@example.com", passwordEncoder.encode(Seed_Password), Role.STUDENT)));

        System.out.println("Teacher ID: " + teacher.getId() + "\nStudent ID: " + student.getId());
    }
}
