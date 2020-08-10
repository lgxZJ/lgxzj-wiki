package wiki.lgxzj.java.util.json;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class JsonSerializer {
    protected final static Logger logger = LogManager.getLogger(JsonSerializer.class);

    public static String toString(Object obj) {
        try {
            ObjectMapper objectMapper = new ObjectMapper();
            return objectMapper.writeValueAsString(obj);
        } catch (JsonProcessingException e) {
            logger.info("ObjectMapper::writeValueAsString error, msg:{}", e.getMessage());
            return "";
        }
    }
}
