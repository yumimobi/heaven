require 'json'

module Heaven
  # Top-level module for providers.
  module Provider
    # The fabric provider.
    class Fabric < DefaultProvider
      def initialize(guid, payload)
        super
        @name = "fabric"
      end

      def task
        deployment_data["task"] || "deploy"
      end

      def execute
        return execute_and_log(["/usr/bin/true"]) if Rails.env.test?

        uuid = SecureRandom.uuid
        random_dir = "#{working_directory}/#{uuid}"
        if File.exist?(random_dir)
          execute_and_log(["rm", "-rf", random_dir])
        end

        log "Cloning #{repository_url} into #{random_dir}"
        execute_and_log(["git", "clone", clone_url, random_dir])

        Dir.chdir(random_dir) do
          log "Fetching the latest code"
          execute_and_log(%w{git checkout .})
          execute_and_log(%w{git clean -fd})
          execute_and_log(%w{git fetch})
          execute_and_log(["git", "reset", "--hard", sha]) unless task == "rollback"

          payload = deployment_data["payload"]
          h = payload["hosts"]
          is_hosts_string = h.instance_of? String
          hosts = is_hosts_string ? h : h.join(",")

          deploy_command_format = hosts.blank?  ?
            "fab -R %{environment} %{task}:branch_name=%{ref}" :
            "fab -H %{hosts} %{task}:branch_name=%{ref},payload=%{payload} --set=environment=%{environment}"
          deploy_string = deploy_command_format % {
            :hosts => hosts,
            :payload => payload.to_json.inspect.gsub(",", "\\,"),
            :environment => environment,
            :task => task,
            :ref => ref
          }

          log "Executing fabric: #{deploy_string}"
          execute_and_log([deploy_string])
        end

        execute_and_log(["rm", "-rf", random_dir])
      end
    end
  end
end
