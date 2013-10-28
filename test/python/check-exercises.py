#!/usr/bin/env python
import os
import ast
import imp
import glob
import shutil
import subprocess
import tempfile

def check_assignment(name, test_file, example_name):
    # Returns the exit code of the tests
    workdir = tempfile.mkdtemp(name)
    try:
        test_file_out = os.path.join(workdir, os.path.basename(test_file))
        shutil.copyfile(test_file, test_file_out)
        shutil.copyfile(os.path.join(os.path.dirname(test_file), 'example.py'),
                        os.path.join(workdir, '{}.py'.format(example_name)))
        return subprocess.call(['python', test_file_out])
    finally:
        shutil.rmtree(workdir)

def modname_heuristic(test_file):
    with open(test_file) as f:
        tree = ast.parse(f.read(), filename=test_file)
    # return the first nonexistent module that the tests import
    for node in ast.walk(tree):
        for modname in possible_module_names(node):
            if is_module_missing(modname):
                return modname

def possible_module_names(node):
    if isinstance(node, ast.Import):
        for alias in node.names:
            yield alias.name
    elif isinstance(node, ast.ImportFrom):
        yield node.module

def is_module_missing(modname):
    try:
        imp.find_module(modname)
    except ImportError:
        return True
    else:
        return False

def assignment_name(test_file):
    return os.path.basename(test_file).rpartition('_')[0]

def main():
    failures = []
    for test_file in glob.glob('assignments/python/*/*_test.py'):
        name = assignment_name(test_file)
        if check_assignment(name, test_file, modname_heuristic(test_file)):
            failures.append(name)
    if failures:
        print 'FAILURES: ' + ' '.join(failures)
        raise SystemExit(1)
    else:
        print 'SUCCESS!'

if __name__ == '__main__':
    main()
