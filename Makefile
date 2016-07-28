EXTENSION = provsql
EXTVERSION = $(shell grep default_version $(EXTENSION).control | \
           sed -e "s/default_version[[:space:]]*=[[:space:]]*'\([^']*\)'/\1/")

MODULE_big = provsql
OBJS = $(patsubst %.c,%.o,$(wildcard src/*.c))

DOCS = $(wildcard doc/*.md)
DATA = sql/$(EXTENSION)--$(EXTVERSION).sql
EXTRA_CLEAN = sql/$(EXTENSION)--$(EXTVERSION).sql

TESTS = $(wildcard test/sql/*.sql)
REGRESS = $(patsubst test/sql/%.sql,%,$(TESTS))
REGRESS_OPTS = --inputdir=test --load-language=plpgsql --outputdir=$(shell mktemp -d --tmpdir tmp.provsqlXXXX)

all: $(DATA) $(MODULE_big).so

$(OBJS): $(wildcard src/*.h)

sql/$(EXTENSION)--$(EXTVERSION).sql: sql/$(EXTENSION).sql
	cp $< $@

PG_CONFIG = pg_config
PGXS := $(shell $(PG_CONFIG) --pgxs)
include $(PGXS)