# An abstract class for asyncronous jobs that transcode files using FFMpeg

require 'tmpdir'
require 'open3'

module Hydra::Derivatives::Processors
  module ShellBasedProcessor
    extend ActiveSupport::Concern

    BLOCK_SIZE = 1024

    included do
      class_attribute :timeout
      extend Open3
    end

    def process
      name = directives.fetch(:label)
      format = directives[:format]
      raise ArgumentError, "You must provide the :format you want to transcode into. You provided #{directives}" unless format
      # TODO if the source is in the correct format, we could just copy it and skip transcoding.
      encode_file(format, options_for(format))
    end

    # override this method in subclass if you want to provide specific options.
    # returns a hash of options that the specific processors use
    def options_for(format)
      {}
    end

    def encode_file(file_suffix, options)
      out_file = nil
      temp_file_name = output_file(file_suffix)
      self.class.encode(source_path, options, temp_file_name)
      output_file_service.call(File.open(temp_file_name, 'rb'), directives)
      File.unlink(temp_file_name)
    end

    def output_file(file_suffix)
      Dir::Tmpname.create(['sufia', ".#{file_suffix}"], Hydra::Derivatives.temp_file_base){}
    end

    module ClassMethods

      def execute(command)
        context = {}
        if timeout
          execute_with_timeout(timeout, command, context)
        else
          execute_without_timeout(command, context)
        end
      end

      def execute_with_timeout(timeout, command, context)
        begin
          status = Timeout::timeout(timeout) do
            execute_without_timeout(command, context)
          end
        rescue Timeout::Error => ex
          pid = context[:pid]
          Process.kill("KILL", pid)
          raise Hydra::Derivatives::TimeoutError, "Unable to execute command \"#{command}\"\nThe command took longer than #{timeout} seconds to execute"
        end

      end

      def execute_without_timeout(command, context)
        exit_status = nil
        err_str = ''
        stdin, stdout, stderr, wait_thr = popen3(command)
        context[:pid] = wait_thr[:pid]
        stdin.close
        stdout.close
        files = [stderr]

        until all_eof?(files) do
          ready = IO.select(files, nil, nil, 60)

          if ready
            readable = ready[0]
            readable.each do |f|
              fileno = f.fileno

              begin
                data = f.read_nonblock(BLOCK_SIZE)

                case fileno
                  when stderr.fileno
                    err_str << data
                end
              rescue EOFError
                Rails.logger "Caught an eof error in ShellBasedProcessor"
                # No big deal.
              end
            end
          end
        end
        exit_status = wait_thr.value

        raise "Unable to execute command \"#{command}\". Exit code: #{exit_status}\nError message: #{err_str}" unless exit_status.success?
      end

      def all_eof?(files)
        files.find { |f| !f.eof }.nil?
      end
    end
  end
end
