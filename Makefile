python_bin:=python2.7
version:=3.3.4
python_version:=$(shell $(python_bin) -c 'import sys;print(sys.version_info[0])')
venv_dir:=venv/python$(python_version)-supervisor-$(version)
supervisord:=$(venv_dir)/bin/supervisord
supervisorctl:=$(venv_dir)/bin/supervisorctl


init: $(venv_dir)
	@echo venv_dir=$(venv_dir)
	@echo done...


clean:
	rm -fr ./venv


start: $(venv_dir)
	tmux new-session -d -s test
	tmux split-window -t "test:0"   -v -p 50
	tmux split-window -t "test:0.0" -h -p 50
	tmux send-keys -t "test:0.0" "sudo $(supervisord) -c ./supervisord.conf" Enter
	tmux send-keys -t "test:0.1" "sleep 3 && sudo $(supervisorctl) --serverurl unix:///run/supervisor-test-logfile.sock" Enter "status "  Enter
	tmux send-keys -t "test:0.2" "sudo lsof 2>/dev/null | grep -P '/tmp/main-py.*deleted'"
	tmux select-pane -t "test:0.2"
	tmux attach -t test
	tmux kill-session -t test


venv/python3-supervisor-%:
	$(python_bin) -m venv ./$@
	./$@/bin/python -m pip install supervisor==$*


venv/python2-supervisor-%:
	$(python_bin) -m virtualenv ./$@
	./$@/bin/python -m pip install supervisor==$*


show-fd:
	pgrep --newest supervisord | xargs ls -lh /proc/$$1/fd

