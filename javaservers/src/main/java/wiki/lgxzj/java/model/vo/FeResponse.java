package wiki.lgxzj.java.model.vo;

import lombok.*;
import lombok.experimental.SuperBuilder;

@Getter
@Setter
@ToString
@NoArgsConstructor
public class FeResponse<T> extends FeResponseStatus {
    private T data;

    @Builder(builderMethodName = "FeResponseBuilder")
    public FeResponse(T data, FeResponseStatus status) {
        super(status.getCode(), status.getMessage());
        this.data = data;
    }
}
