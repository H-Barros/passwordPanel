require "test_helper"

class PasswordPanelDbsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @password_panel_db = password_panel_dbs(:one)
  end

  test "should get index" do
    get password_panel_dbs_url, as: :json
    assert_response :success
  end

  test "should create password_panel_db" do
    assert_difference('PasswordPanelDb.count') do
      post password_panel_dbs_url, params: { password_panel_db: { atendente: @password_panel_db.atendente, finalAtendimento: @password_panel_db.finalAtendimento, inicioAtendimento: @password_panel_db.inicioAtendimento, numero: @password_panel_db.numero, preferencial: @password_panel_db.preferencial, servico: @password_panel_db.servico, setor: @password_panel_db.setor } }, as: :json
    end

    assert_response 201
  end

  test "should show password_panel_db" do
    get password_panel_db_url(@password_panel_db), as: :json
    assert_response :success
  end

  test "should update password_panel_db" do
    patch password_panel_db_url(@password_panel_db), params: { password_panel_db: { atendente: @password_panel_db.atendente, finalAtendimento: @password_panel_db.finalAtendimento, inicioAtendimento: @password_panel_db.inicioAtendimento, numero: @password_panel_db.numero, preferencial: @password_panel_db.preferencial, servico: @password_panel_db.servico, setor: @password_panel_db.setor } }, as: :json
    assert_response 200
  end

  test "should destroy password_panel_db" do
    assert_difference('PasswordPanelDb.count', -1) do
      delete password_panel_db_url(@password_panel_db), as: :json
    end

    assert_response 204
  end
end
