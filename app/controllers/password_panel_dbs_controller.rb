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

  def callFail
    render json: {"message" => "É necessário passar um parâmetro, parâmetros aceitos: normal ou preferencial"}
  end


  def end
   render json: @end_of_attendence
  end

  def cancel
    render json: @response
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
          # Use callbacks to share common setup or constraints between actions.
          def set_password_panel_db
            @password_panel_db = PasswordPanelDb.find(params[:id])
          end
      
          # Only allow a list of trusted parameters through.
          def password_panel_db_params
            params.require(:password_panel_db).permit(:numero, :preferencial, :setor, :servico, :inicio_atendimento, :final_atendimento, :atendente, :cancelado)
          end
      
          def next_password
            passwords_preferencial = PasswordPanelDb.where(preferencial: true, inicio_atendimento: nil).order(created_at: :asc)
            passwords_normal = PasswordPanelDb.where(preferencial: false, inicio_atendimento: nil).order(created_at: :asc)
            @password
      
            if passwords_preferencial.empty? && passwords_normal.empty?
              @password = {"message" => "Nenhuma senha encontrada, aguarde o próximo cliente"}
        
            elsif params[:pref] == 'preferencial' && !passwords_preferencial.empty?
              @password = PasswordPanelDb.find(passwords_preferencial[0].id)
              @password.inicio_atendimento = Time.new
              @password.save
              @password = PasswordPanelDb.find(passwords_preferencial[0].id)
      
            elsif params[:pref] == 'normal' && !passwords_normal.empty?
              @password = PasswordPanelDb.find(passwords_normal[0].id)
              @password.inicio_atendimento = Time.new
              @password.save
              @password = PasswordPanelDb.find(passwords_normal[0].id)
      
            elsif params[:pref] == 'preferencial' && passwords_preferencial.empty? && !passwords_normal.empty?
              @password = PasswordPanelDb.find(passwords_normal[0].id)
              @password.inicio_atendimento = Time.new
              @password.save
              @password = PasswordPanelDb.find(passwords_normal[0].id)
      
            elsif params[:pref] == 'normal' && passwords_normal.empty? && !passwords_preferencial.empty?
              @password = PasswordPanelDb.find(passwords_preferencial[0].id)
              @password.inicio_atendimento = Time.new
              @password.save
              @password = PasswordPanelDb.find(passwords_preferencial[0].id)
            end
          end
      
          def end_password
            password = PasswordPanelDb.select(:id,:cancelado,:final_atendimento).where("id = '#{params[:id]}'")
            password = PasswordPanelDb.find(password[0].id)
            if password.cancelado.trust
              @end_of_attendence = {"message" => "senha cancelada não pode ser finalizada"}
             elsif password.final_atendimento != nil 
              @end_of_attendence = {"message" => "essa senha já foi encerrada"}
            else
              @end_of_attendence = {"message" => "Senha finaliza com sucesso!"}
              password.final_atendimento = Time.new
              password.save
            end
          end
  
          def password_cancel
            cancel = PasswordPanelDb.select(:id,:cancelado).where("id = '#{params[:id]}'")
            @response
      
            
            if cancel.empty?
              @response = {"message" => "Esta senha não existe"}
            elsif cancel[0].cancelado.trust
              num_senha = PasswordPanelDb.find(cancel[0].id)
              @response = {"message" => "senha #{num_senha.numero} já foi cancelada"}
            else
              num_senha = PasswordPanelDb.find(cancel[0].id)
              num_senha.cancelado = true
              num_senha.save
              @response = {"message" => "A senha #{num_senha.numero} foi cancelada"}
            end
          end
  end
