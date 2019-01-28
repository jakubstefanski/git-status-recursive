fixtures := .fixtures
local := $(fixtures)/local
remote := $(fixtures)/remote
repos := \
	$(local)/loose-commits \
	$(local)/loose-commits-unstaged-file \
	$(local)/loose-commits-staged-file \
	$(local)/loose-no-commits \
	$(local)/loose-no-commits-unstaged-file \
	$(local)/loose-no-commits-staged-file \
	$(local)/up-to-date

.PHONY: clean sample

clean:
	@rm -rf $(local) $(remote)

sample: clean $(repos)
	@cd $(fixtures) && $(CURDIR)/gsr

$(local):
$(remote):
	@mkdir -p "$@"

$(remote)/%: $(remote)
	@mkdir -p "$@" \
		&& cd "$@" \
		&& git init --quiet --bare

$(local)/loose-commits: $(local)
	@mkdir -p "$@" \
		&& cd "$@" \
		&& git init --quiet \
		&& git config commit.gpgsign false \
		&& echo "$@" > README.md \
		&& git add README.md \
		&& git commit --quiet -m 'Initial commit'

$(local)/loose-commits-unstaged-file: $(local)
	@mkdir -p "$@" \
		&& cd "$@" \
		&& git init --quiet \
		&& git config commit.gpgsign false \
		&& echo "$@" > README.md \
		&& git add README.md \
		&& git commit --quiet -m 'Initial commit' \
		&& echo "$@ - dirty" > README.md

$(local)/loose-commits-staged-file: $(local)
	@mkdir -p "$@" \
		&& cd "$@" \
		&& git init --quiet \
		&& git config commit.gpgsign false \
		&& echo "$@" > README.md \
		&& git add README.md \
		&& git commit --quiet -m 'Initial commit' \
		&& echo "$@ - dirty" > README.md \
		&& git add README.md

$(local)/loose-no-commits: $(local)
	@mkdir -p "$@" \
		&& cd "$@" \
		&& git init --quiet \
		&& git config commit.gpgsign false \

$(local)/loose-no-commits-unstaged-file: $(local)
	@mkdir -p "$@" \
		&& cd "$@" \
		&& git init --quiet \
		&& git config commit.gpgsign false \
		&& echo 'This repository should be loose' > README.md

$(local)/loose-no-commits-staged-file: $(local)
	@mkdir -p "$@" \
		&& cd "$@" \
		&& git init --quiet \
		&& git config commit.gpgsign false \
		&& echo "$@" > README.md \
		&& git add README.md

.SECONDEXPANSION:

$(local)/up-to-date: $(remote)/$$(@F) $(local)
	@mkdir -p "$@" \
		&& cd "$@" \
		&& git init --quiet \
		&& git config commit.gpgsign false \
		&& git remote add origin $(CURDIR)/$< \
		&& echo "$@" > README.md \
		&& git add README.md \
		&& git commit --quiet -m 'Initial commit' \
		&& git push --quiet origin master \
		&& git branch --quiet --set-upstream-to origin/master
