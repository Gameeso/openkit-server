module Dashboard

class Dashboard::ImportDataController < ApplicationController
  before_filter :set_app
  @@errJsonFail = "Import failed because the file you uploaded is not a valid JSON file."

  require 'json'

  def is_json(str)
    begin
      !!JSON.parse(str)
    rescue
      false
    end
  end

  def create

    if request.post?
      uploaded_io = params[:datafile]
      dir = Rails.root.join('private', 'importer', 'uploads')
      FileUtils.mkdir_p(dir) unless File.directory?(dir)
      str = uploaded_io.read
      if is_json(str)
        secure_key = SecureRandom.urlsafe_base64
        importerScript = File.expand_path(File.join(Rails.root, "..", "openkit_importer", "Main.coffee"))
        logger.info "importerScript: #{importerScript}"
        fileName = Rails.root.join(dir, secure_key + ".json")

        File.open(fileName, 'w') do |file|
          file.write(str)
        end

        # Turn OKConfig DB user details into NodeJS-parsable commandline params
        dbConfigString = "#{OKConfig[:database_host]} #{OKConfig[:database_username]} #{OKConfig[:database_password]} #{OKConfig[:database_name]}"

        # Run the importer coffeescript-program, check it's result!
        secure_key_status = OKRedis.set("secure_key:#{secure_key}", "importing")
        command = "coffee \"#{ importerScript }\" #{dbConfigString} #{@app.id} \"#{ fileName }\" \"#{secure_key}\" &"
        logger.info "running #{command}"
        result = system(command)

        redirect_to app_import_data_path(@app, :secure_key => secure_key)

      else
        @error = @@errJsonFail
      end
    end
  end

  def index
    if request.get?
      secure_key = params[:secure_key]
      secure_key_status = OKRedis.get("secure_key:#{secure_key}")

      logger.info "secure_key_status: #{secure_key_status}"

      if secure_key_status == "importing"
        @running = true
      end

      if secure_key_status == "success"
        @success = true
        OKRedis.del("secure_key:#{secure_key}")
      end

      if secure_key_status == "error"
        @error = @@errJsonFail
      end

    end
  end
end
end
