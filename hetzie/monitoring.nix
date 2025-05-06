{ config, ... }: {

  config = {

    services = {
      grafana = {
        enable = true;
        settings.server = {
          http_port = 80;
          http_addr = "127.0.0.1";
        };
      };
      prometheus = {
        enable = true;
        listenAddress = "127.0.0.1";
        port = 9001;

        exporters = {
          node = {
            enable = true;
            enabledCollectors = [ "systemd" ];
            listenAddress = "127.0.0.1";
            port = 9002;
          };
        };

        scrapeConfigs = [{
          job_name = "local_node";
          static_configs = [{
            targets = [
              "127.0.0.1:${
                toString config.services.prometheus.exporters.node.port
              }"
            ];
          }];
        }];

      };
    };

  };

}
