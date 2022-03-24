.PHONY: all
all: format build

FNL_FILES := $(shell find . -name '*.fnl')
LUA_FILES := $(patsubst %.fnl,%.lua,$(FNL_FILES))

.PHONY: format
format:
	@for file in $(FNL_FILES) ; do \
		fnlfmt --fix $$file ; \
	done

.PHONY: build
build: $(LUA_FILES)

%.lua: %.fnl
	@fennel --compile $< > $@
