SRC=$(wildcard *.erl)

compile: $(SRC)
	@erlc -pa . $(SRC)

clean:
	@$(RM) -r *.beam

test: clean compile
	@erl -pa . -eval 'eunit:test(trinary_tests), init:stop().'
