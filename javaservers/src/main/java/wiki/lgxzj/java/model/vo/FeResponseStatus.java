package wiki.lgxzj.java.model.vo;

import lombok.*;
import lombok.experimental.SuperBuilder;

@Getter
@Setter
@ToString
@AllArgsConstructor
@NoArgsConstructor
public class FeResponseStatus {
    private int code;
    private String message;
}
