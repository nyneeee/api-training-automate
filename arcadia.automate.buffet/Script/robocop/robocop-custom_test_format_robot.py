from robocop.checkers import VisitorChecker
from robocop.rules import Rule, RuleParam, RuleSeverity
from robot.api import Token
from robot.parsing.model.blocks import TestCase, Keyword, For, While
from robot.parsing.model.statements import EmptyLine, Comment
import re


rules = {
    "9801": Rule(
        rule_id="9801",
        name="section-variable-not-lowercase",
        msg="Section variable name should be lowercase",
        severity=RuleSeverity.WARNING
    ),
    "9802": Rule(
        rule_id="9802",
        name="incorrect-prefix-variable",
        msg="Prefix variable name is not in prefix name list",
        severity=RuleSeverity.WARNING
    ),
    "9803": Rule(
        rule_id="9803",
        name="prefix-inappropriate",
        msg="Prefix variable name should not startwith in prefix name list",
        severity=RuleSeverity.WARNING
    ),
    "9901": Rule(
        rule_id="9901",
        name="special-sign-in-testcase",
        msg="There is spcial sign in testcase name",
        severity=RuleSeverity.ERROR
    ),
    "9902": Rule(
        rule_id="9902",
        name="syntax-testcase-number",
        msg="Testcase number is invalid format in testcase name",
        severity=RuleSeverity.ERROR
    ),
    "9903": Rule(
        rule_id="9903",
        name="sleep-keyword",
        msg="Keyword name should not use 'Sleep' keyword",
        severity=RuleSeverity.WARNING
    ),
    "9904": Rule(
        RuleParam(
            name="empty_lines",
            converter=int,
            default=1,
            desc="number of empty lines required between test cases"
        ),
        rule_id="9904",
        name="empty-lines-between-test-cases-ignore-comment",
        msg="Invalid number of empty lines between test cases (%d/%d)",
        severity=RuleSeverity.WARNING
    ),
    "9905": Rule(
        RuleParam(
            name="empty_lines",
            converter=int,
            default=1,
            desc="number of empty lines required between keywords"
        ),
        rule_id="9905",
        name="empty-lines-between-keywords-ignore-comment",
        msg="Invalid number of empty lines between keywords (%d/%d)",
        severity=RuleSeverity.WARNING
    ),
    "9906": Rule(
        RuleParam(
            name="empty_lines",
            converter=int,
            default=1,
            desc="number of allowed consecutive empty lines"
        ),
        rule_id="9905",
        name="consecutive-without-empty-lines",
        msg="Too many empty lines (%s/%s)",
        severity=RuleSeverity.WARNING
    )
}


class CustomRuleTestcase(VisitorChecker):
    reports = (
        "special-sign-in-testcase",
        "syntax-testcase-number", 
        "sleep-keyword",
        "empty-lines-between-test-cases-ignore-comment",
        "empty-lines-between-keywords-ignore-comment",
        "consecutive-without-empty-lines",
    )

    def visit_TestCaseName(self, node):
        '''
        - List sign except in testcase name -
        \ / * | : # &
        '''
        list_sign_except: list = ['`', '~', '!', '@', '#', '$', '%', '^', '&',
                                '*', '(', ')', '+', ':', ';', '[', '{', '}', ']',
                                '\\', '|', ',', '.', '<', '>', '/', '?', '\'', '\"']
        for sign in list_sign_except:
            if sign in node.name:
                self.report("special-sign-in-testcase", node=node, col=node.name.find(sign))
                break

        testcase_name: str = node.name
        str_testcase_name: list = testcase_name.split()
        testcase_number: str = str_testcase_name[0]
        if not re.match('.+_\d+_[F,S]_\d{3}', testcase_number):
            self.report("syntax-testcase-number", node=node)

    def visit_KeywordCall(self, node):
        if 'Sleep' == node.keyword:
            self.report("sleep-keyword", node=node)

    def verify_empty_lines(self, node, check_leading=True):
        """Verify number of consecutive empty lines inside node. Return number of trailing empty lines."""
        empty_lines = 0
        prev_node = None
        non_empty = check_leading  # if check_leading is set to False, we ignore leading empty lines
        last_index = len(node.body) - 1
        for index, child in enumerate(node.body):
            if isinstance(child, EmptyLine):
                if not non_empty:
                    continue
                empty_lines += 1
                prev_node = child
            else:
                non_empty = True
                if empty_lines > 1:
                    self.report(
                        "consecutive-without-empty-lines",
                        empty_lines=empty_lines,
                        allowed_empty_lines=1,
                        node=prev_node,
                    )
                if not isinstance(child, For) and not isinstance(child, While):
                    if child.type == 'COMMENT' and isinstance(prev_node, EmptyLine) and index == last_index:
                        continue
                empty_lines = 0
        return empty_lines

    def visit_TestCaseSection(self, node):
        allowed_empty_lines = -1 if self.templated_suite else 1
        last_index = len(node.body) - 1
        for index, child in enumerate(node.body):
            if not isinstance(child, TestCase):
                continue
            empty_lines = self.verify_empty_lines(child)
            if allowed_empty_lines not in (empty_lines, -1) and index < last_index:
                self.report(
                    "empty-lines-between-test-cases-ignore-comment",
                    empty_lines=empty_lines,
                    allowed_empty_lines=allowed_empty_lines,
                    lineno=child.end_lineno,
                )
        self.generic_visit(node)
    
    def visit_KeywordSection(self, node):
        last_index = len(node.body) - 1
        for index, child in enumerate(node.body):
            if not isinstance(child, Keyword):
                continue
            empty_lines = self.verify_empty_lines(child)
            if 1 not in (empty_lines, -1) and index < last_index:
                self.report(
                    "empty-lines-between-keywords-ignore-comment",
                    empty_lines=empty_lines,
                    allowed_empty_lines=1,
                    lineno=child.end_lineno,
                )
        self.generic_visit(node)


class CustomRuleVariable(VisitorChecker):
    reports = (
        "section-variable-not-lowercase",
        "incorrect-prefix-variable", 
        "prefix-inappropriate",
    )

    def visit_VariableSection(self, node):
        for child in node.body:
            if not child.data_tokens:
                continue
            token = child.data_tokens[0]
            if token.type == Token.VARIABLE and token.value:
                if not token.value.islower():
                    self.report("section-variable-not-lowercase", lineno=token.lineno, col=token.col_offset + 1)

                '''
                - List prefix name -
                Lable             lbl        DropDownList     ddl
                TextBox           txt        Table            tbl
                _____________________        DateTimePicker   dtp
                Button            btn        List             lst
                RadioButton       rdo        ____________________
                Toggle            tgg        MenuList         mnu
                CheckBox          cbx        TabPage          tab
                _____________________        Panel            pnl
                Image             img        ProgressBar      prg
                Icon              icn
                '''
                prefix_name: list = ['lbl', 'txt', 'btn', 'rdo', 'tgg', 'cbx', 'img', 'icn', 'ddl', 'tbl', 'dtp', 'lst', 'mnu', 'tab', 'pnl', 'prg']
                variable: str = token.value
                match_str = re.search('\w+', variable)
                name: str = match_str.group(0)
                str_variable: list = name.split('_')
                # Check in only repository folder
                if not str_variable[0] in prefix_name:
                    self.report("incorrect-prefix-variable", lineno=token.lineno, col=token.col_offset + 1)

                # Check prefix not use in the variable all folder
                if str_variable[0] in prefix_name:
                    self.report("prefix-inappropriate", lineno=token.lineno, col=token.col_offset + 1)
