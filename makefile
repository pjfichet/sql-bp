data=librairie

schema.db: schema.sql
	if [ -e $@ ]; then rm $@; fi
	sqlite3 $@ < $<

$(data:%=%.db): %.db: %.sql schema.db
	cp schema.db $@
	sqlite3 $@ < $<

$(data): %: %.db query.sql
	sqlite3 $< < query.sql

clean:
	rm -f schema.db $(data:%=%.db)

.PHONY: clean $(data)
.SECONDARY: $(data:%=%.db)
