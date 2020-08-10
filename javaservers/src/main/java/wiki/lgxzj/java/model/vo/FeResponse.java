package wiki.lgxzj.java.model.vo;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
@AllArgsConstructor
public class FeResponse<T> extends FeResponseStatus {
    private T data;
}
