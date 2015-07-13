#include <erl_nif.h>

static ERL_NIF_TERM ccc_ok(ErlNifEnv* env, int argc, const ERL_NIF_TERM argv[]) {
    return enif_make_atom(env, "ok");
}

static ErlNifFunc nif_functions[] = {
    {"nif_ok", 0, ccc_ok}
};

ERL_NIF_INIT(Elixir.CCC.Converter, nif_functions, 0, 0, 0, NULL);
