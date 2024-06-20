.PHONY: create-proof-programs-symlinks
create-proof-programs-symlinks:
	cd conformance/proof-programs; ln -s ../cairo-0/*.cairo .

# Compile Cairo Zero Programs

CAIRO_0_DIR=conformance/cairo-0/
CAIRO_0_PROGRAMS:=$(shell find $(CAIRO_0_DIR) -name '*.cairo')
COMPILED_CAIRO_0_PROGRAMS:=$(CAIRO_0_PROGRAMS:%.cairo=%.json)

$(CAIRO_0_DIR)%.json: $(CAIRO_0_DIR)%.cairo
	cairo-compile --cairo_path "$(CAIRO_0_DIR)" $< --output $@

# Compile Cairo Zero Proof Programs

CAIRO_0_PROOF_DIR=conformance/proof-programs/
CAIRO_0_PROOF_PROGRAMS:=$(shell find $(CAIRO_0_PROOF_DIR) -name '*.cairo')
COMPILED_CAIRO_0_PROOF_PROGRAMS:=$(CAIRO_0_PROOF_PROGRAMS:%.cairo=%.json)

$(CAIRO_0_PROOF_DIR)%.json: $(CAIRO_0_PROOF_DIR)%.cairo
	cairo-compile --cairo_path "$(CAIRO_0_PROOF_DIR)" $< --output $@ --proof_mode

compile: $(COMPILED_CAIRO_0_PROGRAMS) $(COMPILED_CAIRO_0_PROOF_PROGRAMS)

# Clean artifacts

.PHONY: clean
clean:
	rm -f $(CAIRO_0_DIR)/*.json
	rm -f $(CAIRO_0_PROOF_DIR)/*.cairo
	rm -f $(CAIRO_0_PROOF_DIR)/*.json
