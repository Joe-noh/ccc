#ifndef UTILS_H
#define UTILS_H

ERL_NIF_TERM utils_get_atom(ErlNifEnv*, const char*);
ERL_NIF_TERM utils_ok_atom(ErlNifEnv*);
ERL_NIF_TERM utils_error_atom(ErlNifEnv*);
ERL_NIF_TERM utils_chars_to_binary(ErlNifEnv*, const unsigned char*, size_t);
ERL_NIF_TERM utils_ok_tuple(ErlNifEnv*, ERL_NIF_TERM);
ERL_NIF_TERM utils_error_tuple(ErlNifEnv*, ERL_NIF_TERM);
ERL_NIF_TERM utils_error_message(ErlNifEnv*, char*);

#endif
