namespace :maintenance do
  namespace :enable do
    desc "Turn on maintenance mode for HTML only"
    task :html do
      on roles(:web) do
        require 'erb'

        file = CapistranoMaintenance::HtmlFile.new(self)
        file.upload
        file.chmod
      end
    end

    desc "Turn on maintenance mode for JSON only"
    task :json do
      on roles(:web) do
        require 'erb'
        require 'json'

        file = CapistranoMaintenance::JsonFile.new(self)
        file.upload
        file.chmod
      end
    end
  end

  desc "Turn on maintenance mode for HTML and JSON"
  task :enable => ["enable:html", "enable:json"]

  namespace :disable do
    desc "Turn off maintenance mode for HTML only"
    task :html do
      on roles(:web) do
        CapistranoMaintenance::HtmlFile.new(self).rm
      end
    end

    desc "Turn off maintenance mode for JSON only"
    task :json do
      on roles(:web) do
        CapistranoMaintenance::JsonFile.new(self).rm
      end
    end
  end

  desc "Turn off maintenance mode for HTML and JSON"
  task :disable => ["disable:html", "disable:json"]
end
