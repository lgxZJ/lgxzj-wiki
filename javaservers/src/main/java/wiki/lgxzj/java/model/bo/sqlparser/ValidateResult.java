package wiki.lgxzj.java.model.bo.sqlparser;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
@AllArgsConstructor
public class ValidateResult {
    private boolean valid;
    private String message;
}
