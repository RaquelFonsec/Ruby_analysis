# app/controllers/titanic_controller.rb
require 'gruff'

class TitanicController < ApplicationController
  def analysis_chart
    # Dados fictícios para análise do Titanic
    data = {
      "Sobreviventes" => 342,
      "Não Sobreviventes" => 549 - 342
    }

    # Criar uma instância de Gruff::Pie e configurar os dados
    g = Gruff::Pie.new
    g.title = "Análise de Sobreviventes no Titanic"
    data.each do |label, value|
      g.data(label, value)
    end

    # Renderizar a imagem do gráfico
    send_data g.to_blob, type: 'image/png', disposition: 'inline'
  end
end
