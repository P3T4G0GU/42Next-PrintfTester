# printfTester
> A fast, detailed tester for the **ft_printf** project at 42 school.

## Setup

Clone this tester **inside** your ft_printf project:

```bash
cd inside the  printfTester
```

The Makefile automatically looks for your ft_printf one level up (`../`).
Your ft_printf folder must contain:
- A `Makefile` that produces `libftprintf.a`
- A `ft_printf.h` header

---

##  Usage

### Run all mandatory tests
```bash
make
# or
make m
```

### Run a single category
```bash
make c          # %c tests
make s          # %s tests
make d          # %d tests
make i          # %i tests
make u          # %u tests
make x          # %x tests
make upperx     # %X tests
make percent    # %% tests
make mix        # mixed specifiers
make minus      # - flag (bonus)
make 0          # 0 flag (bonus)
make dot        # . precision (bonus)
make sharp      # # flag (bonus)
make space      # ' ' space flag (bonus)
make +          # + flag (bonus)
```

### Run a specific test number within a category
```bash
make d 5        # runs only test 5 from d_test.cpp and shows full debug info
make s 3        # runs only test 3 from s_test.cpp
```

When you pass a test number it shows:
- The exact format string and arguments used
- What `printf` outputted and its return value
- What `ft_printf` outputted and its return value

### Clean up
```bash
make clean      # clean ft_printf objects
make fclean     # clean everything including temp files and failures.log
make re         # fclean + full rebuild and rerun
```

---

##Output legend

Each category prints its results inline:

```
── d ──
1.OK 2.OK 3.KO 4.OK 5.TIMEOUT
```

| Output | Meaning |
|--------|---------|
| `N.OK` | Test N passed — output and return value match |
| `N.KO` | Test N failed — output or return value didn't match |
| `N.SIGSEGV` | Your function caused a segfault on test N |
| `N.TIMEOUT` | Your function hung for longer than 400ms on test N |
| `LEAKS.KO` | Memory was allocated but not freed |

Colors:
- 🔵 **Blue** = pass (OK)
- 🔴 **Red** = fail (KO / LEAKS.KO / SIGSEGV / TIMEOUT)

---

## 🔍 How tests work

Each test forks a child process that:
1. Redirects stdout to a pipe
2. Runs the real `printf` and captures output + return value
3. Runs your `ft_printf` and captures output + return value
4. Compares both — if output string AND return value match → OK, else → KO

The parent process gives the child **400ms** to finish. If it takes longer → TIMEOUT.

This means your ft_printf is tested against the real libc printf output, not hardcoded expected values.

---

## failures.log

When any test fails the tester saves a `failures.log` in the tester directory:

```
=== d ===
3.KO
7.KO

=== mix ===
1.KO
```

To debug a specific failure, run that category with the test number:

```bash
make d 3
```

This shows the exact format string, arguments, and both outputs side by side so you can see exactly what went wrong.

---

##  Fast compilation

This tester compiles your libftprintf **once** and the 4 utils files **once** at the start. Each individual test then just compiles its small test file and links — taking milliseconds per category instead of recompiling everything every time.

---

## If all tests pass but Moulinette still fails

- Make sure your Makefile compiles with `-Wall -Wextra -Werror` and no warnings
- Make sure your library is named `libftprintf.a` (not `libft_printf.a` or anything else)
- Check that `ft_printf.h` declares `int ft_printf(const char *format, ...)`
- The `%p` output format must match exactly — most campuses expect `0x` prefix even for null
- For `%%` make sure you return 1 (one char written), not 0
- Run under valgrind manually if you suspect memory issues:
  ```bash
  valgrind --leak-check=full ./d_test
  ```

- Original tester: [Tripouille/printfTester](https://github.com/Tripouille/printfTester)
