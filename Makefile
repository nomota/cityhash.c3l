all:
	@echo "make build"
	@echo "make clean"

clean:
	rm -f test
	rm -f example
	rm -rf ./obj

build:
	c3c compile cityhash.c3 cityhashcrc.c3 test.c3
	c3c compile cityhash.c3 cityhashcrc.c3 example.c3
