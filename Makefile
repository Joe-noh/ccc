CC=clang
ERLANG_PATH:=$(shell elixir -e 'IO.puts "\#{:code.root_dir}/erts-\#{:erlang.system_info :version}/include"')
ERLANG_FLAGS=-I$(ERLANG_PATH)

NIF_SRC=$(wildcard c_src/*.c)
NIF_SO=priv/iconv.so

OPTIONS=-shared
ifeq ($(shell uname), Darwin)
	OPTIONS+= -dynamiclib -undefined dynamic_lookup
endif

all: $(NIF_SO)

priv:
	@mkdir -p priv

$(NIF_SO): priv
	$(CC) $(ERLANG_FLAGS) $(NIF_SRC) $(OPTIONS) -o priv/iconv.so

.PHONY: all
