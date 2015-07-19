CC?=clang
ERLANG_PATH:=$(shell elixir -e 'IO.puts "\#{:code.root_dir}/erts-\#{:erlang.system_info :version}/include"')
ERLANG_FLAGS=-I$(ERLANG_PATH)

SO_DIR=priv
SO_NAME=iconv.so

NIF_SRC=$(wildcard c_src/*.c)
NIF_SO=$(SO_DIR)/$(SO_NAME)

OPTIONS=-shared
ifeq ($(shell uname), Darwin)
	OPTIONS+= -dynamiclib -undefined dynamic_lookup
endif

all: $(NIF_SO)

$(NIF_SO): $(SO_DIR)
	$(CC) -fPIC $(ERLANG_FLAGS) $(NIF_SRC) $(OPTIONS) -o $@

$(SO_DIR):
	@mkdir -p $@

.PHONY: all
