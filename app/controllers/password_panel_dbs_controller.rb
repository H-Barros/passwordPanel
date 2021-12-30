class PasswordPanelDbsController < ApplicationController
  before_action :set_password_panel_db, only: [:update, :show, :destroy]
  before_action :next_password, only: [:chamar]
  before_action :password_cancel, only: [:cancel]


  def index
    @password_panel_dbs = PasswordPanelDb.all

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

  def chamar
    render json: @password
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
      passwords_order_created = PasswordPanelDb.order(created_at: :asc)    
      @password
      i = -1 

      loop do
        i += 1

        if i >= passwords_order_created.length
          @password = {"message" => "Don't have more passwords, please await next client"}

          break
        elsif passwords_order_created[i].inicioAtendimento == nil
          @password = PasswordPanelDb.find(passwords_order_created[i].id)
          @password.inicioAtendimento = Time.new
          @password.save
          @password = PasswordPanelDb.find(passwords_order_created[i].id)

          break
        end
      end
    end

    def password_cancel
      cancel = PasswordPanelDb.select(:id).where(params[:id])
      @response

      if cancel.empty?
        @response = {"message" => "This password don't exist"}
      else
        cancel = PasswordPanelDb.find(@cancel[0].id)
        cancel.cancelado = true
        cancel.save
        @response = {"message" => "Password #{cancel.numero} is canceled"}
      end
    end

end
