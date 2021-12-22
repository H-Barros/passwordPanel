class PasswordPanelDbsController < ApplicationController
  before_action :set_password_panel_db, only: [:update, :show, :destroy]

  # GET /password_panel_dbs
  def index
    @password_panel_dbs = PasswordPanelDb.all

    render json: @password_panel_dbs
  end

  # GET /password_panel_dbs/1
  def show
    render json: @password_panel_db
  end

  # POST /password_panel_dbs
  def create
    @password_panel_db = PasswordPanelDb.new(password_panel_db_params)

    if @password_panel_db.save
      render json: @password_panel_db, status: :created, location: @password_panel_db
    else
      render json: @password_panel_db.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /password_panel_dbs/1
  def update
    if @password_panel_db.update(password_panel_db_params)
      render json: @password_panel_db
    else
      render json: @password_panel_db.errors, status: :unprocessable_entity
    end
  end

  def chamar
    senhas_sem_atendimento = []

    PasswordPanelDb.all.each do |senha|
      senhas_sem_atendimento << senha if senha.inicioAtendimento == null
    end

    render json: @teste
  end

  # DELETE /password_panel_dbs/1
  def destroy
    @password_panel_db.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_password_panel_db
      @password_panel_db = PasswordPanelDb.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def password_panel_db_params
      params.require(:password_panel_db).permit(:numero, :preferencial, :setor, :servico, :inicioAtendimento, :finalAtendimento, :atendente)
    end
end
