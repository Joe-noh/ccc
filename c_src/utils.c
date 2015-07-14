#include <erl_nif.h>
#include <string.h>

ERL_NIF_TERM utils_get_atom(ErlNifEnv* env, const char* name) {
    ERL_NIF_TERM atom;

    if (enif_make_existing_atom(env, name, &atom, ERL_NIF_LATIN1)) {
        return atom;
    }

    return enif_make_atom(env, name);
}

ERL_NIF_TERM utils_ok_atom(ErlNifEnv* env) {
    return utils_get_atom(env, "ok");
}

ERL_NIF_TERM utils_error_atom(ErlNifEnv* env) {
    return utils_get_atom(env, "error");
}

ERL_NIF_TERM utils_chars_to_binary(ErlNifEnv* env, const unsigned char* str, size_t len) {
    unsigned char* bin;
    ERL_NIF_TERM term;

    bin = enif_make_new_binary(env, len, &term);
    memcpy(bin, str, len);

    return term;
}

ERL_NIF_TERM utils_ok_tuple(ErlNifEnv* env, ERL_NIF_TERM term) {
    return enif_make_tuple2(env, utils_ok_atom(env), term);
}

ERL_NIF_TERM utils_error_tuple(ErlNifEnv* env, ERL_NIF_TERM term) {
    return enif_make_tuple2(env, utils_error_atom(env), term);
}

ERL_NIF_TERM utils_error_message(ErlNifEnv* env, char* message) {
    ERL_NIF_TERM term = utils_chars_to_binary(
        env, (const unsigned char *)message, strlen(message)
    );
    return utils_error_tuple(env, term);
}
