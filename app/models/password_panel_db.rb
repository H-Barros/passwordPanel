class PasswordPanelDb < ApplicationRecord

  def self.end_password(id)
    password = self.select(:id,:cancelado,:final_atendimento).where("id = '#{id}'")
    password[0] != nil ? password = self.find(password[0].id) : password = "invalid"

    if password = "invalid"
      end_of_attendence = {"message" => "Senha não existe"}
    elsif password.cancelado.trust
      end_of_attendence = {"message" => "senha cancelada não pode ser finalizada"}
    elsif password.final_atendimento != nil 
      end_of_attendence = {"message" => "essa senha já foi encerrada"}
    else
      end_of_attendence = {"message" => "Senha finaliza com sucesso!"}
      password.final_atendimento = Time.new
      password.save
    end

    return end_of_attendence
  end

  def self.cancel_password(id)
    cancel = PasswordPanelDb.select(:id,:cancelado).where("id = '#{id}'")
            
    if cancel.empty?
      response = {"message" => "Esta senha não existe"}
    elsif cancel[0].cancelado.trust
      num_password = PasswordPanelDb.find(cancel[0].id)
      response = {"message" => "senha #{num_password.numero} já foi cancelada"}
    else
      num_password = PasswordPanelDb.find(cancel[0].id)
      num_password.cancelado = true
      num_password.save
      response = {"message" => "A senha #{num_password.numero} foi cancelada"}
    end

    return response
  end

  def self.next_password(pref)
    passwords_preferencial = PasswordPanelDb.where(preferencial: true, inicio_atendimento: nil).order(created_at: :asc)
    passwords_normal = PasswordPanelDb.where(preferencial: false, inicio_atendimento: nil).order(created_at: :asc)
  
    if passwords_preferencial.empty? && passwords_normal.empty?
      password = {"message" => "Nenhuma senha encontrada, aguarde o próximo cliente"}   
    elsif pref == 'preferencial' && !passwords_preferencial.empty?
      password = PasswordPanelDb.find(passwords_preferencial[0].id)
      password.inicio_atendimento = Time.new
      password.save
      password = PasswordPanelDb.find(passwords_preferencial[0].id)
    elsif pref == 'normal' && !passwords_normal.empty?
      password = PasswordPanelDb.find(passwords_normal[0].id)
      password.inicio_atendimento = Time.new
      password.save
      password = PasswordPanelDb.find(passwords_normal[0].id)
    elsif pref == 'preferencial' && passwords_preferencial.empty? && !passwords_normal.empty?
      password = PasswordPanelDb.find(passwords_normal[0].id)
      password.inicio_atendimento = Time.new
      password.save
      password = PasswordPanelDb.find(passwords_normal[0].id)
    elsif pref == 'normal' && passwords_normal.empty? && !passwords_preferencial.empty?
      password = PasswordPanelDb.find(passwords_preferencial[0].id)
      password.inicio_atendimento = Time.new
      password.save
      password = PasswordPanelDb.find(passwords_preferencial[0].id)
    end
    
      return password
  end
end