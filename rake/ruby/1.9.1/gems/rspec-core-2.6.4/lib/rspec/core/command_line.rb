module RSpec
  module Core
    class CommandLine
      def initialize(options, configuration=RSpec::configuration, world=RSpec::world)
        if Array === options
          options = ConfigurationOptions.new(options)
          options.parse_options
        end
        @options       = options
        @configuration = configuration
        @world         = world
      end

      def run(err, out)
        @configuration.error_stream = err
        @configuration.output_stream ||= out
        @options.configure(@configuration)
        @configuration.load_spec_files
        @world.announce_filters

        @configuration.reporter.report(@world.example_count) do |reporter|
          begin
            @configuration.run_hook(:before, :suite)
            @world.example_groups.map {|g| g.run(reporter)}.all? ? 0 : 1
          ensure
            @configuration.run_hook(:after, :suite)
          end
        end
      end
    end
  end
end
