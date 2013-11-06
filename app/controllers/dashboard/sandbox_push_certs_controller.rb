module Dashboard
class SandboxPushCertsController < ApplicationController
  before_filter :set_app

  def new
    @sandbox_push_cert = SandboxPushCert.new(@app.app_key)
  end

  def create
    @sandbox_push_cert        =  SandboxPushCert.new(@app.app_key)
    @sandbox_push_cert.p12    =  params[:sandbox_push_cert]['p12']
    @sandbox_push_cert.p12_pw =  params[:sandbox_push_cert]['p12_pw']

    if @sandbox_push_cert.save
      redirect_to @app, notice: 'Sandbox push cert was successfully created.'
    else
      render action: 'new'
    end
  end

  def destroy
    if @app.sandbox_push_cert.destroy
      redirect_to @app, notice: 'Deleted the sandbox push cert.'
    else
      redirect_to @app, notice: 'Could not delete that push cert, contact lou@openkit.io for help.'
    end
  end
end
end
