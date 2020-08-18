package wiki.lgxzj.java.util.common;

import wiki.lgxzj.java.util.json.JsonSerializer;

public class Common {
    public static <T> T deepCopy(T t) {
        String json = JsonSerializer.toString(t);
        return JsonSerializer.fromString(json, (Class<T>)t.getClass());
    }
}
