class PasswordPanelDbsController < ApplicationController
  before_action :set_password_panel_db, only: [:update, :show, :destroy]

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
    render json: PasswordPanelDb.next_password()

    PasswordChannel.broadcast_to("password_channel", { title: "Oi" })
  end

  def end_fail
    render json: {"message" => "É necessário passar um parâmetro valido"}
  end

  def cancel_fail
    render json: {"message" => "É necessário passar um parâmetro valido para essa rota"}
  end

  def end
    render json: PasswordPanelDb.end_password(params[:id])
  end

  def cancel
    render json: PasswordPanelDb.cancel_password(params[:id])
  end

  def report
      first_report_date = params[:filter][0..9]
      last_report_date = params[:filter][10..19]
      first_date_format = "#{first_report_date} 00:00:00"
      last_date_format = "#{last_report_date} 23:59:59" 
      result = PasswordPanelDb.where(inicio_atendimento: first_date_format..last_date_format).order(:inicio_atendimento)
      if result.empty?
        render json: {"message" => "Nenhum resultado encontrado"}
      else
        render json: result
      end
  end

private
  def set_password_panel_db
    @password_panel_db = PasswordPanelDb.find(params[:id])
  end
      
  def password_panel_db_params
    params.require(:password_panel_db).permit(:numero, :preferencial, :setor, :servico, :inicio_atendimento, :final_atendimento, :atendente, :cancelado)
  end
end
