class PasswordPanelDbsController < ApplicationController
  before_action :set_password_panel_db, only: [:update, :show, :destroy]
  before_action :next_password, only: [:call]
  before_action :password_cancel, only: [:cancel]
  before_action :end_password, only: [:end]

  def index
    @password_panel_dbs = PasswordPanelDb.all.order(:id)

    render json: @password_panel_dbs
  end

  def show
    render json: @password_panel_db
  end

  def create
    @password_panel_db = PasswordPanelDb.new(password_panel_db_params)

    if @password_panel_db.save
      render json: @password_panel_db, status: :created, location: @password_panel_db
    else
      render json: @password_panel_db.errors, status: :unprocessable_entity
    end
  end

  def update
    if @password_panel_db.update(password_panel_db_params)
      render json: @password_panel_db
    else
      render json: @password_panel_db.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @password_panel_db.destroy
  end

  def call
    render json: @password
  end

  def end
   render json: @endOfAttendance
  end

  def cancel
    render json: @response
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_password_panel_db
      @password_panel_db = PasswordPanelDb.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def password_panel_db_params
      params.require(:password_panel_db).permit(:numero, :preferencial, :setor, :servico, :inicioAtendimento, :finalAtendimento, :atendente, :cancelado)
    end

    def next_password
      passwords_preferencial = PasswordPanelDb.where(preferencial: true, inicioAtendimento: nil).order(created_at: :asc)
      passwords_normal = PasswordPanelDb.where(preferencial: false, inicioAtendimento: nil).order(created_at: :asc)
      @password

      if passwords_preferencial.empty? && passwords_normal.empty?
        @password = {"message" => "Don't have more passwords, please await next client"}

      elsif params[:pref] == 'preferencial' && !passwords_preferencial.empty?
        @password = PasswordPanelDb.find(passwords_preferencial[0].id)
        @password.inicioAtendimento = Time.new
        @password.save
        @password = PasswordPanelDb.find(passwords_preferencial[0].id)

      elsif params[:pref] == 'normal' && !passwords_normal.empty?
        @password = PasswordPanelDb.find(passwords_normal[0].id)
        @password.inicioAtendimento = Time.new
        @password.save
        @password = PasswordPanelDb.find(passwords_normal[0].id)

      elsif params[:pref] == 'preferencial' && passwords_preferencial.empty? && !passwords_normal.empty?
        @password = PasswordPanelDb.find(passwords_normal[0].id)
        @password.inicioAtendimento = Time.new
        @password.save
        @password = PasswordPanelDb.find(passwords_normal[0].id)

      elsif params[:pref] == 'normal' && passwords_normal.empty? && !passwords_preferencial.empty?
        @password = PasswordPanelDb.find(passwords_preferencial[0].id)
        @password.inicioAtendimento = Time.new
        @password.save
        @password = PasswordPanelDb.find(passwords_preferencial[0].id)
      end
    end

    def end_password
      password = PasswordPanelDb.select(:id).where("id = '#{params[:id]}'")

      password = PasswordPanelDb.find(password[0].id)
      password.finalAtendimento = Time.new
      password.save

      @endOfAttendance = {"message" => "End of attendance, password finalized"}
    end

    def password_cancel
      cancel = PasswordPanelDb.select(:id).where("id = '#{params[:id]}'")
      @response

      if cancel.empty?
        @response = {"message" => "This password don't exist"}
      else
        cancel = PasswordPanelDb.find(cancel[0].id)
        cancel.cancelado = true
        cancel.save
        @response = {"message" => "Password #{cancel.numero} is canceled"}
      end
    end
end
