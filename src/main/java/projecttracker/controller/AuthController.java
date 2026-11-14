package projecttracker.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import projecttracker.model.User;
import projecttracker.service.AuthService;
import projecttracker.service.InvalidCredentialsException;

@RestController 
@RequestMapping("/api/auth")
public class AuthController {
    private final AuthService authService;

    //di constructor
    public AuthController(AuthService authService) {
        this.authService = authService;
    }

    public record LoginRequest(String email, String password) {}

    //post mapping, checks credentials
    @PostMapping("/login")
    public User login(@RequestBody LoginRequest request, HttpServletRequest httpRequest) {
        User user = authService.login(request.email(), request.password());
        HttpSession session = httpRequest.getSession();
        httpRequest.changeSessionId();
        session.setAttribute("userId", user.getId());
        session.setAttribute("role", user.getRole());
        return user;
    }

    //logout endpoint, deletes session
    @PostMapping("/logout")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void logout(HttpServletRequest httpRequest) {
        HttpSession session = httpRequest.getSession(false);
        if (session != null) {
            session.invalidate();
        }
    }

    //returns whos logged in
    @GetMapping("/me")
    public User me(HttpServletRequest httpRequest) {
        HttpSession session = httpRequest.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            throw new InvalidCredentialsException("Not logged in");
        }
        return authService.getById((Integer) session.getAttribute("userId"));
    }

    //invalidates incorrect credentials
    @ExceptionHandler(InvalidCredentialsException.class)
    @ResponseStatus(HttpStatus.UNAUTHORIZED)
    public String handleUnauthorized(InvalidCredentialsException e) {
        return e.getMessage(); 
    }
}
