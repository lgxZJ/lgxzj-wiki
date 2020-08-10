package wiki.lgxzj.java.controller.sqlparser;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import wiki.lgxzj.java.model.bo.sqlparser.ValidateResult;
import wiki.lgxzj.java.model.vo.FeResponse;
import wiki.lgxzj.java.util.sqlparser.MySQLParser;

@RestController
@RequestMapping(path = "/parser/mysql")
public class MySQLParserController {

    @PostMapping(path = "/validate")
    public FeResponse validateMySQL(@RequestBody String sql) {
        MySQLParser parser = new MySQLParser();
        ValidateResult result = parser.validate(sql);
        return new FeResponse<Boolean>()
    }
}
