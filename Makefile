# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:   #
#                                                     +:+ +:+         +:+     #
#    By: almehmet <almehmet@student.42.fr>          +#+  +:+       +#+        #
#                                                 +#+#+#+#+#+   +#+           #
#    Created: 2025/10/14 17:01:27 by almehmet          #+#    #+#             #
#    Updated: 2025/10/22 16:33:19 by almehmet         ###   ########.fr       #
#                                                                              #
# **************************************************************************** #

TIMEOUT_US		= 400000

.DEFAULT_GOAL	:= m
SHELL			= bash

UTILS_PATH		= utils/
UTILS_SRC		= $(addprefix $(UTILS_PATH), sigsegv.cpp color.cpp check.cpp leaks.cpp)
UTILS_OBJ		= $(UTILS_SRC:$(UTILS_PATH)%.cpp=/tmp/printf_tester_%.o)

TESTS_PATH		= tests/
MANDATORY		= c s p d i u x upperx percent mix
BONUS			= minus 0 dot sharp space +

CC				= g++
CFLAGS			= -g3 -ldl -std=c++11 -I utils/ -I.. $(addprefix -I, $(shell find .. -maxdepth 2 -name "*.h" -exec dirname {} \; | sort -u))

LOG_FILE		= failures.log

UNAME = $(shell uname -s)
ifeq ($(UNAME), Linux)
	VALGRIND = valgrind -q --leak-check=full --track-origins=yes
endif

$(MANDATORY) $(BONUS): %: $(UTILS_OBJ)
	@echo "\033[36m\n── $* ──\033[0m"
	@$(CC) $(CFLAGS) -D TIMEOUT_US=$(TIMEOUT_US) $(UTILS_OBJ) $(TESTS_PATH)$*_test.cpp \
		-L.. -lftprintf -o /tmp/printf_$*_test 2>/dev/null && \
		output=$$(/tmp/printf_$*_test 2>&1) ; \
		echo "$$output" ; \
		if echo "$$output" | grep -qE "KO|SIGSEGV|TIMEOUT"; then \
			echo "=== $* ===" >> $(LOG_FILE) ; \
			echo "$$output" | grep -oE "[0-9]+\.(KO|MKO|SIGSEGV[^ ]*|TIMEOUT)" >> $(LOG_FILE) ; \
			echo "" >> $(LOG_FILE) ; \
		fi ; \
		rm -f /tmp/printf_$*_test

/tmp/printf_tester_%.o: $(UTILS_PATH)%.cpp
	@$(CC) $(CFLAGS) -c $< -o $@

build_printf:
	@make -C .. -s

$(UTILS_OBJ): build_printf

m: $(UTILS_OBJ)
	@rm -f $(LOG_FILE)
	@$(MAKE) $(MANDATORY)
	@if [ -f $(LOG_FILE) ]; then \
		echo "\033[31m\n══════════════════════════════\033[0m" ; \
		echo "\033[31m  FAILURES saved to $(LOG_FILE)\033[0m" ; \
		echo "\033[31m══════════════════════════════\033[0m" ; \
	else \
		echo "\033[32m\n✓ All mandatory tests passed!\033[0m" ; \
	fi

b: $(UTILS_OBJ)
	@rm -f $(LOG_FILE)
	@$(MAKE) $(BONUS)
	@if [ -f $(LOG_FILE) ]; then \
		echo "\033[31m\n══════════════════════════════\033[0m" ; \
		echo "\033[31m  FAILURES saved to $(LOG_FILE)\033[0m" ; \
		echo "\033[31m══════════════════════════════\033[0m" ; \
	else \
		echo "\033[32m\n✓ All bonus tests passed!\033[0m" ; \
	fi

a: $(UTILS_OBJ)
	@rm -f $(LOG_FILE)
	@$(MAKE) $(MANDATORY) $(BONUS)
	@if [ -f $(LOG_FILE) ]; then \
		echo "\033[31m\n══════════════════════════════\033[0m" ; \
		echo "\033[31m  FAILURES saved to $(LOG_FILE)\033[0m" ; \
		echo "\033[31m══════════════════════════════\033[0m" ; \
	else \
		echo "\033[32m\n✓ All tests passed!\033[0m" ; \
	fi

clean:
	@make clean -C .. -s
	@rm -f $(UTILS_OBJ)

fclean:
	@make fclean -C .. -s
	@rm -f /tmp/printf_*_test $(UTILS_OBJ) $(LOG_FILE)

re: fclean m

.PHONY: m b a clean fclean re build_printf $(MANDATORY) $(BONUS)
