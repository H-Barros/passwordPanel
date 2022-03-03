class PasswordPanelDb < ApplicationRecord

  def self.end_password(id)
    password = self.select(:id,:cancelado,:final_atendimento).where("id = '#{id}'")
    password[0] != nil ? password = self.find(password[0].id) : password = "invalid"

    if password = "invalid"
      end_of_attendence = {"message" => "Senha não existe"}
    elsif password.cancelado
      end_of_attendence = {"message" => "Senha cancelada não pode ser finalizada"}
    elsif password.final_atendimento != nil 
      end_of_attendence = {"message" => "Senha finalizada"}
    else
      end_of_attendence = {"message" => "Senha finaliza com sucesso!"}
      password.final_atendimento = Time.new
      password.save
    end

    return end_of_attendence
  end

  def self.cancel_password(id)
    cancel = self.select(:id,:cancelado).where("id = '#{id}'")
            
    if cancel.empty?
      response = {"message" => "Esta senha não existe"}
    elsif cancel[0].cancelado
      num_password = self.find(cancel[0].id)
      response = {"message" => "A senha #{num_password.numero} já foi cancelada"}
    else
      num_password = self.find(cancel[0].id)
      num_password.cancelado = true
      num_password.save
      response = {"message" => "A senha #{num_password.numero} foi cancelada"}
    end

    return response
  end

  def self.next_password
    passwords_preferencial = self.where(preferencial: true, inicio_atendimento: nil).order(created_at: :asc).limit(1)
    passwords_normal = self.where(preferencial: false, inicio_atendimento: nil).order(created_at: :asc).limit(1)
  
    if passwords_preferencial.empty? && passwords_normal.empty?
      password = {"message" => "Nenhuma senha encontrada, aguarde o próximo cliente"}   
    elsif self.verify_order() == 'preferencial' && !passwords_preferencial.empty?
      password = self.find(passwords_preferencial[0].id)
      password.inicio_atendimento = Time.new
      password.save
      password = self.find(passwords_preferencial[0].id)
    elsif self.verify_order() == 'normal' && !passwords_normal.empty?
      password = self.find(passwords_normal[0].id)
      password.inicio_atendimento = Time.new
      password.save
      password = self.find(passwords_normal[0].id)
    elsif self.verify_order() == 'preferencial' && passwords_preferencial.empty? && !passwords_normal.empty?
      password = self.find(passwords_normal[0].id)
      password.inicio_atendimento = Time.new
      password.save
      password = self.find(passwords_normal[0].id)
    elsif self.verify_order() == 'normal' && passwords_normal.empty? && !passwords_preferencial.empty?
      password = self.find(passwords_preferencial[0].id)
      password.inicio_atendimento = Time.new
      password.save
      password = self.find(passwords_preferencial[0].id)
    end
    return password
  end

  def self.report_password(params_date,params_detalle)
    if params_date == nil
      first_date_of_params = Time.now
      last_date_of_params = Time.now

      first_date_of_params.strftime("%Y-%m-%d")
      last_date_of_params.strftime("%Y-%m-%d")

      first_date_format_of_params = "#{first_date_of_params} 00:00:00"
      last_date_format_of_params = "#{last_date_of_params} 23:59:59"
    else
      first_report_date = params_date[0..9]
      last_report_date = params_date[10..19]
      first_date_format = "#{first_report_date} 00:00:00"
      last_date_format = "#{last_report_date} 23:59:59"
    end

      if params_detalle == "completo" 
          result = PasswordPanelDb.select([:numero,:created_at,:setor,:atendente,:preferencial,:cancelado]).where(created_at: first_date_format..last_date_format)
      elsif params_detalle == "setor"
        result = PasswordPanelDb.select([:numero,:created_at,:setor,:preferencial,:cancelado]).where(created_at: first_date_format..last_date_format)
      elsif params_detalle == "servico"
        result = PasswordPanelDb.select([:numero,:created_at,:servico,:preferencial,:cancelado]).where(created_at: first_date_format..last_date_format)
      elsif params_detalle == "atendente"
        result = PasswordPanelDb.select([:numero,:created_at,:atendente,:preferencial,:cancelado]).where(created_at: first_date_format..last_date_format)
      elsif params_detalle == nil
        result = PasswordPanelDb.where(created_at: first_date_format..last_date_format).order(:created_at)
      else
        result = PasswordPanelDb.where(created_at: first_date_format_of_params..last_date_format_of_params).order(:created_at)
      end
        return result
    end


  def self.have_password_in_queue?
    disponible_password = self.where("inicio_atendimento is null")
    
    p "#{disponible_password.length} <<<<<<>>>>>>>"

    return disponible_password.length
  end


  private

  def self.verify_order
    lasts_two_passwords = self.where("inicio_atendimento is null").order(inicio_atendimento: :desc).limit(2)

    if !lasts_two_passwords[0].preferencial 
      return "preferencial"
    elsif lasts_two_passwords[1].preferencial
      return "normal"
    elsif !lasts_two_passwords[1].preferencial
      return "preferencial"
    end
  end
end