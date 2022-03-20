#!/usr/bin/env python
# -*- coding: utf-8 -*-
# type: ignore
import ast
import codecs
import logging
from markdown.extensions import Extension
from markdown.preprocessors import Preprocessor
from markdown.core import Markdown
import os.path
import re
from typing import Any, Dict, List, Optional


logger = logging.getLogger(__name__)


# first group is before the .f90
INC_SYNTAX = re.compile(r'\{#(.+?\.(f90|py))(\.)(.\w+)(\.)?(.\w+)?#\}')


class MarkdownFortran(Extension):
    """
    """

    def __init__(self, configs: Dict[Any, Any] = {}) -> None:
        """
        """
        self.config = {
            'base_path': ['.', 'Default location to evaluate relative paths.'],
            'encoding': ['utf-8', 'Encoding of included files.'],
            'inheritHeadingDepth': [False, 'Increase included file heading.'],
            'offset': [0, 'Increases heading depth by this amount.'],
            'throw_exception': [True, 'Print warning and continue parsing.']
        }
        for key, value in configs.items():
            self.setConfig(key, value)

    def extendMarkdown(self, md: Markdown, md_globals: Dict[Any, Any]) -> None:
        prep = FortranPreprocessor(md, self.getConfigs())
        md.preprocessors.register(prep, 'wrap', 102)


class FortranPreprocessor(Preprocessor):
    """
    """

    def __init__(self, md: Markdown, config: Dict[Any, Any]) -> None:
        super(FortranPreprocessor, self).__init__(md)
        self.base_path = config['base_path']
        self.encoding = config['encoding']
        self.inheritHeadingDepth = config['inheritHeadingDepth']
        self.offset = config['offset']
        self.throw_exception = config['throw_exception']

    def run(self, lines: List[str]) -> List[str]:
        while True:
            for loc, line in enumerate(lines):
                m = INC_SYNTAX.search(line)
                if m:
                    lead_spaces = ' ' * (len(line) - len(line.lstrip(' ')))
                    file_name = os.path.expanduser(m.group(1))
                    extn_name = m.group(2)
                    func_name = m.group(4)
                    include_doc = m.group(6)
                    if not os.path.isabs(file_name):
                        file_name = os.path.normpath(
                            os.path.join(self.base_path, file_name)
                        )
                    try:
                        with codecs.open(file_name, 'r', encoding=self.encoding) as r:
                            text = r.readlines()
                    except Exception as e:
                        if self.throw_exception:
                            raise e
                        else:
                            logger.warn(
                                'File not found: {}.'.format(file_name))
                            logger.exception(e)
                            lines[loc] = INC_SYNTAX.sub('', line)
                            break
                    line_split = INC_SYNTAX.split(line)
                    t = ''
                    for i in range(len(text)):
                        t += text[i]

                    if extn_name == 'f90':
                        f = FDocStrings(t, func_name)
                    elif extn_name == 'py':
                        f = PyDocString(t, func_name)
                    else:
                        raise ValueError('File extension not supported')

                    if include_doc:
                        added_string = f.get_docstring()
                    elif func_name == 'doc':  # for python
                        added_string = f.get_docstring()
                    else:
                        added_string = f.get_code()

                    added_string = added_string.replace('\r', '').split('\n')
                    for i, n in enumerate(added_string):
                        added_string[i] = '{}{}\n'.format(lead_spaces, n)
                    added_string = ''.join(added_string)
                    lines = lines[:loc] + [added_string] + lines[loc+1:]
            else:
                break
        return lines


def makeExtension(*args, **kwargs):
    return MarkdownFortran(kwargs)


class FSubroutine:
    def __init__(self, block: str) -> None:
        self.__p = re.compile(
            'subroutine\s([\s\S]*?)\(')  # get subroutine name
        # find the doc string delimited with "!>"
        self.__doc = re.findall('!>.+?(.*)', block)
        self.__block = block  # re.split('\n|\r', block)
        self.__name = self._get_name()

    @property
    def block(self) -> str:
        return self.__block

    @property
    def doc(self) -> str:
        t = ''
        for d in self.__doc:
            t = t + d.replace('\r', '\n')
        return t

    def _get_name(self) -> str:
        return self.__p.search(self.__block).group(1)


class FDocStrings:
    def __init__(self, text: List[str], func_name: Optional[str]) -> None:
        self.__text: str = ''
        self.__subroutines: List[FSubroutine] = []
        pattern_sub = '(\s?.*(?:subroutine.*)([\s\S]*?)(?:end subroutine.*)+)'
        pattern_doc = '!>.+?(.*)'  # find the doc string delimited with "!>"
        blocks = re.findall(pattern_sub, text)
        doc = re.findall(pattern_doc, text)

        if func_name == 'doc':
            s = FSubroutine(text)
            self.__subroutines.append(s)
        else:
            for b in blocks:
                s = FSubroutine(b[0][1::])
                if func_name == s._get_name():
                    self.__subroutines.append(s)
                elif not func_name:
                    self.__subroutines.append(s)

    def get_code(self) -> str:
        t = ''
        for s in self.__subroutines:
            t += s.block
        return t

    def get_docstring(self) -> str:
        t = ''
        for s in self.__subroutines:
            t += s.doc
        return t


class PyDocString:
    def __init__(self, text: List[str], func_name: Optional[str]) -> None:
        self.__text: str = ''
        self.__subroutines: List[FSubroutine] = []

        if func_name == 'doc':
            p = ast.parse(text)
            self.__text = ast.get_docstring(p)
        elif func_name:
            self.__text = self._get_function(text, func_name)
        else:
            pass

    def get_code(self) -> str:
        return self.__text

    def get_docstring(self) -> str:
        return self.__text

    def _get_function(self, text, func_name) -> str:
        p = ast.parse(text)
        for n in ast.walk(p):
            if type(n) == ast.FunctionDef:
                if n.name == func_name:
                    return ast.get_source_segment(text, n, padded=True)
        raise ValueError('Function not found: {}'.format(func_name))
