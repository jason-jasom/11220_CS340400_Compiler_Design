#define MAX_TABLE_SIZE 5000
typedef struct symbol_entry 
*PTR_SYMB;
struct symbol_entry {
    char *name;
    int scope;
    int offset;
    int id;
    int variant;
    int type;
    int total_args;
    int total_locals;
    int total_local_arr;
    int mode;
    int functor_index; //for argument
} table[MAX_TABLE_SIZE];

enum MODE{GLOBAL_MODE,ARGUMENT_MODE,LOCAL_MODE};
enum TYPE{T_FUNCTION,T_INT,T_ARRAY};

extern int cur_scope;
extern int cur_counter;
extern int local_num;
extern int function_idx;
extern FILE *f_asm;

void start();
int look_up_symbols(char *s);
void set_global_vars(char *s);
void set_local_vars(char *s);
void set_local_array(char *s,int size);
void set_parameters(char *s,int type);
void pop_up_symbol(int scope);
void break_loop(int scope);
void set_scope_and_offset_of_param(char *s,int arg_num);
void free_table();