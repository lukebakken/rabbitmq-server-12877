.PHONY: clean start-rmq0 start-rmq1 start-rmq2

start-rmq0:
	sed -e "s|##RMQ0_DIR##|$(CURDIR)/rmq0|g" $(CURDIR)/rmq0/rabbitmq.conf.in > $(CURDIR)/rmq0/rabbitmq.conf
	sed -e "s|##RMQ0_DIR##|$(CURDIR)/rmq0|g" $(CURDIR)/rmq0/rabbitmq-env.conf.in > $(CURDIR)/rmq0/rabbitmq-env.conf
	sed -e "s|##RMQ0_DIR##|$(CURDIR)/rmq0|g" $(CURDIR)/rmq0/inter_node_tls.config.in > $(CURDIR)/rmq0/inter_node_tls.config
	make ERL_INETRC=$(CURDIR)/erl_inetrc LOG=debug USE_LONGNAME='true' RABBITMQ_NODENAME='rabbit0@rmq0.local' RABBITMQ_NODE_PORT=5672 RABBITMQ_ENABLED_PLUGINS='rabbitmq_management,rabbitmq_top' RABBITMQ_CONFIG_FILE="$(CURDIR)/rmq0/rabbitmq.conf" RABBITMQ_CONF_ENV_FILE="$(CURDIR)/rmq0/rabbitmq-env.conf" -C $(CURDIR)/rabbitmq-server run-broker

start-rmq1:
	sed -e "s|##RMQ1_DIR##|$(CURDIR)/rmq1|g" $(CURDIR)/rmq1/rabbitmq.conf.in > $(CURDIR)/rmq1/rabbitmq.conf
	sed -e "s|##RMQ1_DIR##|$(CURDIR)/rmq1|g" $(CURDIR)/rmq1/rabbitmq-env.conf.in > $(CURDIR)/rmq1/rabbitmq-env.conf
	sed -e "s|##RMQ1_DIR##|$(CURDIR)/rmq1|g" $(CURDIR)/rmq1/inter_node_tls.config.in > $(CURDIR)/rmq1/inter_node_tls.config
	make ERL_INETRC=$(CURDIR)/erl_inetrc LOG=debug USE_LONGNAME='true' RABBITMQ_NODENAME='rabbit1@rmq1.local' RABBITMQ_NODE_PORT=5673 RABBITMQ_ENABLED_PLUGINS='rabbitmq_management,rabbitmq_top' RABBITMQ_CONFIG_FILE="$(CURDIR)/rmq1/rabbitmq.conf" RABBITMQ_CONF_ENV_FILE="$(CURDIR)/rmq1/rabbitmq-env.conf" -C $(CURDIR)/rabbitmq-server run-broker

start-rmq2:
	sed -e "s|##RMQ2_DIR##|$(CURDIR)/rmq2|g" $(CURDIR)/rmq2/rabbitmq.conf.in > $(CURDIR)/rmq2/rabbitmq.conf
	sed -e "s|##RMQ2_DIR##|$(CURDIR)/rmq2|g" $(CURDIR)/rmq2/rabbitmq-env.conf.in > $(CURDIR)/rmq2/rabbitmq-env.conf
	sed -e "s|##RMQ2_DIR##|$(CURDIR)/rmq2|g" $(CURDIR)/rmq2/inter_node_tls.config.in > $(CURDIR)/rmq2/inter_node_tls.config
	make ERL_INETRC=$(CURDIR)/erl_inetrc LOG=debug USE_LONGNAME='true' RABBITMQ_NODENAME='rabbit2@rmq2.local' RABBITMQ_NODE_PORT=5674 RABBITMQ_ENABLED_PLUGINS='rabbitmq_management,rabbitmq_top' RABBITMQ_CONFIG_FILE="$(CURDIR)/rmq2/rabbitmq.conf" RABBITMQ_CONF_ENV_FILE="$(CURDIR)/rmq2/rabbitmq-env.conf" -C $(CURDIR)/rabbitmq-server run-broker

clean:
	git clean -xffd
	rm -rf /tmp/rabbitmq-test-instances

$(CURDIR)/tls-gen/basic/result/server_rmq0.local_certificate.pem:
	$(MAKE) -C $(CURDIR)/tls-gen/basic CN=rmq0.local gen
	cp -v $(CURDIR)/tls-gen/basic/result/ca_certificate.pem $(CURDIR)/rmq0
	cp -v $(CURDIR)/tls-gen/basic/result/*rmq0*.pem $(CURDIR)/rmq0
rmq0-cert: $(CURDIR)/tls-gen/basic/result/server_rmq0.local_certificate.pem

$(CURDIR)/tls-gen/basic/result/server_rmq1.local_certificate.pem:
	$(MAKE) -C $(CURDIR)/tls-gen/basic CN=rmq1.local gen-client gen-server
	cp -v $(CURDIR)/tls-gen/basic/result/ca_certificate.pem $(CURDIR)/rmq1
	cp -v $(CURDIR)/tls-gen/basic/result/*rmq1*.pem $(CURDIR)/rmq1
rmq1-cert: $(CURDIR)/tls-gen/basic/result/server_rmq1.local_certificate.pem

$(CURDIR)/tls-gen/basic/result/server_rmq2.local_certificate.pem:
	$(MAKE) -C $(CURDIR)/tls-gen/basic CN=rmq2.local gen-client gen-server
	cp -v $(CURDIR)/tls-gen/basic/result/ca_certificate.pem $(CURDIR)/rmq2
	cp -v $(CURDIR)/tls-gen/basic/result/*rmq2*.pem $(CURDIR)/rmq2
rmq2-cert: $(CURDIR)/tls-gen/basic/result/server_rmq2.local_certificate.pem

certs: rmq0-cert rmq1-cert rmq2-cert
