module Dashboard

class Dashboard::ImportDataController < ApplicationController
  before_filter :set_app

  require 'json'

  def is_json(str)
    begin
      !!JSON.parse(str)
    rescue
      false
    end
  end

  def create
    errJsonFail = "Import failed because the file you uploaded is not a valid JSON file."

    if request.post?
      uploaded_io = params[:datafile]
      dir = Rails.root.join('private', 'importer', 'uploads')
      FileUtils.mkdir_p(dir) unless File.directory?(dir)
      str = uploaded_io.read
      if is_json(str)
        importerScript = File.expand_path(File.join(Rails.root, "..", "openkit_importer", "Main.coffee"))
        logger.info "importerScript: #{importerScript}"
        fileName = Rails.root.join(dir, SecureRandom.urlsafe_base64 + ".json")

        File.open(fileName, 'w') do |file|
          file.write(str)
        end

        # Turn OKConfig DB user details into NodeJS-parsable commandline params
        dbConfigString = "#{OKConfig[:database_host]} #{OKConfig[:database_username]} #{OKConfig[:database_password]} #{OKConfig[:database_name]}"

        # Run the importer coffeescript-program, check it's result!
        command = "coffee \"#{ importerScript }\" #{dbConfigString} #{@app.id} \"#{ fileName }\""
        logger.info "running #{command}"
        result = system(command)
        logger.info "result: #{result}"

        # Delete temporary upload (we dont need it anymore)
        File.delete fileName

        if result

        else
          @error = errJsonFail
        end
      else
        @error = errJsonFail
      end
    end
  end

  def index

  end
end
end
