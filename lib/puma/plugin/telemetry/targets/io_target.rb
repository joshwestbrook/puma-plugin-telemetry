# frozen_string_literal: true

require "json"

module Puma
  class Plugin
    module Telemetry
      module Targets
        # Simple IO Target, publishing metrics to STDOUT or logs
        #
        class IOTarget
          # JSON formatter for IO, expects `call` method accepting telemetry hash
          #
          class JSONFormatter
            def self.call(telemetry)
              ::JSON.dump(telemetry.merge(name: "Puma::Plugin::Telemetry", message: "Publish telemetry"))
            end
          end

          def initialize(io: $stdout, formatter: :json)
            @io = io
            @formatter = case formatter
                         when :json then JSONFormatter
                         else formatter
                         end
          end

          def call(telemetry)
            @io.puts(@formatter.call(telemetry))
          end
        end
      end
    end
  end
end