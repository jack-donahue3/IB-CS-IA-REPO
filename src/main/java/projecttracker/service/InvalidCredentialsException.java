package projecttracker.service;

public class InvalidCredentialsException extends RuntimeException {
    //just turns the error message into an http code
    public InvalidCredentialsException(String message) {
        super(message);
    }
}
