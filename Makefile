PRGM = RegFile

CC = iverilog
FLAGS = -Wall -Winfloop

library_input: ${PRGM}.v ${PRGM}_tb.v
	mkdir -p build
	${CC} ${FLAGS} -o build/${PRGM}.vvp ${PRGM}.v ${PRGM}_tb.v
	vvp -n build/${PRGM}.vvp