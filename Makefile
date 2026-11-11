# Fenrir Platform: build everything from one place.
.PHONY: all cloud-test console agents run demo clean

VERSION ?= 1.0.0

all: cloud-test console agents

cloud-test:
	cd cloud && python3 -m pip install -q -r requirements-dev.txt && python3 -m pytest -q

console:
	cd console && npm ci --no-audit --no-fund && npm run build

agents:
	$(MAKE) -C agent/linux test agent agent-arm64 VERSION=$(VERSION)
	mkdir -p cloud/downloads && cp dist/linux/fenrir-agent-linux-* cloud/downloads/

# Local all-in-one: API + console on http://localhost:8080 (SQLite).
run: console agents
	cd cloud && FENRIR_PUBLIC_URL=http://localhost:8080 python3 -m uvicorn --factory fenrir_cloud.main:create_app --port 8080

demo:
	cd cloud && python3 -m fenrir_cloud.demo --password "$$FENRIR_ADMIN_PASSWORD"

clean:
	rm -rf dist cloud/downloads console/dist
