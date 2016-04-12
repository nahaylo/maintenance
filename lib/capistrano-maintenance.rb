module CapistranoMaintenance
  class FileBase < SimpleDelegator
    def initialize(rake)
      super(rake)
    end

    def upload
      upload!(StringIO.new(result), rendered_path + rendered_name)
    end

    def rm
      execute "rm -f #{rendered_path + rendered_name}"
    end

    def chmod
      execute "chmod 644 #{rendered_path + rendered_name}"
    end

    def reason
      ENV['REASON']
    end

    def deadline
      ENV['UNTIL']
    end

    def rendered_path
      "#{shared_path}/public/system/"
    end
  end

  class HtmlFile < FileBase
    def result
      default_template = File.join(File.expand_path('../capistrano/templates', __FILE__), 'maintenance.html.erb')
      template = fetch(:maintenance_template_path, default_template)
      result = ERB.new(File.read(template)).result(binding)
    end

    def rendered_name
      "#{fetch(:maintenance_basename, 'maintenance')}.html"
    end
  end

  class JsonFile < FileBase
    def result
      {
        code: 503,
        reason: reason ? reason : "maintenance",
        deadline: deadline ? deadline : "shortly"
      }.to_json
    end

    def rendered_name
      "#{fetch(:maintenance_basename, 'maintenance')}.json"
    end
  end
end
