# language specific config (you can tweak per language)
ASSIGNMENT ?= ""
FILEEXT := "js"
PATTERN := "$(ASSIGNMENT)_test.spec.$(FILEEXT)"

# output directory
TMPDIR ?= "/tmp"
OUTDIR := $(shell mktemp -d "$(TMPDIR)/$(ASSIGNMENT).XXXXXXXXXX")

# assignments
ASSIGNMENTS = $(shell find . -maxdepth 1 -mindepth 1 -type d | tr -d './' | grep -v 'node_modules')

test-assignment: node_modules
	@echo "running tests for: $(ASSIGNMENT)"
	@cp $(ASSIGNMENT)/$(PATTERN) $(OUTDIR)
	@cp $(ASSIGNMENT)/example.js $(OUTDIR)/$(ASSIGNMENT).$(FILEEXT)
	@./node_modules/.bin/jasmine-node --captureExceptions $(OUTDIR)/$(PATTERN)

test:
	@for assignment in $(ASSIGNMENTS); do ASSIGNMENT=$$assignment $(MAKE) test-assignment || exit 1; done

node_modules: package.json
	@npm prune
	@npm install

