package projecttracker.service;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import projecttracker.model.User;
import projecttracker.repository.UserRepository;

@Service
public class AuthService {
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    //constructor for di
    public AuthService(UserRepository userRepository, PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
    }

    public User login(String email, String password) {
        if (email==null || password==null) {
            throw new InvalidCredentialsException("Email and password must not be null");
        }
        User user = userRepository.findByEmail(email.trim().toLowerCase()).orElseThrow(() -> new InvalidCredentialsException("Invalid email or password"));

        if (!passwordEncoder.matches(password,user.getPasswordHash())) {throw new InvalidCredentialsException("Invalid email or password");}
        return user;
    }

    public User getById(Integer id) {
        return userRepository.findById(id).orElseThrow(() -> new InvalidCredentialsException("User Not found"));
    }
}
