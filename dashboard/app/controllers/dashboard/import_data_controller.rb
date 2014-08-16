module Dashboard
class Dashboard::ImportDataController < ApplicationController
  before_filter :set_app

  def create
    if request.post?
      uploaded_io = params[:datafile]
      dir = Rails.root.join('private', 'importer', 'uploads')
      FileUtils.mkdir_p(dir) unless File.directory?(dir)
      File.open(Rails.root.join(dir, SecureRandom.urlsafe_base64 + ".json"), 'wb') do |file|
        file.write(uploaded_io.read)
      end
    end
  end

  def index

  end
end
end
